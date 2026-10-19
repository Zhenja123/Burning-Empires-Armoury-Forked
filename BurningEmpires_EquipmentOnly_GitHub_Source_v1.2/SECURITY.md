# Security notes

This repository contains readable Windows batch/PowerShell scripts and XML module data. No compiled executable or DLL is packaged in this source repository.

Before running the installer:
- Read `Install_EquipmentOnly.bat` and `Install-EquipmentOnly.ps1`.
- Understand that the installer reads local Steam installation metadata and `libraryfolders.vdf` to locate Bannerlord; it does not need a network download for installation.
- Understand that it copies locally installed Burning Empires TPAC assets, writes to the EquipmentOnly module folder, and may move an existing EquipmentOnly folder into a timestamped backup directory.
- Keep the original Burning Empires installation intact. The script is designed to adjust a copy of `pack3.tpac`, not the original.

Recorded checks for the v1.2 installer package: ZIP integrity check passed; seven XML files parsed; static review found no obvious malicious behavior. The maintainer reports a Microsoft Defender custom scan with 0 threats found (13 files, 1 second) and a full scan with 0 threats found (846,037 files, 6 minutes 17 seconds) on 2026-10-19. Antivirus results are evidence from those scans, not an absolute guarantee.
