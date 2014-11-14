// Get config entry
_configPath = _this select 0;

// Backup items ( contains magazines )
_backUpItems = uniformItems player;

if(getText _configPath == "") then {
	removeUniform player;
	{ player addItem _x; } forEach _backUpItems;
} else {
	player forceAddUniform getText (_configPath);
	// Reapply items
	{ player addItemToUniform _x; } forEach _backUpItems;
};