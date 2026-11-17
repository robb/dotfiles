-- Rex config, migrated from Ghostty.

-- cmd+k clears the terminal, as in Ghostty; the session picker moves to cmd+p.
rex.bind("cmd+k", "com.superlogical.terminal.clear")
rex.bind("cmd+p", "session.switch")

-- Show Rex from any app, or hide it (was Ghostty's global:cmd+\ toggle_visibility).
rex.bind("cmd+\\", "client.visibility.toggle")

-- Give cmd+enter back to the terminal; splits stay on cmd+d / shift+cmd+d.
rex.unbind("cmd+enter")
