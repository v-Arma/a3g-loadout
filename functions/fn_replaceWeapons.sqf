// Get config entry
_configPath = _this select 0;

player removeWeapon (primaryWeapon player);
player removeWeapon (secondaryWeapon player);
player removeWeapon (handgunWeapon player);

// Workaround for that "hgun_P07_F" which doesn't get removed with removeWeapon
if (handgunWeapon player == "hgun_P07_F") then {
	player addWeapon "hgun_Pistol_heavy_01_F";
	player removeWeapon "hgun_Pistol_heavy_01_F";
	player removeMagazine "16Rnd_9x21_Mag";
	player removeMagazine "16Rnd_9x21_Mag";
};

{ player addWeapon _x; } forEach getArray (_configPath);