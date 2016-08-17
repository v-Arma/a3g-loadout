params ["_configValue", "_loadoutTarget"];

if(_configValue == "") then {
  _loadoutTarget unlinkItem "ItemRadio";
} else {
  _loadoutTarget linkItem _configValue;
};
