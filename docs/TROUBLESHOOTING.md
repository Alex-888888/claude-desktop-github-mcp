# Troubleshooting

The honest list of dead ends encountered while wiring this up, and what actually resolved them. This is the most useful page if you're hitting the same walls.

## The bundled GitHub connector fails to authenticate

**Symptom.** Starting the OAuth flow for the pre-installed GitHub connector returns:

```
Failed to start OAuth flow: SDK auth failed: Incompatible auth server:
does not support dynamic client registration.
```

**Cause.** That connector targets the GitHub Copilot MCP endpoint (`api.githubcopilot.com/mcp`). Its OAuth server does not support the dynamic client registration the client attempts, so the automatic flow cannot complete. It also generally expects an active **GitHub Copilot** subscription.

**Resolution.** Don't use that connector. Run the **official self-hosted** server in Docker with a PAT instead (this repo). It needs no Copilot subscription and no OAuth.

## There is no “Configure” button for GitHub in Connectors

**Symptom.** The Settings → Connectors list has no GitHub entry to configure.

**Cause.** In some setups GitHub is provided by a bundled *plugin*, not a standalone connector, so it is not configurable from that menu.

**Resolution.** Configure the server directly in `claude_desktop_config.json` (this repo), which is independent of the Connectors UI.

## GitHub tools don't appear after editing the config

**Checklist.**

1. **Restart fully.** Quit Claude Desktop entirely (tray included), then reopen. Config is read at startup only.
2. **Validate the JSON.** A stray comma invalidates the whole file:
   ```powershell
   Get-Content "$env:APPDATA\Claude\claude_desktop_config.json" -Raw | ConvertFrom-Json
   ```
3. **Is Docker running?** The server is a container; if Docker Desktop is down, the server can't start.
4. **Give it a few seconds.** In a fresh conversation the container takes a moment to spin up before tools register.

## `docker: command not found` / image errors

- Confirm Docker works: `docker version`.
- Re-pull the image: `docker pull ghcr.io/github/github-mcp-server:latest`.
- On a metered or restricted network, the first pull can be slow or blocked.

## 401 / 403 errors when Claude calls GitHub

- The token is wrong, expired, or lacks scopes. Regenerate it (see [`SETUP.md`](SETUP.md) step 2) and re-paste it.
- Verify there are no stray spaces or missing quotes around the token in the JSON.

## Token expired

Classic and fine-grained tokens can expire. When they do, every GitHub call fails with an auth error. Generate a new token and replace the value in the config, then restart Claude.
