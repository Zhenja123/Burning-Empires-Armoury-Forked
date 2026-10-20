BURNING EMPIRES EQUIPMENT ONLY — ONE-CLICK INSTALLER v1.2


Culture assignment refinements carried into installer v1.2:
- Roman -> Empire; Celtic and Germanic -> Battania.
- Sarmatian and Slavic -> Sturgia; Hunnic -> Khuzait; Sassanid/Persian -> Aserai.
- Filled culture fields for 52 previously unassigned equipment/ammunition items and corrected explicitly named historical items with conflicting assignments.
- Left the armor work-in-progress proxy and generic wine trade good culture-neutral.

CLOTHING COMPATIBILITY NOTE
- ModuleData\cloth_bodies.xml is included and validated by the installer. The maintainer reports no clipping for Celtic and Germanic clothing on the vanilla male body. Third-party body mods may behave differently. be_skins.xml remains excluded.

WHAT THIS DOES
This installs the tested EquipmentOnly module for a vanilla Bannerlord campaign. The current working baseline includes the culture remaps, custom melee weapon crafting registrations, the XML compatibility repairs, and the TWB_Javelin holster/display fix.

REQUIREMENTS / MATCHED SETUP
- Mount & Blade II: Bannerlord 1.4.8 with the Naval DLC version used by the working setup (1.2.8.0).
- An installed/extracted Burning Empires 2.0 module containing AssetPackages\pack0.tpac through pack3.tpac.
- Windows PowerShell (included with supported Windows installations).

INSTALL STEPS
1. Download Burning Empires from its official page and extract/install it into Bannerlord\Modules\BurningEmpires. Follow the mod author's install instructions, including any .bat files supplied in the original download.
   Official page: https://www.nexusmods.com/mountandblade2bannerlord/mods/7750
2. Extract this installer ZIP anywhere (not inside Modules).
3. Double-click "Install_EquipmentOnly.bat" and follow any prompt. The installer tries to locate the game automatically; if it cannot, select the game's Modules folder (the folder containing Native and BurningEmpires).
4. Open the Bannerlord Launcher. Enable "Burning Empires Equipment Only". Disable the original "Burning Empires" conversion module. If "BurningEmpires_Elephants" is installed/enabled, disable that too. Keep Native, SandBoxCore and SandBox enabled as usual.
5. Start a new test or load your intended vanilla campaign, and inspect some custom melee weapons and javelins in Character Reload/inventory.

WHAT THE INSTALLER DOES SAFELY
- Copies pack0.tpac, pack1.tpac and pack2.tpac from your local BurningEmpires\AssetPackages folder.
- Makes a modified COPY of pack3.tpac in the new EquipmentOnly module, renaming the three ui_charactercreation_* resource identifiers to be_charactercreation_* to avoid the vanilla character-creation UI conflict. The original BurningEmpires files are never modified.
- Installs the current v0.7 XML baseline with v1.1 culture-assignment refinements.
- If BurningEmpires_EquipmentOnly already exists, moves it to a timestamped backup folder next to Modules before installing. The backup is outside Modules so the Launcher will not discover it as a second module.
- Checks that the required source TPACs and the expected pack3 resource names are present. If validation fails, it stops instead of replacing the existing install.

IMPORTANT
- This is an equipment-only companion module, not the Burning Empires total conversion. Do not enable both conversion and EquipmentOnly modules together.
- The original Burning Empires install is used as the source for asset files; its AssetPackages are not included in this ZIP.
- The pack3 name change is same-length binary replacement on a COPY. It checks required matches and preserves file size; it does not rewrite the source TPAC.
- The package was built around the working v0.7 setup (Bannerlord 1.4.8 / Naval DLC 1.2.8.0 and the matching Burning Empires asset-pack layout). If a future Burning Empires version changes the pack layout or resource names, this installer will stop and report the mismatch rather than guessing.
- Permission to publish this equipment-only companion has been obtained from the Burning Empires Team and Levente, the project lead. The original TPAC assets are not distributed in this ZIP; they are copied from the user's local BurningEmpires installation during setup.

UNINSTALL / ROLLBACK
- In the Launcher, disable "Burning Empires Equipment Only".
- Remove Modules\BurningEmpires_EquipmentOnly.
- If you had an older EquipmentOnly folder, restore it from the timestamped folder under the game's parent directory named _BurningEmpires_EquipmentOnly_Backups.
- The original Modules\BurningEmpires folder is left untouched.
