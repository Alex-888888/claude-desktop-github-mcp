#requires -Version 5.1
<#
.SYNOPSIS
  Set up the official GitHub MCP server for Claude Desktop on Windows.
.DESCRIPTION
  Pulls the Docker image and inserts a 'github' server block into
  claude_desktop_config.json if it is not already present. Does NOT write
  your token — you must paste it yourself afterwards (see docs/SETUP.md).
#>

$ErrorActionPreference = 'Stop'
$configPath = Join-Path $env:APPDATA 'Claude\claude_desktop_config.json'

Write-Host '== GitHub MCP setup for Claude Desktop ==' -ForegroundColor Cyan

# 1. Docker present?
try {
    $v = docker version --format '{{.Server.Version}}' 2>$null
    Write-Host "Docker server version: $v"
} catch {
    throw 'Docker does not appear to be running. Start Docker Desktop and retry.'
}

# 2. Pull the official image
Write-Host 'Pulling ghcr.io/github/github-mcp-server:latest ...'
docker pull ghcr.io/github/github-mcp-server:latest | Out-Null

# 3. Load or create config
if (Test-Path $configPath) {
    $json = Get-Content $configPath -Raw | ConvertFrom-Json
} else {
    New-Item -ItemType Directory -Force -Path (Split-Path $configPath) | Out-Null
    $json = [pscustomobject]@{ mcpServers = [pscustomobject]@{} }
}
if (-not $json.PSObject.Properties.Name -contains 'mcpServers' -or $null -eq $json.mcpServers) {
    $json | Add-Member -NotePropertyName mcpServers -NotePropertyValue ([pscustomobject]@{}) -Force
}

# 4. Add github block if missing
if ($json.mcpServers.PSObject.Properties.Name -contains 'github') {
    Write-Host 'A "github" server already exists in the config — leaving it untouched.' -ForegroundColor Yellow
} else {
    $github = [pscustomobject]@{
        command = 'docker'
        args    = @('run','-i','--rm','-e','GITHUB_PERSONAL_ACCESS_TOKEN','ghcr.io/github/github-mcp-server')
        env     = [pscustomobject]@{ GITHUB_PERSONAL_ACCESS_TOKEN = 'PASTE_YOUR_GITHUB_TOKEN_HERE' }
    }
    $json.mcpServers | Add-Member -NotePropertyName github -NotePropertyValue $github -Force
    $json | ConvertTo-Json -Depth 10 | Set-Content $configPath -Encoding UTF8
    Write-Host 'Added "github" server block to the config.' -ForegroundColor Green
}

Write-Host ''
Write-Host 'NEXT STEPS:' -ForegroundColor Cyan
Write-Host "  1. Open $configPath"
Write-Host '  2. Replace PASTE_YOUR_GITHUB_TOKEN_HERE with your GitHub PAT'
Write-Host '  3. Fully restart Claude Desktop'
