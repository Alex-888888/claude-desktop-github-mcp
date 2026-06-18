# Claude Desktop ↔ GitHub (MCP)

![License](https://img.shields.io/badge/license-Apache--2.0-blue)
![Platform](https://img.shields.io/badge/platform-Windows-blue)
![Runtime](https://img.shields.io/badge/runtime-Docker-blue)
![Status](https://img.shields.io/badge/status-working-success)

Connect **Claude Desktop** to **GitHub** using GitHub's **official MCP server**, running locally in Docker and authenticated with a Personal Access Token (PAT).

This repository is a **practical, honest setup guide** — it documents a configuration that actually works on Windows, and just as importantly, the **dead ends** encountered on the way (the built-in GitHub Copilot endpoint that refuses automatic auth, the missing “Configure” button, the `dynamic client registration` error). The troubleshooting notes are the most useful part for anyone hitting the same walls.

> Tested on Windows 11 with Docker Desktop 29.x and Claude Desktop, June 2026. No GitHub Copilot subscription required.

## Why this exists

- **The bundled GitHub connector did not work** in our setup: it points to the GitHub Copilot MCP endpoint (`api.githubcopilot.com/mcp`), which requires a Copilot subscription and an OAuth flow that fails with `Incompatible auth server: does not support dynamic client registration`.
- **The official, self-hosted GitHub MCP server does work** — it runs in Docker, authenticates with a plain Personal Access Token, and needs no Copilot subscription.
- **One config, every conversation.** Because it lives in `claude_desktop_config.json`, the server loads at app startup and is available in all chats.

## What it does

Adds a `github` MCP server to Claude Desktop so Claude can, on your behalf and with your token's permissions:

- create and manage repositories,
- read, analyze and edit code,
- open and triage issues,
- create, review and merge pull requests,
- search code, commits, users and repos.

## Quickstart

```powershell
# 1. Pull the official image (Docker Desktop must be running)
docker pull ghcr.io/github/github-mcp-server:latest

# 2. Add the github server to your Claude config
#    Copy the block from config/github-mcp.snippet.json into
#    %APPDATA%\Claude\claude_desktop_config.json (inside "mcpServers")

# 3. Replace the placeholder with your GitHub PAT, then fully restart Claude Desktop
```

Full walkthrough: [`docs/SETUP.md`](docs/SETUP.md).

## Repository layout

```
config/
  claude_desktop_config.example.json   # a complete example config with the github server
  github-mcp.snippet.json              # just the "github" block to paste into your config
scripts/
  setup-windows.ps1                    # pull image, patch config, validate JSON
  test-connection.ps1                  # check Docker + image availability
docs/
  SETUP.md                             # step-by-step: token -> config -> restart
  TROUBLESHOOTING.md                   # the real dead ends and how they were resolved
  SECURITY.md                          # token scopes, expiry, never commit secrets
examples/
  prompts.md                           # example requests once connected
```

## Requirements

- Windows with **Claude Desktop** installed.
- **Docker Desktop** installed and running.
- A **GitHub account** and a **Personal Access Token** (classic or fine-grained).

## Security

Your token grants access to your GitHub account — treat it like a password. This repository contains **only placeholders**, never a real token, and the `.gitignore` blocks common secret files. See [`docs/SECURITY.md`](docs/SECURITY.md).

## License & attribution

Apache 2.0 (see [`LICENSE`](LICENSE)). Uses the official [github/github-mcp-server](https://github.com/github/github-mcp-server). This repository is independent documentation and is not affiliated with or endorsed by GitHub or Anthropic.
