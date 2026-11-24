// Rex integration for pi. Linked into ~/.pi/agent/extensions by pi/pi.install.
//
// Rex's own setup (`rex skill setup --agent pi`) installs only the skill,
// because pi has no command hooks. This extension does the hook's job: at
// session start it asks Rex which session and pane pi runs in, and adds that
// text to the system prompt, as Claude Code's SessionStart hook does.

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export default function (pi: ExtensionAPI) {
  let context = "";

  pi.on("session_start", async (_event, ctx) => {
    context = "";
    if (!process.env.REX_SESSION) return;

    try {
      const result = await pi.exec("rex", ["__internal", "session-start", "--agent", "pi"], {
        signal: ctx.signal,
        timeout: 5000,
      });
      if (result.code === 0) context = result.stdout.trim();
    } catch {
      // Not fatal: pi works the same without Rex context.
    }
  });

  pi.on("before_agent_start", async (event) => {
    if (!context) return;
    return { systemPrompt: `${event.systemPrompt}\n\n${context}` };
  });
}
