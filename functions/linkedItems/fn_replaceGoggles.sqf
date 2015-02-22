private ["_configPath", "_loadoutTarget"];

// Get config entry
_configPath = _this select 0;
_loadoutTarget = _this select 1;

if(getText _configPath == "") then {
  removeGoggles _loadoutTarget;
} else {
  _loadoutTarget addGoggles getText (_configPath);
};
