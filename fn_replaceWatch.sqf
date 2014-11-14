// Get config entry
_configPath = _this select 0;

if(getText _configPath == "") then {
	player unlinkItem "ItemWatch";
} else {
	player linkItem getText (_configPath);
};