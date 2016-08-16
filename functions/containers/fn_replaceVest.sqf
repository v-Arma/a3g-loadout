params ["_configValue", "_loadoutTarget"];
private ["_backUpItems"];

// Backup items ( contains magazines )
_backUpItems = vestItems _loadoutTarget;

if(_configValue == "") then {
  removeVest _loadoutTarget;
  { _loadoutTarget addItem _x; } forEach _backUpItems;
} else {
  _loadoutTarget addVest _configValue;
  // Reapply items
  { _loadoutTarget addItemToVest _x; } forEach _backUpItems;
};
