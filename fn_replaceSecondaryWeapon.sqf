// Get config entry
_configPath = _this select 0;

if(getText _configPath == "") then {
	player removeWeapon (secondaryWeapon player);
} else {
	player addWeapon getText _configPath;
};
