params ["_configValue", "_loadoutTarget"];

{ _loadoutTarget addMagazine _x; } forEach _configValue;
