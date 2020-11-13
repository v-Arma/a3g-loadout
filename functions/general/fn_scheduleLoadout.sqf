#include "component.hpp"

params ["",["_didJIP",false]];

private _getDelay = {
    params ["_didJIP"];

    private _baseDelay = [(missionConfigFile >> "Loadouts"), "baseDelay", 10] call BIS_fnc_returnConfigEntry;
    if (_didJIP) exitWith {_baseDelay};

    private _perPlayerDelay = [(missionConfigFile >> "Loadouts"), "perPlayerDelay", 1] call BIS_fnc_returnConfigEntry;

    _baseDelay + floor(_perPlayerDelay * random (count allPlayers))
};

private _delay = [_didJIP] call _getDelay;

INFO_1("waiting %1 s for loadout...", _delay);

[
	{
		INFO("triggering loadout...");
		[_this select 0] call FUNC(ApplyLoadout);
        INFO("loadout was applied.");
	},
	[_this select 0],
	_delay
] call CBA_fnc_waitAndExecute;
