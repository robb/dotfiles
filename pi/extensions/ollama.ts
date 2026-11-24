// Start Ollama when pi needs it. Linked into ~/.pi/agent/extensions by pi/pi.install.
//
// When the active model is served by a local Ollama (provider "ollama", or a
// base URL on port 11434) and nothing answers there, this starts
// `ollama serve` in the background and waits for it before the request goes
// out. The server keeps running after pi exits, like `ollama serve` would.

import { spawn } from "node:child_process";
import { mkdirSync, openSync } from "node:fs";
import { homedir } from "node:os";
import { join } from "node:path";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

type Model = { provider: string; baseUrl: string } | undefined;

function ollamaOrigin(model: Model): string | undefined {
  if (!model) return;
  let url: URL;
  try {
    url = new URL(model.baseUrl);
  } catch {
    return;
  }
  const local = ["localhost", "127.0.0.1", "[::1]", "0.0.0.0"].includes(url.hostname);
  if (!local) return;
  if (model.provider === "ollama" || url.port === "11434") return url.origin;
}

async function isUp(origin: string): Promise<boolean> {
  try {
    const response = await fetch(`${origin}/api/version`, { signal: AbortSignal.timeout(1000) });
    return response.ok;
  } catch {
    return false;
  }
}

export default function (pi: ExtensionAPI) {
  let starting: Promise<boolean> | undefined;

  async function start(origin: string): Promise<boolean> {
    const logs = join(homedir(), ".ollama", "logs");
    mkdirSync(logs, { recursive: true });
    const log = openSync(join(logs, "pi-serve.log"), "a");

    const child = spawn("ollama", ["serve"], {
      detached: true,
      stdio: ["ignore", log, log],
      env: { ...process.env, OLLAMA_HOST: new URL(origin).host },
    });
    child.on("error", () => {});
    child.unref();

    for (let i = 0; i < 60; i++) {
      if (await isUp(origin)) return true;
      if (child.exitCode !== null) return false;
      await new Promise((resolve) => setTimeout(resolve, 250));
    }
    return false;
  }

  async function ensure(model: Model, ctx: { ui: { notify(message: string, level: "info" | "error"): void } }) {
    const origin = ollamaOrigin(model);
    if (!origin || (await isUp(origin))) return;

    if (!starting) {
      ctx.ui.notify("Starting Ollama…", "info");
      starting = start(origin).finally(() => {
        starting = undefined;
      });
    }
    if (!(await starting)) {
      ctx.ui.notify("Ollama didn't start; see ~/.ollama/logs/pi-serve.log", "error");
    }
  }

  // Start early when an Ollama model is picked, so the first prompt waits less.
  pi.on("session_start", async (_event, ctx) => void ensure(ctx.model, ctx));
  pi.on("model_select", async (event, ctx) => void ensure(event.model, ctx));

  // And make sure it is up before each run.
  pi.on("before_agent_start", async (_event, ctx) => {
    await ensure(ctx.model, ctx);
  });
}
