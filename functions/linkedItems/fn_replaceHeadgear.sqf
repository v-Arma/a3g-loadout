params ["_configValue", "_loadoutTarget"];

if(_configValue == "") then {
  removeHeadgear _loadoutTarget;
} else {
  _loadoutTarget addHeadgear _configValue;
};
