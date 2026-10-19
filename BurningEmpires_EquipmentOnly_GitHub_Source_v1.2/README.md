# Burning Empires Equipment Only — Installer Source (v1.2)

An unofficial equipment-only companion for Mount & Blade II: Bannerlord. This repository publishes the installer scripts and module XML source for transparency and review.

## What is included

- `Install_EquipmentOnly.bat` — launches the PowerShell installer.
- `Install-EquipmentOnly.ps1` — locates the Bannerlord Modules folder, validates the source module and required Burning Empires assets, stages the module, copies asset packages 0–2, creates an adjusted copy of asset package 3, validates XML, backs up an existing EquipmentOnly module, and installs the staged module.
- `ModuleFiles/BurningEmpires_EquipmentOnly/` — module metadata and XML data used by the installer.
- `CREDITS_AND_SCOPE.txt` — attribution and scope notes.

## What is deliberately not included

The Burning Empires `.tpac` asset packages are not included. The installer expects the user to have Burning Empires installed locally and copies `pack0.tpac` through `pack3.tpac` from that installation into the new companion module. It modifies a copy of `pack3.tpac`; it is designed not to modify the original Burning Empires folder.

## Install / inspect

1. Download or clone this repository.
2. To install, run `Install_EquipmentOnly.bat` on Windows and follow its prompts. Review `Install-EquipmentOnly.ps1` first if you want to inspect its behavior before running it.
3. The target Bannerlord installation must have `Native\SubModule.xml` and `Modules\BurningEmpires\AssetPackages\pack0.tpac` through `pack3.tpac`.
4. In the Bannerlord launcher, enable **Burning Empires Equipment Only** and disable the original **Burning Empires** total conversion (and `BurningEmpires_Elephants`, if present). Keep Native, SandBoxCore, and SandBox enabled.

The batch file invokes PowerShell with `-ExecutionPolicy Bypass` so the local script can run despite the PowerShell execution-policy setting. This does not itself indicate malware, but users should review the script and run it only if they trust the source.

## Development / test notes

The reported working test setup was Bannerlord 1.4.8 with Naval DLC 1.2.8.0 and Burning Empires 2.0. The module data's `SubModule.xml` version remains 0.7.0; v1.2 refers to the installer package/release label, not the module-data version. The project has been tested by its maintainer in-game; users should test against their own game and mod versions.

## Security transparency

The release ZIP passed an archive-integrity check; all seven XML files parsed successfully in the recorded review; a static review found no obvious malicious behavior. The maintainer reports that Windows Security / Microsoft Defender reported 0 threats in a custom scan of 13 files (1 second) and a full system scan of 846,037 files (6 minutes 17 seconds), both on October 19, 2026. These are reported scan results, not a guarantee of absolute safety or an independent certification. Review the scripts yourself before running them.

## Credits and permissions

See [`CREDITS_AND_SCOPE.txt`](CREDITS_AND_SCOPE.txt). The maintainer states that permission to publish this equipment-only companion was obtained from the Burning Empires Team and Levente, the project lead. This is an unofficial community companion and is not endorsed by or affiliated with the Burning Empires Team or TaleWorlds.

## Licensing

No new license is asserted here for the derived XML or third-party content. Do not assume that the presence of source files grants unrestricted reuse. Confirm the applicable permissions and hosting-platform requirements before redistributing or reusing content.
