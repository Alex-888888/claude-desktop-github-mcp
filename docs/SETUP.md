# Setup — Claude Desktop ↔ GitHub (MCP)

Step-by-step setup on Windows. Estimated time: 5–10 minutes.

## Prerequisites

- **Claude Desktop** installed.
- **Docker Desktop** installed and **running** (the MCP server runs in a container).
- A **GitHub account**.

## 1. Pull the official image

Open PowerShell and run:

```powershell
docker pull ghcr.io/github/github-mcp-server:latest
```

## 2. Create a Personal Access Token (PAT)

1. Go to <https://github.com/settings/tokens>.
2. **Generate new token** → **Tokens (classic)** is the simplest.
3. Name it (e.g. `Claude MCP`) and pick an expiry.
4. Select scopes:
   - `repo` — full control of repositories,
   - `read:org` — read org membership,
   - `workflow` — if you want to touch GitHub Actions,
   - `delete_repo` — only if you want Claude to be able to delete repos.
5. **Generate token** and copy it now (it is shown only once).

Fine-grained tokens work too — grant at least *Contents*, *Administration*, *Issues* and *Pull requests* read/write.

## 3. Edit the Claude config

The file is at:

```
%APPDATA%\Claude\claude_desktop_config.json
```

Open it (e.g. `notepad "$env:APPDATA\Claude\claude_desktop_config.json"`) and add the `github` block **inside** `mcpServers`. If the file already has other servers, just add `github` next to them — see [`config/github-mcp.snippet.json`](../config/github-mcp.snippet.json). A complete minimal example is in [`config/claude_desktop_config.example.json`](../config/claude_desktop_config.example.json).

Replace `PASTE_YOUR_GITHUB_TOKEN_HERE` with your real token, keeping the surrounding quotes:

```json
"GITHUB_PERSONAL_ACCESS_TOKEN": "ghp_xxxxxxxxxxxxxxxxxxxx"
```

Save the file.

## 4. Validate the JSON

A single misplaced comma breaks every connector. Validate:

```powershell
try { Get-Content "$env:APPDATA\Claude\claude_desktop_config.json" -Raw | ConvertFrom-Json | Out-Null; "JSON OK" } catch { "INVALID JSON: $_" }
```

## 5. Restart Claude Desktop

Quit Claude **completely** (not just the window) and reopen it. In a new conversation, the GitHub tools appear after a few seconds (the container needs a moment to start).

## 6. Test

Ask Claude: *“test GitHub”* or *“who am I on GitHub?”*. Under the hood this calls `get_me` and should return your login. You're connected.

## Notes

- The server starts automatically with Claude Desktop and is available in **all** conversations.
- **Docker must be running** each time — consider enabling Docker Desktop at Windows startup.
- If your token has an expiry, regenerate and re-paste it when it lapses.
