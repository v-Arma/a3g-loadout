// Get config entry
_configPath = _this select 0;

// Backup items ( contains magazines )
_backUpItems = backpackItems player;

// We need to explicibly remove the backpack here, because otherwise it gets dropped on the floor
removeBackpack player;

if(getText _configPath == "") then {
	{ player addItem _x; } forEach _backUpItems;
} else {
	player addBackpack getText (_configPath);
	// Newly spawned backpacks are auto filled with their config loadouts. We don't want this, so we clear them out at this point
	{ player removeItemFromBackpack _x; } forEach backpackItems player;
	// Reapply items
	{ player addItemToBackpack _x;} forEach _backUpItems;
};




