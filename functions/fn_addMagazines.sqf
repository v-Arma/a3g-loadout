// Get config entry
_configPath = _this select 0;

{ player addMagazine _x; } forEach getArray (_configPath);