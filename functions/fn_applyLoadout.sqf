_configFile = missionConfigFile >> "CfgLoadouts";

_respawn = if ( isNil { _this select 0 }) then { true } else { false };

// Make sure that only local player is considered as local target on respawn.
// This is because AI don't respawn, and we especially don't want to have local AI go through an entire loadout loop again, everytime the player respawns that the AI belongs to.
_units = [];
if( _respawn ) then {
	_units pushBack player;
	hint "fires";
} else {
	{
		if ( local _x ) then {
			_units pushBack _x;
		};
	} forEach allUnits;
};

{
	// Find out if there's a loadout for this unit from AllUnits.
	if(isClass (_configFile >> "AllUnits")) then {
		[_configFile, "AllUnits", _x] call A3G_Loadout_fnc_DoLoadout;
	};

	// Find out if there's a loadout for this unit from AllAi.
	if(isClass (_configFile >> "AllAi") && !isPlayer _x) then {
		[_configFile, "AllAi", _x] call A3G_Loadout_fnc_DoLoadout;
	};

	// Find out if there's a loadout for this unit from AllPlayers.
	if(isClass (_configFile >> "AllPlayers") && isPlayer _x) then {
		[_configFile, "AllPlayers", _x] call A3G_Loadout_fnc_DoLoadout;
	};

	// Find out if there's a loadout for this unit from Class.
	if(isClass (_configFile >> typeof _x)) then {
		[_configFile, typeof _x, _x] call A3G_Loadout_fnc_DoLoadout;
	};

	// Find out if there's a loadout for this unit from Unique.
	if(isClass (_configFile >> str _x)) then {
		[_configFile, str _x, _x] call A3G_Loadout_fnc_DoLoadout;
	};
} forEach _units;