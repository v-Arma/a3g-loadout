private ["_configPath", "_loadoutTarget", "_backUpItems"];

// Get config entry
_configPath = _this select 0;
_loadoutTarget = _this select 1;

// Backup items ( contains magazines )
_backUpItems = backpackItems _loadoutTarget;

// We need to explicibly remove the backpack here, because otherwise it gets dropped on the floor
removeBackpack _loadoutTarget;

if(getText _configPath == "") then {
  { _loadoutTarget addItem _x; } forEach _backUpItems;
} else {
  _loadoutTarget addBackpack getText (_configPath);
  // Newly spawned backpacks are auto filled with their config loadouts. We don't want this, so we clear them out at this point
  { _loadoutTarget removeItemFromBackpack _x; } forEach backpackItems _loadoutTarget;
  // Reapply items
  { _loadoutTarget addItemToBackpack _x;} forEach _backUpItems;
};