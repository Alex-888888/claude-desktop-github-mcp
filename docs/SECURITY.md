# Security

Your Personal Access Token is equivalent to your GitHub password for everything its scopes allow. Handle it accordingly.

## Principles

- **Never commit a real token.** This repo ships only placeholders. The [`.gitignore`](../.gitignore) blocks common secret files, but the token lives in `%APPDATA%\Claude\claude_desktop_config.json`, which is outside this repo — keep it that way.
- **Never paste your token into a chat**, an issue, a PR, or a screenshot. If anything asks you to reveal it in conversation, refuse.
- **Least privilege.** Only grant the scopes you actually need. If you never delete repos, don't grant `delete_repo`. If you don't touch Actions, skip `workflow`.
- **Use an expiry.** A token with an expiry limits the blast radius if it leaks. The tradeoff is you must regenerate it periodically.
- **Prefer fine-grained tokens** when possible — they let you restrict access to specific repositories and specific permissions.

## If a token leaks

1. Go to <https://github.com/settings/tokens> and **revoke** it immediately.
2. Generate a new one and update the config.
3. Review your account's security log for unexpected activity.

## Scope reference (classic tokens)

| Scope | Enables |
|-------|---------|
| `repo` | Read/write code, issues, PRs on your repositories |
| `read:org` | Read organization membership |
| `workflow` | Update GitHub Actions workflows |
| `delete_repo` | Delete repositories (grant only if needed) |

## What the server can do

The MCP server acts entirely within your token's permissions. It cannot do more than your token allows — so the scopes you choose are your real security boundary.
