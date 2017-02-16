
#define PREFIX grad
#define COMPONENT loadout
#include "\x\cba\addons\main\script_macros_mission.hpp"


private ["_delay", "_getDelay"];

_getDelay = {
    _baseDelay = [(missionConfigFile >> "Loadouts"), "baseDelay", 10] call BIS_fnc_returnConfigEntry;
    _perPlayerDelay = [(missionConfigFile >> "Loadouts"), "perPlayerDelay", 1] call BIS_fnc_returnConfigEntry;

    _baseDelay + floor(_perPlayerDelay * random (count allPlayers));
};

_delay = [] call _getDelay;

INFO_1("waiting %1 s for loadout...", _delay);
systemChat format ["grad-loadout: waiting %1 s for loadout...", _delay];

[
	{
        _msg = "triggering loadout...";
		INFO(_msg);
        systemChat ("grad-loadout: " + _msg);
		[_this select 0] call FUNC(ApplyLoadout);
        _msg = "loadout was applied.";
        INFO(_msg);
        systemChat ("grad-loadout: " +  _msg);
	},
	[_this select 0],
	_delay
] call CBA_fnc_waitAndExecute;
