Burning Empires Equipment Only — v0.7 stable baseline

This companion module makes Burning Empires equipment available in a vanilla Bannerlord campaign without enabling the original Burning Empires total-conversion module.

Verified working in the user's test setup:
- Custom melee weapon recipes and crafting registrations.
- Culture remaps to vanilla cultures.
- XML compatibility fixes (unsupported NoBlood/appearance attributes and invalid piece references).
- TWB_Javelin holster/display fix, which makes the custom javelins render on the character.
- pack3 UI-resource isolation by renaming ui_charactercreation_1/2/3 to be_charactercreation_1/2/3 in the copied TPAC.

Culture mapping:
- Celtic/Germanic group -> Battania.
- Roman/imperial group -> Empire.
- Hunnic/steppe group -> Khuzait.
- Sassanid and related southern group -> Aserai.
- Slavic -> Sturgia.

Install through the included one-click installer in the parent package. It copies AssetPackages\pack0.tpac–pack3.tpac from the local BurningEmpires module and does not modify the original files. In the Bannerlord Launcher, enable this module and disable the original Burning Empires conversion module. If BurningEmpires_Elephants is installed/enabled, disable it too.

This does not add new campaign cultures, troops, factions, map or scenes. The culture names above are mapped to existing vanilla cultures. It is intended for the Bannerlord 1.4.8 / Naval DLC 1.2.8.0 setup used to verify the current baseline. Later Burning Empires asset versions may require revalidation.
