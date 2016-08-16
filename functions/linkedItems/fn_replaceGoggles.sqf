params ["_configValue", "_loadoutTarget"];

if (_configValue == "") then {
  removeGoggles _loadoutTarget;
} else {
  _loadoutTarget addGoggles _configValue;
};
