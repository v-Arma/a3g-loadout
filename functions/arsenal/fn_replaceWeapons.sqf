private ["_configPath", "_loadoutTarget"];

// Get config entry
_configPath = _this select 0;
_loadoutTarget = _this select 1;

_loadoutTarget removeWeapon (primaryWeapon _loadoutTarget);
_loadoutTarget removeWeapon (secondaryWeapon _loadoutTarget);
_loadoutTarget removeWeapon (handgunWeapon _loadoutTarget);

// Workaround for that "hgun_P07_F" which doesn't get removed with removeWeapon
if (handgunWeapon _loadoutTarget == "hgun_P07_F") then {
  _loadoutTarget addWeapon "hgun_Pistol_heavy_01_F";
  _loadoutTarget removeWeapon "hgun_Pistol_heavy_01_F";
  _loadoutTarget removeMagazine "16Rnd_9x21_Mag";
  _loadoutTarget removeMagazine "16Rnd_9x21_Mag";
};

{ _loadoutTarget addWeapon _x; } forEach getArray (_configPath);