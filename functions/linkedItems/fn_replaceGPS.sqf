params ["_configValue", "_loadoutTarget"];

if(_configValue == "") then {
  _loadoutTarget unlinkItem "ItemGPS";
} else {
  _loadoutTarget linkItem _configValue;
};
