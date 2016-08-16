params ["_configValue", "_loadoutTarget"];

{ _loadoutTarget addItemToBackpack _x; } forEach _configValue;
