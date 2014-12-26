// Get config entry
_configPath = _this select 0;

if(getText _configPath == "") then {
	removeHeadgear player;
} else {
	player addHeadgear getText (_configPath);
};
