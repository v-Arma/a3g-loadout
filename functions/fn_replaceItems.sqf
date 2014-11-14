// Get config entry
_configPath = _this select 0;

{ player removeItem _x; } forEach items player;
{ player addItem _x; } forEach getArray (_configPath);