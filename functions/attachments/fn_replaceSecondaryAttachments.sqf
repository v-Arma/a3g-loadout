params ["_configValue", "_loadoutTarget"];

{ _loadoutTarget removeSecondaryWeaponItem _x; } forEach secondaryWeaponItems _loadoutTarget;
{ _loadoutTarget addSecondaryWeaponItem _x; } forEach _configValue;
