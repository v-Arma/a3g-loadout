// Get config entry
_configPath = _this select 0;

removeAllHandgunItems player;
{ player addHandgunItem _x; } forEach getArray (_configPath);