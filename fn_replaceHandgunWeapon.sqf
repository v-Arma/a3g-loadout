// Get config entry
_configPath = _this select 0;

if(getText _configPath == "") then {
	player removeWeapon (handgunWeapon player);
} else {
	player addWeapon getText _configPath;
};
