private ["_configPath", "_isMissionStart", "_sidePath", "_getSidePath", "_rolePath", "_namePath", "_typePath"];
params [["_mode", ""]];

_configPath = missionConfigFile >> "Loadouts";
if (!isNil "GRAD_Loadout_Chosen_Prefix") then {
    _configPath = _configPath >> GRAD_Loadout_Chosen_Prefix;
};

_isMissionStart = if (typeName _mode == "STRING") then {if (_mode == "postInit") then {true} else {false}} else {false};

// Make sure that only local player is considered as target on respawn.
// This is because AI don't respawn, and we especially don't want to have local AI go through an entire loadout loop again, everytime the player respawns that the AI belongs to.
_units = [_isMissionStart] call A3G_Loadout_fnc_GetApplicableUnits;

_getSidePath = {
    _configPath >> "Side" >> _this;
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

	// All playable units
	if (_x in playableUnits && { isClass ( _configPath >> "AllPlayable")}) then {
	      _loadoutHierarchy pushBack ([_configPath >> "AllPlayable"] call A3G_Loadout_fnc_ExtractLoadoutFromConfig);
	};

	// All players
	if( isPlayer _x && { isClass ( _configPath >> "AllPlayers" )}) then {
        _loadoutHierarchy pushBack ([_configPath >> "AllPlayers"] call A3G_Loadout_fnc_ExtractLoadoutFromConfig);
	};

	// General of certain Type ---------------------------------------------------------------------
	// Every single unit
	if (isClass (_configPath >> "AllUnits" >> "Type" >> typeof _x)) then {
        _loadoutHierarchy pushBack ([_configPath >> "AllUnits"  >> "Type" >> typeof _x] call A3G_Loadout_fnc_ExtractLoadoutFromConfig);
	};

	// All AI units
	if( !isPlayer _x && { isClass ( _configPath >> "AllAi" >> "Type" >> typeof _x )}) then {
        _loadoutHierarchy pushBack ([_configPath >> "AllAi"  >> "Type" >> typeof _x] call A3G_Loadout_fnc_ExtractLoadoutFromConfig);
	};

	// All playable units
	if (_x in playableUnits && { isClass ( _configPath >> "AllPlayable" >> "Type" >> typeof _x)}) then {
	      _loadoutHierarchy pushBack ([_configPath >> "AllPlayable"  >> "Type" >> typeof _x] call A3G_Loadout_fnc_ExtractLoadoutFromConfig);
	};

	// All players
	if( isPlayer _x && { isClass ( _configPath >> "AllPlayers" >> "Type" >> typeof _x)}) then {
        _loadoutHierarchy pushBack ([_configPath >> "AllPlayers"  >> "Type" >> typeof _x] call A3G_Loadout_fnc_ExtractLoadoutFromConfig);
	};

	// General sides --------------------------------------------------------------------------------

    _sidePath = "Blufor" call _getSidePath;
	if( side _x == blufor && { isClass (_sidePath)}) then {
        _loadoutHierarchy pushBack ([_sidePath] call A3G_Loadout_fnc_ExtractLoadoutFromConfig);
	};

    _sidePath = "Opfor" call _getSidePath;
	if( side _x == opfor && { isClass (_sidePath)}) then {
        _loadoutHierarchy pushBack ([_sidePath] call A3G_Loadout_fnc_ExtractLoadoutFromConfig);
	};

    _sidePath = "Independent" call _getSidePath;
	if( side _x == independent && { isClass (_sidePath)}) then {
        _loadoutHierarchy pushBack ([_sidePath] call A3G_Loadout_fnc_ExtractLoadoutFromConfig);
	};

	// All civilian units
    _sidePath = "Civilian" call _getSidePath;
	if( side _x == civilian && { isClass (_sidePath)}) then {
        _loadoutHierarchy pushBack ([_sidePath] call A3G_Loadout_fnc_ExtractLoadoutFromConfig);
	};

	// AI sides -------------------------------------------------------------------------------------
	if( side _x == blufor && { !isPlayer _x } && { isClass (_sidePath)}) then {
        _sidePath = "BluforAi" call _getSidePath;
		_loadoutHierarchy pushBack ([_sidePath] call A3G_Loadout_fnc_ExtractLoadoutFromConfig);
	};

	_sidePath = "OpforAi" call _getSidePath;
	if( side _x == opfor && { !isPlayer _x } && { isClass (_sidePath)}) then {
		_loadoutHierarchy pushBack ([_sidePath] call A3G_Loadout_fnc_ExtractLoadoutFromConfig);
	};

	_sidePath = "IndependentAi" call _getSidePath;
	if( side _x == independent && { !isPlayer _x } && { isClass (_sidePath)}) then {
		_loadoutHierarchy pushBack ([_sidePath] call A3G_Loadout_fnc_ExtractLoadoutFromConfig);
	};

	_sidePath = "CivilianAi" call _getSidePath;
	if( side _x == civilian && { !isPlayer _x } && { isClass (_sidePath)}) then {
		_loadoutHierarchy pushBack ([_sidePath] call A3G_Loadout_fnc_ExtractLoadoutFromConfig);
	};

	// Player sides ---------------------------------------------------------------------------------
	_sidePath = "BluforPlayers" call _getSidePath;
	if( side _x == blufor && { isPlayer _x } && { isClass (_sidePath)}) then {
		_loadoutHierarchy pushBack ([_sidePath] call A3G_Loadout_fnc_ExtractLoadoutFromConfig);
	};

	_sidePath = "OpforPlayers" call _getSidePath;
	if( side _x == opfor && { isPlayer _x } && { isClass (_sidePath)}) then {
		_loadoutHierarchy pushBack ([_sidePath] call A3G_Loadout_fnc_ExtractLoadoutFromConfig);
	};

	_sidePath = "IndependentPlayers" call _getSidePath;
	if( side _x == independent && { isPlayer _x } && { isClass (_sidePath)}) then {
		_loadoutHierarchy pushBack ([_sidePath] call A3G_Loadout_fnc_ExtractLoadoutFromConfig);
	};

	_sidePath = "CivilianPlayers" call _getSidePath;
	if( side _x == civilian && { isPlayer _x } && { isClass (_sidePath)}) then {
		_loadoutHierarchy pushBack ([_sidePath] call A3G_Loadout_fnc_ExtractLoadoutFromConfig);
	};

    _typePath = _configPath >> "Type" >> typeof _x;
	if( isClass (_typePath)) then {
		_loadoutHierarchy pushBack ([_typePath] call A3G_Loadout_fnc_ExtractLoadoutFromConfig);
	};

    _rankPath = _configPath >> "Rank" >> rank _x;
	if( isClass (_rankPath)) then {
		_loadoutHierarchy pushBack ([_rankPath] call A3G_Loadout_fnc_ExtractLoadoutFromConfig);
	};

    _str = str _x splitString "_" select 0;
    _namePath = _configPath >> "Name" >> _str;
    if( isClass (_namePath)) then {
      _loadoutHierarchy pushBack ([_namePath] call A3G_Loadout_fnc_ExtractLoadoutFromConfig);
    };

    // Roledescription based loadouts
	_role = [roleDescription _x] call BIS_fnc_filterString;
    _rolePath = _configPath >> "Role" >> _role;
	if( isClass (_rolePath)) then {
		_loadoutHierarchy pushBack ([_rolePath] call A3G_Loadout_fnc_ExtractLoadoutFromConfig);
	};

    _actualLoadout = [_loadoutHierarchy] call A3G_Loadout_fnc_mergeLoadoutHierarchy;

    [_actualLoadout, _x] call A3G_Loadout_fnc_doLoadout;

} forEach _units;
