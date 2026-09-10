# SPDX-License-Identifier: MIT
<#
.SYNOPSIS
    Universal Humanizer Windows Installer (PowerShell)
.DESCRIPTION
    Installs Universal Humanizer agent skill, rules, and commands across all detected AI agents.
#>

[CmdletBinding()]
param(
    [switch]$Global = $true,
    [switch]$Project,
    [string]$Agent = "all",
    [switch]$All,
    [switch]$DryRun,
    [switch]$Uninstall
)

$ErrorActionPreference = "Stop"

$Repo = "irrumi/universal_humanizer"
$Branch = "main"
$RawBase = "https://raw.githubusercontent.com/$Repo/$Branch"

$UserHome = $env:USERPROFILE
$CurrentDir = (Get-Location).Path
$ScriptDir = if ($PSScriptRoot) { $PSScriptRoot } elseif ($MyInvocation.MyCommand -and $MyInvocation.MyCommand.Path) { Split-Path -Parent $MyInvocation.MyCommand.Path } else { $null }

$IsLocal = $false
if ($ScriptDir -and (Test-Path (Join-Path $ScriptDir "SKILL.md"))) {
    $IsLocal = $true
}

function Install-SkillFile {
    param(
        [string]$RelativeSource,
        [string]$DestinationPath
    )
    if ($DryRun) {
        Write-Host "  [DRY-RUN] Would write $DestinationPath" -ForegroundColor Cyan
        return
    }

    $destDir = Split-Path -Parent $DestinationPath
    if (-not (Test-Path $destDir)) {
        New-Item -ItemType Directory -Path $destDir -Force | Out-Null
    }

    if (Test-Path $DestinationPath) {
        Copy-Item -Path $DestinationPath -Destination "$DestinationPath.bak" -Force
        Write-Host "  [BACKUP] Backed up existing file to $DestinationPath.bak" -ForegroundColor Yellow
    }

    if ($IsLocal -and (Test-Path (Join-Path $ScriptDir $RelativeSource))) {
        Copy-Item -Path (Join-Path $ScriptDir $RelativeSource) -Destination $DestinationPath -Force
    } else {
        $url = "$RawBase/$RelativeSource"
        $webClient = New-Object System.Net.WebClient
        $webClient.DownloadFile($url, $DestinationPath)
    }
    Write-Host "  [INSTALLED] $DestinationPath" -ForegroundColor Green
}

function Remove-SkillFile {
    param([string]$DestinationPath)
    if (Test-Path $DestinationPath) {
        if ($DryRun) {
            Write-Host "  [DRY-RUN] Would remove $DestinationPath" -ForegroundColor Cyan
        } else {
            Remove-Item -Path $DestinationPath -Force
            Write-Host "  [REMOVED] $DestinationPath" -ForegroundColor Red
            if (Test-Path "$DestinationPath.bak") {
                Move-Item -Path "$DestinationPath.bak" -Destination $DestinationPath -Force
                Write-Host "  [RESTORED] Restored backup $DestinationPath" -ForegroundColor Yellow
            }
        }
    }
}

Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "    Universal Humanizer Windows Installer (v1.0.0)" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "Scope:     $(if ($Project) { 'project' } else { 'global' })"
Write-Host "Target:    $Agent"
Write-Host "Dry run:   $DryRun"
Write-Host "=================================================="
Write-Host ""

$installed = [System.Collections.Generic.List[string]]::new()

# 1. Google Antigravity
if ($Agent -eq "all" -or $Agent -eq "antigravity") {
    if ((Test-Path (Join-Path $UserHome ".gemini")) -or (Get-Command agy -ErrorAction SilentlyContinue) -or ($Agent -eq "antigravity")) {
        Write-Host "Configuring Google Antigravity..."
        if ($Uninstall) {
            Remove-SkillFile (Join-Path $UserHome ".gemini\config\skills\universal-humanizer\SKILL.md")
            Remove-SkillFile (Join-Path $CurrentDir ".agents\skills\universal-humanizer\SKILL.md")
            Remove-SkillFile (Join-Path $UserHome ".gemini\config\plugins\universal-humanizer\plugin.json")
            Remove-SkillFile (Join-Path $UserHome ".gemini\config\plugins\universal-humanizer\skills\universal-humanizer\SKILL.md")
            Remove-SkillFile (Join-Path $UserHome ".gemini\config\plugins\universal-humanizer\rules\humanizer.md")
        } else {
            if (-not $Project) {
                Install-SkillFile "SKILL.md" (Join-Path $UserHome ".gemini\config\skills\universal-humanizer\SKILL.md")
                Install-SkillFile "plugin.json" (Join-Path $UserHome ".gemini\config\plugins\universal-humanizer\plugin.json")
                Install-SkillFile "skills/universal-humanizer/SKILL.md" (Join-Path $UserHome ".gemini\config\plugins\universal-humanizer\skills\universal-humanizer\SKILL.md")
                Install-SkillFile "rules/humanizer.md" (Join-Path $UserHome ".gemini\config\plugins\universal-humanizer\rules\humanizer.md")
            } else {
                Install-SkillFile "SKILL.md" (Join-Path $CurrentDir ".agents\skills\universal-humanizer\SKILL.md")
            }
            $installed.Add("Google Antigravity (global skill & plugin)")
        }
    }
}

# 2. Gemini CLI
if ($Agent -eq "all" -or $Agent -eq "gemini" -or $Agent -eq "gemini-cli") {
    if ((Test-Path (Join-Path $UserHome ".gemini")) -or (Get-Command gemini -ErrorAction SilentlyContinue) -or ($Agent -match "gemini")) {
        Write-Host "Configuring Gemini CLI..."
        if ($Uninstall) {
            Remove-SkillFile (Join-Path $UserHome ".gemini\extensions\universal-humanizer\gemini-extension.json")
            Remove-SkillFile (Join-Path $UserHome ".gemini\extensions\universal-humanizer\rules\humanizer.md")
            Remove-SkillFile (Join-Path $UserHome ".gemini\commands\humanizer.toml")
        } else {
            Install-SkillFile "gemini-extension.json" (Join-Path $UserHome ".gemini\extensions\universal-humanizer\gemini-extension.json")
            Install-SkillFile "rules/humanizer.md" (Join-Path $UserHome ".gemini\extensions\universal-humanizer\rules\humanizer.md")
            Install-SkillFile "commands/humanizer.toml" (Join-Path $UserHome ".gemini\commands\humanizer.toml")
            $installed.Add("Gemini CLI (/humanizer command and extension)")
        }
    }
}

# 3. Claude Code
if ($Agent -eq "all" -or $Agent -eq "claude" -or $Agent -eq "claude-code") {
    if ((Test-Path (Join-Path $UserHome ".claude")) -or (Get-Command claude -ErrorAction SilentlyContinue) -or ($Agent -match "claude")) {
        Write-Host "Configuring Claude Code..."
        if ($Uninstall) {
            Remove-SkillFile (Join-Path $UserHome ".claude\skills\universal-humanizer\SKILL.md")
        } else {
            Install-SkillFile "SKILL.md" (Join-Path $UserHome ".claude\skills\universal-humanizer\SKILL.md")
            $installed.Add("Claude Code (~/.claude/skills/universal-humanizer/)")
        }
    }
}

# 4. OpenAI Codex CLI
if ($Agent -eq "all" -or $Agent -eq "codex") {
    if ((Test-Path (Join-Path $UserHome ".codex")) -or (Get-Command codex -ErrorAction SilentlyContinue) -or ($Agent -eq "codex")) {
        Write-Host "Configuring Codex CLI..."
        if ($Uninstall) {
            Remove-SkillFile (Join-Path $UserHome ".codex\prompts\humanizer.md")
        } else {
            Install-SkillFile "prompts/humanizer.md" (Join-Path $UserHome ".codex\prompts\humanizer.md")
            $installed.Add("Codex CLI (~/.codex/prompts/humanizer.md)")
        }
    }
}

# 5. Cursor
if ($Agent -eq "all" -or $Agent -eq "cursor") {
    if ((Test-Path (Join-Path $CurrentDir ".cursor")) -or (Test-Path (Join-Path $UserHome ".cursor")) -or (Get-Command cursor -ErrorAction SilentlyContinue) -or ($Agent -eq "cursor")) {
        Write-Host "Configuring Cursor..."
        if ($Uninstall) {
            Remove-SkillFile (Join-Path $CurrentDir ".cursor\rules\humanizer.mdc")
        } else {
            Install-SkillFile "rules/humanizer.md" (Join-Path $CurrentDir ".cursor\rules\humanizer.mdc")
            $installed.Add("Cursor (.cursor/rules/humanizer.mdc)")
        }
    }
}

# 6. Windsurf
if ($Agent -eq "all" -or $Agent -eq "windsurf") {
    if ((Test-Path (Join-Path $CurrentDir ".windsurf")) -or (Get-Command windsurf -ErrorAction SilentlyContinue) -or ($Agent -eq "windsurf")) {
        Write-Host "Configuring Windsurf..."
        if ($Uninstall) {
            Remove-SkillFile (Join-Path $CurrentDir ".windsurf\rules\humanizer.md")
        } else {
            Install-SkillFile "rules/humanizer.md" (Join-Path $CurrentDir ".windsurf\rules\humanizer.md")
            $installed.Add("Windsurf (.windsurf/rules/humanizer.md)")
        }
    }
}

# 7. OpenCode
if ($Agent -eq "all" -or $Agent -eq "opencode") {
    if ((Test-Path (Join-Path $UserHome ".config\opencode")) -or (Get-Command opencode -ErrorAction SilentlyContinue) -or ($Agent -eq "opencode")) {
        Write-Host "Configuring OpenCode..."
        if ($Uninstall) {
            Remove-SkillFile (Join-Path $UserHome ".config\opencode\skills\universal-humanizer\SKILL.md")
            Remove-SkillFile (Join-Path $CurrentDir ".opencode\skills\universal-humanizer\SKILL.md")
        } else {
            if (-not $Project) {
                Install-SkillFile "SKILL.md" (Join-Path $UserHome ".config\opencode\skills\universal-humanizer\SKILL.md")
            } else {
                Install-SkillFile "SKILL.md" (Join-Path $CurrentDir ".opencode\skills\universal-humanizer\SKILL.md")
            }
            $installed.Add("OpenCode (skills/universal-humanizer/SKILL.md)")
        }
    }
}

Write-Host ""
Write-Host "==================================================" -ForegroundColor Cyan
if ($Uninstall) {
    Write-Host "Universal Humanizer uninstallation complete." -ForegroundColor Green
} else {
    Write-Host "Installation complete! Activated environments:" -ForegroundColor Green
    foreach ($item in $installed) {
        Write-Host "  * $item" -ForegroundColor Green
    }
    Write-Host ""
    Write-Host "How to invoke:"
    Write-Host "  - In chat: /humanizer [paste your text]"
    Write-Host "  - Or ask: 'Please humanize this text according to universal humanizer guidelines'"
}
Write-Host "==================================================" -ForegroundColor Cyan
