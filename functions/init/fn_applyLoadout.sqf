private ["_configPath", "_missionStart"];

_configPath = missionConfigFile >> "CfgLoadouts";
_missionStart = if ( !isNil { _this select 0 } && { _this select 0 == "postInit" }) then { true } else { false };

// Make sure that only local player is considered as target on respawn.
// This is because AI don't respawn, and we especially don't want to have local AI go through an entire loadout loop again, everytime the player respawns that the AI belongs to.
_units = [];
if( !_missionStart ) then {
	_units pushBack player;
} else {
	{
		if ( local _x ) then {
			_units pushBack _x;
		};
	} forEach allUnits;
};

{
	// General --------------------------------------------------------------------------------------
	// Every single unit
    _loadoutHierarchy = [];

	if (isClass (_configPath >> "AllUnits")) then {
        _loadoutHierarchy pushBack ([_configPath >> "AllUnits"] call A3G_Loadout_fnc_ExtractLoadoutFromConfig);
	};

	// All AI units
	if( !isPlayer _x && { isClass ( _configPath >> "AllAi" )}) then {
        _loadoutHierarchy pushBack ([_configPath >> "AllAi"] call A3G_Loadout_fnc_ExtractLoadoutFromConfig);
	};

	// All players
	if( isPlayer _x && { isClass ( _configPath >> "AllPlayers" )}) then {
        _loadoutHierarchy pushBack ([_configPath >> "AllPlayers"] call A3G_Loadout_fnc_ExtractLoadoutFromConfig);
	};

	// General sides --------------------------------------------------------------------------------
	// All blufor units
	if( side _x == blufor && { isClass ( _configPath >> "Blufor" )}) then {
        _loadoutHierarchy pushBack ([_configPath >> "Blufor"] call A3G_Loadout_fnc_ExtractLoadoutFromConfig);
	};

	// All opfor units
	if( side _x == opfor && { isClass ( _configPath >> "Opfor" )}) then {
        _loadoutHierarchy pushBack ([_configPath >> "Opfor"] call A3G_Loadout_fnc_ExtractLoadoutFromConfig);
	};

	// All independent units
	if( side _x == independent && { isClass ( _configPath >> "Independent" )}) then {
        _loadoutHierarchy pushBack ([_configPath >> "Independent"] call A3G_Loadout_fnc_ExtractLoadoutFromConfig);
	};

	// All civilian units
	if( side _x == civilian && { isClass ( _configPath >> "Civilian" )}) then {
        _loadoutHierarchy pushBack ([_configPath >> "Civilian"] call A3G_Loadout_fnc_ExtractLoadoutFromConfig);
	};

	// AI sides -------------------------------------------------------------------------------------
	// All blufor AI units
	if( side _x == blufor && { !isPlayer _x } && { isClass ( _configPath >> "BluforAi" )}) then {
		_loadoutHierarchy pushBack ([_configPath >> "BluforAi"] call A3G_Loadout_fnc_ExtractLoadoutFromConfig);
	};

	// All opfor AI units
	if( side _x == opfor && { !isPlayer _x } && { isClass ( _configPath >> "OpforAi" )}) then {
		_loadoutHierarchy pushBack ([_configPath >> "OpforAi"] call A3G_Loadout_fnc_ExtractLoadoutFromConfig);
	};

	// All independent AI units
	if( side _x == independent && { !isPlayer _x } && { isClass ( _configPath >> "IndependentAi" )}) then {
		_loadoutHierarchy pushBack ([_configPath >> "IndependentAi"] call A3G_Loadout_fnc_ExtractLoadoutFromConfig);
	};

	// All civilian AI units
	if( side _x == civilian && { !isPlayer _x } && { isClass ( _configPath >> "CivilianAi" )}) then {
		_loadoutHierarchy pushBack ([_configPath >> "CivilianAi"] call A3G_Loadout_fnc_ExtractLoadoutFromConfig);
	};

	// Player sides ---------------------------------------------------------------------------------
	// All blufor units
	if( side _x == blufor && { isPlayer _x } && { isClass ( _configPath >> "BluforPlayers" )}) then {
		_loadoutHierarchy pushBack ([_configPath >> "BluforPlayers"] call A3G_Loadout_fnc_ExtractLoadoutFromConfig);
	};

	// All opfor units
	if( side _x == opfor && { isPlayer _x } && { isClass ( _configPath >> "OpforPlayers" )}) then {
		_loadoutHierarchy pushBack ([_configPath >> "OpforPlayers"] call A3G_Loadout_fnc_ExtractLoadoutFromConfig);
	};

	// All independent units
	if( side _x == independent && { isPlayer _x } && { isClass ( _configPath >> "IndependentPlayers" )}) then {
		_loadoutHierarchy pushBack ([_configPath >> "IndependentPlayers"] call A3G_Loadout_fnc_ExtractLoadoutFromConfig);
	};

	// All civilian units
	if( side _x == civilian && { isPlayer _x } && { isClass ( _configPath >> "CivilianPlayers" )}) then {
		_loadoutHierarchy pushBack ([_configPath >> "CivilianPlayers"] call A3G_Loadout_fnc_ExtractLoadoutFromConfig);
	};

	// Class & Unique -------------------------------------------------------------------------------
	// Class based loadouts
	if( isClass ( _configPath >> typeof _x )) then {
		_loadoutHierarchy pushBack ([_configPath >> typeof _x] call A3G_Loadout_fnc_ExtractLoadoutFromConfig);
	};

	// Roledescription based loadouts
	_role = [roleDescription _x] call BIS_fnc_filterString;
	if( isClass ( _configPath >> _role )) then {
		_loadoutHierarchy pushBack ([_configPath >> _role] call A3G_Loadout_fnc_ExtractLoadoutFromConfig);
	};

    _actualLoadout = [_loadoutHierarchy] call A3G_Loadout_fnc_mergeLoadoutHierarchy;

    [_actualLoadout, _x] call A3G_Loadout_fnc_doLoadout;

} forEach _units;
