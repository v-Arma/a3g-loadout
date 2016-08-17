params ["_configValue", "_loadoutTarget"];

{ _loadoutTarget addItemToUniform _x; } forEach _configValue;
