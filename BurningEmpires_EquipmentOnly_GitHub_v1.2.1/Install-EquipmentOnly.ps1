$ErrorActionPreference = 'Stop'

function Write-Step([string]$Message) {
    Write-Host "`n==> $Message" -ForegroundColor Cyan
}

function Get-SourcePacks([string]$ModulesPath) {
    $assetDir = Join-Path (Join-Path $ModulesPath 'BurningEmpires') 'AssetPackages'
    if (-not (Test-Path -LiteralPath $assetDir -PathType Container)) { return $null }
    $found = @{}
    foreach ($n in 0..3) {
        $f = Get-ChildItem -LiteralPath $assetDir -File -ErrorAction SilentlyContinue |
            Where-Object { $_.BaseName -ieq "pack$n" -and $_.Extension -ieq '.tpac' } |
            Select-Object -First 1
        if (-not $f) { return $null }
        $found[$n] = $f.FullName
    }
    return @{ AssetDir = $assetDir; Packs = $found }
}

function Get-ModulesCandidates {
    $roots = New-Object System.Collections.Generic.List[string]
    $possibleSteamRoots = @(
        (Join-Path ${env:ProgramFiles(x86)} 'Steam'),
        (Join-Path $env:ProgramFiles 'Steam'),
        (Join-Path $env:LOCALAPPDATA 'Programs\Steam')
    )
    try {
        $reg = Get-ItemProperty -LiteralPath 'HKCU:\Software\Valve\Steam' -ErrorAction SilentlyContinue
        if ($reg -and $reg.SteamPath) { $possibleSteamRoots += ($reg.SteamPath -replace '/', '\') }
    } catch {}
    foreach ($root in ($possibleSteamRoots | Where-Object { $_ } | Select-Object -Unique)) {
        if (Test-Path -LiteralPath $root -PathType Container) {
            $roots.Add($root)
            $vdf = Join-Path $root 'steamapps\libraryfolders.vdf'
            if (Test-Path -LiteralPath $vdf -PathType Leaf) {
                $raw = Get-Content -LiteralPath $vdf -Raw
                foreach ($m in [regex]::Matches($raw, '"path"\s+"([^"]+)"')) {
                    $lib = $m.Groups[1].Value -replace '\\\\', '\'
                    if ($lib -and (Test-Path -LiteralPath $lib -PathType Container)) { $roots.Add($lib) }
                }
            }
        }
    }
    $candidates = New-Object System.Collections.Generic.List[string]
    foreach ($root in ($roots | Select-Object -Unique)) {
        $p = Join-Path $root 'steamapps\common\Mount & Blade II Bannerlord\Modules'
        if ((Test-Path -LiteralPath (Join-Path $p 'Native\SubModule.xml')) -and (Get-SourcePacks $p)) { $candidates.Add($p) }
    }
    $epic = Join-Path $env:ProgramFiles 'Epic Games\Mount & Blade II Bannerlord\Modules'
    if ((Test-Path -LiteralPath (Join-Path $epic 'Native\SubModule.xml')) -and (Get-SourcePacks $epic)) { $candidates.Add($epic) }
    return @($candidates | Select-Object -Unique)
}

function Select-ModulesFolder {
    $candidates = @(Get-ModulesCandidates)
    if ($candidates.Count -eq 1) {
        Write-Host "Found Bannerlord Modules folder: $($candidates[0])" -ForegroundColor Green
        $answer = Read-Host 'Use this folder? [Y/n]'
        if ([string]::IsNullOrWhiteSpace($answer) -or $answer.Trim().ToLowerInvariant() -eq 'y') { return $candidates[0] }
    } elseif ($candidates.Count -gt 1) {
        Write-Host 'Found multiple Bannerlord installations:' -ForegroundColor Yellow
        for ($i = 0; $i -lt $candidates.Count; $i++) { Write-Host ("  [{0}] {1}" -f ($i + 1), $candidates[$i]) }
        $choice = Read-Host 'Enter the number for the installation where Burning Empires is installed'
        $index = 0
        if ([int]::TryParse($choice, [ref]$index) -and $index -ge 1 -and $index -le $candidates.Count) { return $candidates[$index - 1] }
    }

    Write-Host 'Select the game Modules folder (it must contain Native and BurningEmpires).' -ForegroundColor Yellow
    try {
        Add-Type -AssemblyName System.Windows.Forms
        $dialog = New-Object System.Windows.Forms.FolderBrowserDialog
        $dialog.Description = 'Select Mount & Blade II Bannerlord\Modules'
        $dialog.ShowNewFolderButton = $false
        $default = Join-Path ${env:ProgramFiles(x86)} 'Steam\steamapps\common\Mount & Blade II Bannerlord\Modules'
        if (Test-Path -LiteralPath $default -PathType Container) { $dialog.SelectedPath = $default }
        if ($dialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) { return $dialog.SelectedPath }
    } catch {
        Write-Host 'Folder picker unavailable. Enter the full path to the Modules folder.' -ForegroundColor Yellow
    }
    $typed = Read-Host 'Full path to the game Modules folder'
    return $typed.Trim().Trim('"')
}

Add-Type -TypeDefinition @'
using System;
public static class SameLengthBinaryPatch {
    public static int ReplaceAll(byte[] data, byte[] oldBytes, byte[] newBytes) {
        if (oldBytes.Length != newBytes.Length) throw new ArgumentException("Patterns must be the same length.");
        int count = 0;
        int last = data.Length - oldBytes.Length;
        int i = 0;
        while (i <= last) {
            if (data[i] == oldBytes[0]) {
                int j = 1;
                while (j < oldBytes.Length && data[i + j] == oldBytes[j]) j++;
                if (j == oldBytes.Length) {
                    Buffer.BlockCopy(newBytes, 0, data, i, newBytes.Length);
                    count++;
                    i += oldBytes.Length;
                    continue;
                }
            }
            i++;
        }
        return count;
    }
}
'@

function Replace-AllBytes([byte[]]$Data, [byte[]]$OldBytes, [byte[]]$NewBytes) {
    if ($OldBytes.Length -ne $NewBytes.Length) { throw 'Internal validation failed: replacement names have different lengths.' }
    return [SameLengthBinaryPatch]::ReplaceAll($Data, $OldBytes, $NewBytes)
}

try {
    Write-Step 'Checking installer files'
    $moduleSource = Join-Path $PSScriptRoot 'ModuleFiles\BurningEmpires_EquipmentOnly'
    $requiredRelative = @(
        'SubModule.xml',
        'ModuleData\be_generated\items.xml',
        'ModuleData\be_generated\crafting_pieces.xml',
        'ModuleData\be_generated\crafting_templates.xml',
        'ModuleData\weapon_descriptions.xml',
        'ModuleData\item_modifiers.xml',
        'ModuleData\item_modifiers_groups.xml',
        'ModuleData\cloth_bodies.xml'
    )
    foreach ($rel in $requiredRelative) {
        if (-not (Test-Path -LiteralPath (Join-Path $moduleSource $rel) -PathType Leaf)) { throw "Installer is incomplete: missing ModuleFiles\BurningEmpires_EquipmentOnly\$rel" }
    }

    Write-Step 'Locating Bannerlord and checking Burning Empires assets'
    $modulesPath = Select-ModulesFolder
    if ([string]::IsNullOrWhiteSpace($modulesPath)) { throw 'No Modules folder was selected.' }
    $modulesPath = [System.IO.Path]::GetFullPath($modulesPath)
    if (-not (Test-Path -LiteralPath (Join-Path $modulesPath 'Native\SubModule.xml') -PathType Leaf)) { throw "That folder does not look like Bannerlord\Modules (Native\SubModule.xml is missing): $modulesPath" }
    $source = Get-SourcePacks $modulesPath
    if (-not $source) { throw 'Could not find pack0.tpac through pack3.tpac in Modules\BurningEmpires\AssetPackages. Install/extract Burning Empires first and check that you selected the correct game installation.' }

    $stamp = Get-Date -Format 'yyyyMMdd_HHmmss'
    $moduleName = 'BurningEmpires_EquipmentOnly'
    $target = Join-Path $modulesPath $moduleName
    $stage = Join-Path $modulesPath ("{0}.__staging_{1}" -f $moduleName, $stamp)
    if (Test-Path -LiteralPath $stage) { throw "Staging path already exists; remove it manually after verifying it is not in use: $stage" }

    Write-Step 'Preparing a fresh install in a staging folder'
    New-Item -ItemType Directory -Path $stage -Force | Out-Null
    Copy-Item -Path (Join-Path $moduleSource '*') -Destination $stage -Recurse -Force
    $targetAssets = Join-Path $stage 'AssetPackages'
    New-Item -ItemType Directory -Path $targetAssets -Force | Out-Null

    foreach ($n in 0..2) {
        $src = $source.Packs[$n]
        $dst = Join-Path $targetAssets "pack$n.tpac"
        Write-Host "Copying pack$n.tpac ..."
        Copy-Item -LiteralPath $src -Destination $dst -Force
        if ((Get-Item -LiteralPath $dst).Length -ne (Get-Item -LiteralPath $src).Length) { throw "pack$n.tpac copy-size check failed." }
    }

    Write-Step 'Making the pack3 UI-resource adjustment on a copy'
    $sourcePack3 = $source.Packs[3]
    Write-Host ("Reading pack3.tpac ({0:N0} bytes) ..." -f (Get-Item -LiteralPath $sourcePack3).Length)
    $bytes = [System.IO.File]::ReadAllBytes($sourcePack3)
    $originalLength = $bytes.LongLength
    $replacements = @(
        @{ Old = 'ui_charactercreation_1'; New = 'be_charactercreation_1' },
        @{ Old = 'ui_charactercreation_2'; New = 'be_charactercreation_2' },
        @{ Old = 'ui_charactercreation_3'; New = 'be_charactercreation_3' }
    )
    $counts = @{}
    foreach ($r in $replacements) {
        if ($r.Old.Length -ne $r.New.Length) { throw "Internal validation failed: $($r.Old) and $($r.New) have different lengths." }
        $oldBytes = [System.Text.Encoding]::ASCII.GetBytes($r.Old)
        $newBytes = [System.Text.Encoding]::ASCII.GetBytes($r.New)
        $counts[$r.Old] = Replace-AllBytes $bytes $oldBytes $newBytes
        Write-Host ("{0} -> {1}: {2} occurrence(s)" -f $r.Old, $r.New, $counts[$r.Old])
    }
    if ($counts['ui_charactercreation_1'] -lt 1 -or $counts['ui_charactercreation_2'] -lt 1) {
        throw 'Expected UI-resource names were not found in pack3.tpac. The source version may have changed; no replacement was installed. Original files remain untouched.'
    }
    $pack3Output = Join-Path $targetAssets 'pack3.tpac'
    [System.IO.File]::WriteAllBytes($pack3Output, $bytes)
    if ((Get-Item -LiteralPath $pack3Output).Length -ne $originalLength) { throw 'pack3.tpac output-size check failed.' }
    $bytes = $null

    Write-Step 'Validating XML and critical item registrations'
    foreach ($rel in $requiredRelative) {
        if ($rel.EndsWith('.xml')) {
            $xmlText = Get-Content -LiteralPath (Join-Path $stage $rel) -Raw
            $null = [xml]$xmlText
        }
    }
    $templateText = Get-Content -LiteralPath (Join-Path $stage 'ModuleData\be_generated\crafting_templates.xml') -Raw
    if ($templateText -notmatch 'TWB_Javelin') { throw 'TWB_Javelin template was not found in the installed XML.' }
    if (-not (Test-Path -LiteralPath (Join-Path $targetAssets 'pack0.tpac'))) { throw 'pack0.tpac is missing from staging.' }
    if (-not (Test-Path -LiteralPath (Join-Path $targetAssets 'pack3.tpac'))) { throw 'pack3.tpac is missing from staging.' }

    $backupPath = $null
    if (Test-Path -LiteralPath $target -PathType Container) {
        $gameRoot = Split-Path -Parent $modulesPath
        $backupRoot = Join-Path $gameRoot '_BurningEmpires_EquipmentOnly_Backups'
        New-Item -ItemType Directory -Path $backupRoot -Force | Out-Null
        $backupPath = Join-Path $backupRoot ("{0}_{1}" -f $moduleName, $stamp)
        Write-Step 'Backing up the existing EquipmentOnly module outside Modules'
        Move-Item -LiteralPath $target -Destination $backupPath
    }

    try {
        Move-Item -LiteralPath $stage -Destination $target
    } catch {
        if ($backupPath -and (Test-Path -LiteralPath $backupPath) -and -not (Test-Path -LiteralPath $target)) {
            Move-Item -LiteralPath $backupPath -Destination $target
        }
        throw
    }

    Write-Step 'Installation complete'
    Write-Host "Installed: $target" -ForegroundColor Green
    if ($backupPath) { Write-Host "Previous version backed up to: $backupPath" -ForegroundColor Green }
    Write-Host ''
    Write-Host 'In the Bannerlord Launcher:' -ForegroundColor Yellow
    Write-Host '  1. Enable Burning Empires Equipment Only.'
    Write-Host '  2. Disable Burning Empires and BurningEmpires_Elephants (if present).'
    Write-Host '  3. Keep Native, SandBoxCore and SandBox enabled.'
    Write-Host ''
    Write-Host 'The original BurningEmpires\AssetPackages files were not modified.' -ForegroundColor Green
    exit 0
} catch {
    Write-Host "`nINSTALLER STOPPED: $($_.Exception.Message)" -ForegroundColor Red
    if ($stage -and (Test-Path -LiteralPath $stage)) {
        try { Remove-Item -LiteralPath $stage -Recurse -Force -ErrorAction Stop; Write-Host 'Incomplete staging folder cleaned up.' } catch { Write-Host "Please inspect and remove the incomplete staging folder manually: $stage" -ForegroundColor Yellow }
    }
    exit 1
}
