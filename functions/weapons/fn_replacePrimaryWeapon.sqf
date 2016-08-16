params ["_configValue", "_loadoutTarget"];

if(_configValue == "") then {
  _loadoutTarget removeWeapon (primaryWeapon _loadoutTarget);
} else {
  _loadoutTarget addWeapon _configValue;
};
