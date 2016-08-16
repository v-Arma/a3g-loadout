params ["_configValue", "_loadoutTarget"];

if(_configValue == "") then {
  _loadoutTarget unlinkItem "ItemMap";
} else {
  _loadoutTarget linkItem _configValue;
};
