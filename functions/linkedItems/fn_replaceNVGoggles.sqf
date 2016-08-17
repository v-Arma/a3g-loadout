params ["_configValue", "_loadoutTarget"];
if(_configValue == "") then {
  _loadoutTarget unlinkItem (hmd _loadoutTarget);
} else {
  _loadoutTarget linkItem _configValue;
};
