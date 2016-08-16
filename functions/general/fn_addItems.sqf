params ["_configValue", "_loadoutTarget"];

{ _loadoutTarget addItem _x; } forEach _configValue;
