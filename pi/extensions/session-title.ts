// Name pi sessions after their task. Linked into ~/.pi/agent/extensions by pi/pi.install.
//
// pi shows the session name in its footer, in /resume and in the terminal
// title ("π - <name> - <cwd>"), but it only has one if you set it with /name.
// After the first prompt of an unnamed session, this asks the current model
// for a short title, as Claude Code does, and sets it as the session name.
// The request runs alongside the agent's run and doesn't delay it.

import { uuidv7 } from "@earendil-works/pi-ai";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const PROMPT = `Write a title of three to six words for the coding task below, in sentence case, like "Fix login redirect loop". Reply with the title only: no quotes, no trailing period.

<task>
{task}
</task>`;

function clean(text: string): string | undefined {
  const title = text
    .split("\n")
    .map((line) => line.trim())
    .find(Boolean)
    ?.replace(/^["'`*#\s]+|["'`*.\s]+$/g, "")
    .slice(0, 60);
  return title || undefined;
}

export default function (pi: ExtensionAPI) {
  let pending = false;

  pi.on("before_agent_start", async (event, ctx) => {
    if (event.messageType !== "user" || !event.prompt?.trim()) return;
    if (pending || pi.getSessionName() || !ctx.model) return;

    pending = true;
    const task = event.prompt.slice(0, 4000);

    ctx.modelRegistry
      .complete(
        ctx.model,
        {
          messages: [
            {
              role: "user" as const,
              content: [{ type: "text" as const, text: PROMPT.replace("{task}", task) }],
              timestamp: Date.now(),
            },
          ],
        },
        { cacheRetention: "none", sessionId: uuidv7() },
      )
      .then((response) => {
        const text = response.content
          .filter((c): c is { type: "text"; text: string } => c.type === "text")
          .map((c) => c.text)
          .join("\n");
        const title = clean(text);
        // /name may have been used while the request ran.
        if (title && !pi.getSessionName()) pi.setSessionName(title);
      })
      .catch(() => {})
      .finally(() => {
        pending = false;
      });
  });
}
