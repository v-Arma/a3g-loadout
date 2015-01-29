// Get config entry
_configPath = _this select 0;

{ player removeSecondaryWeaponItem _x; } forEach secondaryWeaponItems player;
{ player addSecondaryWeaponItem _x; } forEach getArray _configPath;