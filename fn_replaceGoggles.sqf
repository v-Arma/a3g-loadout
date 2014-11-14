// Get config entry
_configPath = _this select 0;

if(getText _configPath == "") then {
	removeGoggles player;
} else {
	player addGoggles getText (_configPath);
};
