private ["_configPath", "_loadoutTarget", "_backUpItems"];

// Get config entry
_configPath = _this select 0;
_loadoutTarget = _this select 1;

// Backup items ( contains magazines )
_backUpItems = vestItems _loadoutTarget;

if(getText _configPath == "") then {
  removeVest _loadoutTarget;
  { _loadoutTarget addItem _x; } forEach _backUpItems;
} else {
  _loadoutTarget addVest getText (_configPath);
  // Reapply items
  { _loadoutTarget addItemToVest _x; } forEach _backUpItems;
};