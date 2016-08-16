params ["_configValue", "_loadoutTarget"];

removeAllHandgunItems _loadoutTarget;
{ _loadoutTarget addHandgunItem _x; } forEach _configValue;
