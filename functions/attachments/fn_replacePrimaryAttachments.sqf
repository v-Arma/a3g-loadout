private ["_configPath", "_loadoutTarget"];

// Get config entry
_configPath = _this select 0;
_loadoutTarget = _this select 1;

removeAllPrimaryWeaponItems _loadoutTarget;
{ _loadoutTarget addPrimaryWeaponItem _x; } forEach getArray (_configPath);