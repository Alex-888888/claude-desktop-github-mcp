#requires -Version 5.1
<#
.SYNOPSIS
  Quick local checks for the GitHub MCP setup (does not call GitHub).
.DESCRIPTION
  Verifies Docker is running, the image is present, and the Claude config
  contains a 'github' server with a token that is not still the placeholder.
#>

$ErrorActionPreference = 'Stop'
$configPath = Join-Path $env:APPDATA 'Claude\claude_desktop_config.json'
$ok = $true

Write-Host '== GitHub MCP connection checks ==' -ForegroundColor Cyan

# Docker
try {
    $v = docker version --format '{{.Server.Version}}' 2>$null
    Write-Host "[OK] Docker running (server $v)" -ForegroundColor Green
} catch {
    Write-Host '[FAIL] Docker is not running' -ForegroundColor Red; $ok = $false
}

# Image present
if (docker images ghcr.io/github/github-mcp-server --format '{{.Repository}}' 2>$null) {
    Write-Host '[OK] Image ghcr.io/github/github-mcp-server present' -ForegroundColor Green
} else {
    Write-Host '[WARN] Image not found locally — run: docker pull ghcr.io/github/github-mcp-server:latest' -ForegroundColor Yellow
}

# Config
if (Test-Path $configPath) {
    try {
        $json = Get-Content $configPath -Raw | ConvertFrom-Json
        if ($json.mcpServers.PSObject.Properties.Name -contains 'github') {
            Write-Host '[OK] github server present in config' -ForegroundColor Green
            $tok = $json.mcpServers.github.env.GITHUB_PERSONAL_ACCESS_TOKEN
            if ($tok -eq 'PASTE_YOUR_GITHUB_TOKEN_HERE' -or [string]::IsNullOrWhiteSpace($tok)) {
                Write-Host '[FAIL] Token still the placeholder — paste your real PAT' -ForegroundColor Red; $ok = $false
            } else {
                Write-Host '[OK] A token value is set' -ForegroundColor Green
            }
        } else {
            Write-Host '[FAIL] No github server in config' -ForegroundColor Red; $ok = $false
        }
    } catch {
        Write-Host "[FAIL] Config JSON is invalid: $_" -ForegroundColor Red; $ok = $false
    }
} else {
    Write-Host "[FAIL] Config not found at $configPath" -ForegroundColor Red; $ok = $false
}

Write-Host ''
if ($ok) {
    Write-Host 'All local checks passed. Restart Claude Desktop and ask it to "test GitHub".' -ForegroundColor Green
} else {
    Write-Host 'Some checks failed — see messages above and docs/TROUBLESHOOTING.md.' -ForegroundColor Yellow
}
