#define PREFIX a3g
#define COMPONENT loadout
#include "\x\cba\addons\main\script_macros_mission.hpp"

private ["_delay", "_getDelay"];

_getDelay = {
    _baseDelay = [(missionConfigFile >> "Loadouts"), "baseDelay", 10] call BIS_fnc_returnConfigEntry;
    _perPlayerDelay = [(missionConfigFile >> "Loadouts"), "perPlayerDelay", 1] call BIS_fnc_returnConfigEntry;

    _baseDelay + floor(_perPlayerDelay * random (count allPlayers));
};

_delay = [] call _getDelay;

_msg = format ["waiting %1 s for loadout...", _delay];
LOG(_msg);
systemChat _msg;

[
	{
        _msg = "triggering loadout...";
		LOG(_msg);
        systemChat _msg;
		[_this select 0] call A3G_Loadout_fnc_ApplyLoadout;
        _msg = "loadout was applied.";
        LOG(_msg);
        systemChat _msg;
	},
	[_this select 0],
	_delay
] call CBA_fnc_waitAndExecute;
