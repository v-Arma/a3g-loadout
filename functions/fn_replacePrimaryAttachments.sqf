// Get config entry
_configPath = _this select 0;

removeAllPrimaryWeaponItems player;
{ player addPrimaryWeaponItem _x; } forEach getArray (_configPath);