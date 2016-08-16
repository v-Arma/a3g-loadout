params ["_configValue", "_loadoutTarget"];

if(_configValue == "") then {
  _loadoutTarget removeWeapon (handgunWeapon _loadoutTarget);
} else {
  _loadoutTarget addWeapon _configValue;
};
