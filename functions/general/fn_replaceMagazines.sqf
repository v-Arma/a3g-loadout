params ["_configValue", "_loadoutTarget"];

{ _loadoutTarget removeMagazine _x; } forEach magazines _loadoutTarget;
{ _loadoutTarget addMagazine _x; } forEach _configValue;
