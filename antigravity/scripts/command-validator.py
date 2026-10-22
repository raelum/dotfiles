#!/usr/bin/env python3
"""PreToolUse hook that validates shell commands before execution and returns an allow or deny decision."""

import json
import re
import sys

def check_command(cmd: str) -> dict:
    if not cmd:
        return {"decision": "allow"}

    # Block catastrophic wipes (root, home, and naked wildcards)
    wipe_pattern = r"\brm\s+-[^\s]*r[^\s]*\s+(?:/|/\*|~|~/|~/\*|\$HOME|\$HOME/|\$HOME/\*|\*|\.\*)(?:\s|$)"
    if re.search(wipe_pattern, cmd):
        return {
            "decision": "deny",
            "reason": "Destructive deletion of root, home, or naked wildcards is prohibited."
        }

    # Enforce Jujutsu over Git
    if re.search(r"(?:^|[;&|]\s*)git(?:\s+.*|$)", cmd):
        return {
            "decision": "deny",
            "reason": "Prefer using Jujutsu (jj) for all version control."
        }

    # Restrict Jujutsu (jj) to read-only subcommands
    for match in re.finditer(r"(?:^|[;&|]\s*)jj(?:\s+(.*?))?(?=[;&|]|$)", cmd):
        args_str = (match.group(1) or "").strip()
        if not args_str:
            continue

        allowed_patterns = [
            r"^(?:help\b|-h\b|--help\b|version\b|--version\b)",
            r"^(?:status\b|st\b)",
            r"^diff\b",
            r"^log\b",
            r"^show\b",
            r"^file\s+(?:show|list)\b",
            r"^root\b",
            r"^config\s+(?:get|list)\b",
            r"^git\s+(?:init|root)\b",
        ]

        if not any(re.search(pat, args_str) for pat in allowed_patterns):
            return {
                "decision": "deny",
                "reason": (
                    f"Command \"jj {args_str}\" is prohibited. Mutating Jujutsu (jj) commands are "
                    "reserved for the user. All changes must remain uncommitted in the working copy for review."
                )
            }

    return {"decision": "allow"}

def main():
    try:
        # Deny if invoked with empty input
        raw_input = sys.stdin.read().strip()
        if not raw_input:
            print(json.dumps({
                "decision": "deny",
                "reason": "Command validator error: Received empty payload on stdin."
            }))
            return

        # Pass through non-shell tools without inspection
        payload = json.loads(raw_input)
        tool_call = payload.get("toolCall", {})
        if tool_call.get("name") != "run_command":
            print(json.dumps({"decision": "allow"}))
            return

        # Validate shell command against security and VCS rules
        cmd = tool_call.get("args", {}).get("CommandLine", "")
        result = check_command(cmd)
        print(json.dumps(result))

    except Exception as exc:
        # Convert exceptions into a structured denial
        print(json.dumps({
            "decision": "deny",
            "reason": f"Command validator error: {exc}"
        }))

if __name__ == "__main__":
    main()
