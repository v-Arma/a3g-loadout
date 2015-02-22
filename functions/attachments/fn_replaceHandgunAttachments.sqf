private ["_configPath", "_loadoutTarget"];

// Get config entry
_configPath = _this select 0;
_loadoutTarget = _this select 1;

removeAllHandgunItems _loadoutTarget;
{ _loadoutTarget addHandgunItem _x; } forEach getArray (_configPath);