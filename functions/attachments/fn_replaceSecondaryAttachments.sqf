private ["_configPath", "_loadoutTarget"];

// Get config entry
_configPath = _this select 0;
_loadoutTarget = _this select 1;

{ _loadoutTarget removeSecondaryWeaponItem _x; } forEach secondaryWeaponItems _loadoutTarget;
{ _loadoutTarget addSecondaryWeaponItem _x; } forEach getArray _configPath;