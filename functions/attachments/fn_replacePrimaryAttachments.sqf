params ["_configValue", "_loadoutTarget"];

removeAllPrimaryWeaponItems _loadoutTarget;
{ _loadoutTarget addPrimaryWeaponItem _x; } forEach _configValue;
