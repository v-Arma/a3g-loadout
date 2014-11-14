// Get config entry
_configPath = _this select 0;

{ player removeMagazine _x; } forEach magazines player;
{ player addMagazine _x; } forEach getArray (_configPath);