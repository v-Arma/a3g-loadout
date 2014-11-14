// Get config entry
_configPath = _this select 0;

// Backup items ( contains magazines )
_backUpItems = vestItems player;

if(getText _configPath == "") then {
	removeVest player;
	{ player addItem _x; } forEach _backUpItems;
} else {
	player addVest getText (_configPath);
	// Reapply items
	{ player addItemToVest _x; } forEach _backUpItems;
};