#define PREFIX a3g
#define COMPONENT loadout
#include "\x\cba\addons\main\script_macros_mission.hpp"

private ["_delay", "_getDelay"];

_getDelay = {
    _baseDelay = [(missionConfigFile >> "CfgLoadouts"), "baseDelay", 10] call BIS_fnc_returnConfigEntry;
    _perPlayerDelay = [(missionConfigFile >> "CfgLoadouts"), "perPlayerDelay", 1] call BIS_fnc_returnConfigEntry;

    _baseDelay + floor(_perPlayerDelay * random (count allPlayers));
};

_delay = [] call _getDelay;

_msg = format ["waiting %1 s for loadout.", _delay];
LOG(_msg);

[
	{
		LOG("triggering loadout.");
		[_this select 0] call A3G_Loadout_fnc_ApplyLoadout;
	},
	[_this select 0],
	_delay
] call CBA_fnc_waitAndExecute;
