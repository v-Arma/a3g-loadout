private ["_configPath", "_entryName", "_exists"];

_configPath = _this select 0;
_entryName = _this select 1;

_exists = [_configPath, _entryName, false] call bis_fnc_returnConfigEntry;
if(_exists isEqualTo false) exitWith { false };

// return
true