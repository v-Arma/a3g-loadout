params ["_configValue", "_loadoutTarget"];
private ["_backUpItems"];

// Backup items ( contains magazines )
_backUpItems = uniformItems _loadoutTarget;

if(_configValue == "") then {
  removeUniform _loadoutTarget;
  { _loadoutTarget addItem _x; } forEach _backUpItems;
} else {
  _loadoutTarget forceAddUniform _configValue;
  // Reapply items
  { _loadoutTarget addItemToUniform _x; } forEach _backUpItems;
};
