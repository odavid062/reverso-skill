# Instala a skill "reverso" para Claude Code, Codex e agentes compatíveis com Agent Skills (Windows).
# Uso:
#   .\install.ps1              # instalação global (pasta do usuário)
#   .\install.ps1 -Project     # instala só no projeto atual (.claude\skills e .agents\skills)
#   irm https://raw.githubusercontent.com/odavid062/reverso-skill/main/install.ps1 | iex
param([switch]$Project)
$ErrorActionPreference = 'Stop'

$RepoUrl = 'https://github.com/odavid062/reverso-skill.git'
$Skill = 'reverso'

$Src = $null
if ($PSScriptRoot -and (Test-Path (Join-Path $PSScriptRoot "skills\$Skill\SKILL.md"))) {
    $Src = Join-Path $PSScriptRoot "skills\$Skill"
} else {
    $Tmp = Join-Path ([System.IO.Path]::GetTempPath()) ("reverso-" + [guid]::NewGuid())
    git clone --depth 1 $RepoUrl "$Tmp\repo" | Out-Null
    $Src = "$Tmp\repo\skills\$Skill"
}

if ($Project) {
    $Targets = @("$PWD\.claude\skills", "$PWD\.agents\skills")
} else {
    $Targets = @("$HOME\.claude\skills", "$HOME\.codex\skills", "$HOME\.agents\skills")
}

foreach ($dir in $Targets) {
    New-Item -ItemType Directory -Force -Path $dir | Out-Null
    $dest = Join-Path $dir $Skill
    if (Test-Path $dest) {
        Rename-Item $dest ("$Skill.bak." + (Get-Date -Format 'yyyyMMddHHmmss'))
    }
    Copy-Item -Recurse $Src $dest
    Write-Host "✔ instalado em $dest"
}

Write-Host ""
Write-Host "Pronto. Reinicie o agente e digite: /reverso  (ou só: reverso)"
