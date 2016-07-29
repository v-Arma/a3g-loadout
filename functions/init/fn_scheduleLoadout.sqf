private ["_delay"];

_delay = 10 + floor( random (count allPlayers));

hint format ["waiting %1 seconds to loadout", _delay];
[format ["waiting %1 s for loadout for %2...", _delay], "GRAD_mission_debug", [false, true, false] ] call CBA_fnc_debug;

[
	{
		["triggering loadout", "GRAD_mission_debug", [true, true, true] ] call CBA_fnc_debug;
		[_this select 0] call A3G_Loadout_fnc_ApplyLoadout;
	},
	[_this select 0],
	_delay
] call CBA_fnc_waitAndExecute;
