// Get config entry
_configPath = _this select 0;

{ player addItem _x; } forEach getArray (_configPath);