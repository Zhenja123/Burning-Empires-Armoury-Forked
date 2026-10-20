# Burning Empires Equipment Only — Installer Source (v1.2.1)

An unofficial equipment-only companion for **Mount & Blade II: Bannerlord**. This repository contains the installer and readable module XML source. It does **not** contain the Burning Empires TPAC asset packages.

## Current status

The maintainer reports successful in-game checks of the equipment, including melee weapons and javelins, and a recent clothing-fit check in which Celtic and Germanic clothing showed no clipping on the vanilla male body. `cloth_bodies.xml` is included in the module source and is checked by the installer. Testing with third-party body mods may produce different results.

This is a tested working baseline, not a guarantee of compatibility with every Bannerlord, DLC, Burning Empires, or body-mod version.

## Culture assignment goals

- Roman → Empire
- Celtic / Germanic → Battania
- Sarmatian / Slavic → Sturgia
- Hunnic → Khuzait
- Sassanid / Persian → Aserai

These are the project's intended culture mappings; users should report any individual items that appear under the wrong culture.

## Repository contents

- `Install_EquipmentOnly.bat` — starts the Windows PowerShell installer.
- `Install-EquipmentOnly.ps1` — locates Bannerlord, checks the required source files and local Burning Empires assets, stages the module, copies TPAC packages 0–2, creates a modified copy of package 3, validates XML and key item registrations, backs up an existing EquipmentOnly module, and installs the staged module.
- `ModuleFiles/BurningEmpires_EquipmentOnly/` — module metadata and XML data, including `ModuleData/cloth_bodies.xml`.
- `README_FIRST.txt` — installation and rollback instructions.
- `CREDITS_AND_SCOPE.txt` — attribution, permission statement, and distribution scope.
- `SECURITY.md` — script behavior and security review notes.
- `CHANGELOG_CLOTH_BODIES.txt` — changes for this packaging update.

## Required local files

The installer expects an installed/extracted Burning Empires module at `Modules/BurningEmpires/AssetPackages/` with `pack0.tpac` through `pack3.tpac`. These large asset files are intentionally not redistributed here; the installer copies them from the user's local installation and leaves the original Burning Empires folder untouched.

## Install

1. Install Burning Empires from its official distribution page and follow its own installation instructions: https://www.nexusmods.com/mountandblade2bannerlord/mods/7750
2. Download or clone this repository and extract it outside the Bannerlord `Modules` directory.
3. Review `Install-EquipmentOnly.ps1` and `Install_EquipmentOnly.bat` before running them.
4. On Windows, run `Install_EquipmentOnly.bat` and follow the prompts. If automatic detection fails, select the Bannerlord `Modules` folder (the one containing `Native` and `BurningEmpires`).
5. In the launcher, enable **Burning Empires Equipment Only** and disable the original **Burning Empires** total conversion. Also disable `BurningEmpires_Elephants` if installed. Keep the normal Native / SandBoxCore / SandBox modules enabled.
6. Launch the game and test on your own setup. A new campaign is recommended for a clean test.

## What the installer changes

- Copies `pack0.tpac`, `pack1.tpac`, and `pack2.tpac` from the local Burning Empires installation.
- Creates an adjusted **copy** of `pack3.tpac` by renaming the targeted `ui_charactercreation_*` resource identifiers to `be_charactercreation_*` to avoid a vanilla character-creation UI conflict. It does not edit the original TPAC files.
- Validates required XML, including `cloth_bodies.xml`, and checks for the expected `TWB_Javelin` crafting template.
- If an EquipmentOnly module already exists, moves it to a timestamped backup directory outside `Modules` before installing the staged version.

The batch file invokes PowerShell with `-ExecutionPolicy Bypass` for this local script. Read the scripts and run them only if you trust their contents.

## Version notes

`v1.2.1` is the installer/repository package label. The module's `SubModule.xml` version remains `0.7.0`. The documented working test setup was Bannerlord 1.4.8, Naval DLC 1.2.8.0, and Burning Empires 2.0; verify compatibility if your versions differ.

## Credits, permission, and licensing

See `CREDITS_AND_SCOPE.txt`. The maintainer states that permission to publish this equipment-only companion was obtained from the Burning Empires Team and Levente, the project lead. This is an unofficial community companion, not endorsed by or affiliated with the Burning Empires Team or TaleWorlds. No new license is asserted for derived XML or third-party content; do not assume the source files grant unrestricted reuse.
