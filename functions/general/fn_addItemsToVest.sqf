params ["_configValue", "_loadoutTarget"];

{ _loadoutTarget addItemToVest _x; } forEach _configValue;
