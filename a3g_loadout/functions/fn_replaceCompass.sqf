// Get config entry
_configPath = _this select 0;

if(getText _configPath == "") then {
	player unlinkItem "ItemCompass";
} else {
	player linkItem getText (_configPath);
};