[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidatePattern('^[a-z0-9]+(?:-[a-z0-9]+)*$')]
    [string]$Id,

    [Parameter(Mandatory = $true)]
    [ValidateSet('electron')]
    [string]$Platform,

    [Parameter(Mandatory = $true)]
    [string]$Symptom,

    [Parameter(Mandatory = $true)]
    [string]$Cause,

    [Parameter(Mandatory = $true)]
    [string]$Fix,

    [Parameter(Mandatory = $true)]
    [string]$Verify,

    [string]$AppliesTo = 'general',
    [string]$Avoid = 'Unverified cosmetic workarounds',
    [string]$Tags = ''
)

$ErrorActionPreference = 'Stop'
$notesPath = Join-Path $PSScriptRoot '..\references\field-notes.md'
$notesPath = [System.IO.Path]::GetFullPath($notesPath)

if (-not (Test-Path -LiteralPath $notesPath)) {
    throw "Field notes file not found: $notesPath"
}

$existing = [System.IO.File]::ReadAllText($notesPath)
$heading = "### $Id"
if ($existing -match "(?m)^$([regex]::Escape($heading))\r?$") {
    throw "A field note with ID '$Id' already exists. Edit that entry instead of creating a duplicate."
}

function Normalize-Line([string]$Value) {
    return (($Value -replace '[\r\n]+', ' ') -replace '\s{2,}', ' ').Trim()
}

$entry = @"

### $(Normalize-Line $Id)

- Platform: $(Normalize-Line $Platform)
- Applies to: $(Normalize-Line $AppliesTo)
- Symptom: $(Normalize-Line $Symptom)
- Root cause: $(Normalize-Line $Cause)
- Fix: $(Normalize-Line $Fix)
- Verify: $(Normalize-Line $Verify)
- Avoid: $(Normalize-Line $Avoid)
- Tags: $(Normalize-Line $Tags)
"@

$utf8WithoutBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::AppendAllText($notesPath, $entry, $utf8WithoutBom)
Write-Output "Added field note '$Id' to $notesPath"
