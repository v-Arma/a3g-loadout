
#define PREFIX grad
#define COMPONENT loadout
#include "\x\cba\addons\main\script_macros_mission.hpp"

params ["_unit", "_configPath"];
private ["_loadoutHierarchy"];

_getSidePath = {
    _configPath >> "Side" >> _this;
};

TRACE_2("finding config values for %1 in path %2 ...", _unit, _configPath);


_loadoutHierarchy = [];

if (isClass (_configPath >> "AllUnits")) then {
    LOG("adding values from AllUnits");
    _loadoutHierarchy pushBack ([_configPath >> "AllUnits"] call GRAD_Loadout_fnc_ExtractLoadoutFromConfig);
};

// All AI units
if( !isPlayer _unit && { isClass ( _configPath >> "AllAi" )}) then {
    LOG("adding values from AllAi");
    _loadoutHierarchy pushBack ([_configPath >> "AllAi"] call GRAD_Loadout_fnc_ExtractLoadoutFromConfig);
};

// All playable units
if (_unit in playableUnits && { isClass ( _configPath >> "AllPlayable")}) then {
    LOG("adding values from AllPlayable");
    _loadoutHierarchy pushBack ([_configPath >> "AllPlayable"] call GRAD_Loadout_fnc_ExtractLoadoutFromConfig);
};

// All players
if( isPlayer _unit && { isClass ( _configPath >> "AllPlayers" )}) then {
    LOG("adding values from AllPlayers");
    _loadoutHierarchy pushBack ([_configPath >> "AllPlayers"] call GRAD_Loadout_fnc_ExtractLoadoutFromConfig);
};

// General of certain Type ---------------------------------------------------------------------
// Every single unit
if (isClass (_configPath >> "AllUnits" >> "Type" >> typeof _unit)) then {
    LOG("adding values from Type/<type>");
    _loadoutHierarchy pushBack ([_configPath >> "AllUnits"  >> "Type" >> typeof _unit] call GRAD_Loadout_fnc_ExtractLoadoutFromConfig);
};

// All AI units
if( !isPlayer _unit && { isClass ( _configPath >> "AllAi" >> "Type" >> typeof _unit )}) then {
    LOG("adding values from AllAi/Type/<type>");
    _loadoutHierarchy pushBack ([_configPath >> "AllAi"  >> "Type" >> typeof _unit] call GRAD_Loadout_fnc_ExtractLoadoutFromConfig);
};

// All playable units
if (_unit in playableUnits && { isClass ( _configPath >> "AllPlayable" >> "Type" >> typeof _unit)}) then {
    LOG("adding values from AllPlayable/Type/<type>");
      _loadoutHierarchy pushBack ([_configPath >> "AllPlayable"  >> "Type" >> typeof _unit] call GRAD_Loadout_fnc_ExtractLoadoutFromConfig);
};

// All players
if( isPlayer _unit && { isClass ( _configPath >> "AllPlayers" >> "Type" >> typeof _unit)}) then {
    LOG("adding values from AllPlayers/Type/<type>");
    _loadoutHierarchy pushBack ([_configPath >> "AllPlayers"  >> "Type" >> typeof _unit] call GRAD_Loadout_fnc_ExtractLoadoutFromConfig);
};

// General sides --------------------------------------------------------------------------------

_sidePath = "Blufor" call _getSidePath;
if( side _unit == blufor && { isClass (_sidePath)}) then {
    TRACE_1("adding values from %1", _sidePath);
    _loadoutHierarchy pushBack ([_sidePath] call GRAD_Loadout_fnc_ExtractLoadoutFromConfig);
};

_sidePath = "Opfor" call _getSidePath;
if( side _unit == opfor && { isClass (_sidePath)}) then {
    TRACE_1("adding values from %1", _sidePath);
    _loadoutHierarchy pushBack ([_sidePath] call GRAD_Loadout_fnc_ExtractLoadoutFromConfig);
};

_sidePath = "Independent" call _getSidePath;
if( side _unit == independent && { isClass (_sidePath)}) then {
    TRACE_1("adding values from %1", _sidePath);
    _loadoutHierarchy pushBack ([_sidePath] call GRAD_Loadout_fnc_ExtractLoadoutFromConfig);
};

// All civilian units
_sidePath = "Civilian" call _getSidePath;
if( side _unit == civilian && { isClass (_sidePath)}) then {
    TRACE_1(["adding values from %1", _sidePath);
    _loadoutHierarchy pushBack ([_sidePath] call GRAD_Loadout_fnc_ExtractLoadoutFromConfig);
};

// AI sides -------------------------------------------------------------------------------------
if( side _unit == blufor && { !isPlayer _unit } && { isClass (_sidePath)}) then {
    _sidePath = "BluforAi" call _getSidePath;
    _loadoutHierarchy pushBack ([_sidePath] call GRAD_Loadout_fnc_ExtractLoadoutFromConfig);
};

_sidePath = "OpforAi" call _getSidePath;
if( side _unit == opfor && { !isPlayer _unit } && { isClass (_sidePath)}) then {
    TRACE_1("adding values from %1", _sidePath);
    _loadoutHierarchy pushBack ([_sidePath] call GRAD_Loadout_fnc_ExtractLoadoutFromConfig);
};

_sidePath = "IndependentAi" call _getSidePath;
if( side _unit == independent && { !isPlayer _unit } && { isClass (_sidePath)}) then {
    TRACE_1("adding values from %1", _sidePath);
    _loadoutHierarchy pushBack ([_sidePath] call GRAD_Loadout_fnc_ExtractLoadoutFromConfig);
};

_sidePath = "CivilianAi" call _getSidePath;
if( side _unit == civilian && { !isPlayer _unit } && { isClass (_sidePath)}) then {
    TRACE_1("adding values from %1", _sidePath);
    _loadoutHierarchy pushBack ([_sidePath] call GRAD_Loadout_fnc_ExtractLoadoutFromConfig);
};

// Player sides ---------------------------------------------------------------------------------
_sidePath = "BluforPlayers" call _getSidePath;
if( side _unit == blufor && { isPlayer _unit } && { isClass (_sidePath)}) then {
    TRACE_1("adding values from %1", _sidePath);
    _loadoutHierarchy pushBack ([_sidePath] call GRAD_Loadout_fnc_ExtractLoadoutFromConfig);
};

_sidePath = "OpforPlayers" call _getSidePath;
if( side _unit == opfor && { isPlayer _unit } && { isClass (_sidePath)}) then {
    TRACE_1("adding values from %1", _sidePath);
    _loadoutHierarchy pushBack ([_sidePath] call GRAD_Loadout_fnc_ExtractLoadoutFromConfig);
};

_sidePath = "IndependentPlayers" call _getSidePath;
if( side _unit == independent && { isPlayer _unit } && { isClass (_sidePath)}) then {
    TRACE_1("adding values from %1", _sidePath);
    _loadoutHierarchy pushBack ([_sidePath] call GRAD_Loadout_fnc_ExtractLoadoutFromConfig);
};

_sidePath = "CivilianPlayers" call _getSidePath;
if( side _unit == civilian && { isPlayer _unit } && { isClass (_sidePath)}) then {
    TRACE_1("adding values from %1", _sidePath);
    _loadoutHierarchy pushBack ([_sidePath] call GRAD_Loadout_fnc_ExtractLoadoutFromConfig);
};

_typePath = _configPath >> "Type" >> typeof _unit;
if( isClass (_typePath)) then {
    TRACE_1("adding values from %1", _typePath);
    _loadoutHierarchy pushBack ([_typePath] call GRAD_Loadout_fnc_ExtractLoadoutFromConfig);
};

_rankPath = _configPath >> "Rank" >> rank _unit;
if( isClass (_rankPath)) then {
    TRACE_1("adding values from %1", _rankPat);
    _loadoutHierarchy pushBack ([_rankPath] call GRAD_Loadout_fnc_ExtractLoadoutFromConfig);
};

_str = str _unit splitString "_" select 0;
_namePath = _configPath >> "Name" >> _str;
if( isClass (_namePath)) then {
    TRACE_1("adding values from %1", _namePath);
  _loadoutHierarchy pushBack ([_namePath] call GRAD_Loadout_fnc_ExtractLoadoutFromConfig);
};

// Roledescription based loadouts
_role = [roleDescription _unit] call BIS_fnc_filterString;
_rolePath = _configPath >> "Role" >> _role;
if( isClass (_rolePath)) then {
    TRACE_1("adding values from %1", _rolePath);
    _loadoutHierarchy pushBack ([_rolePath] call GRAD_Loadout_fnc_ExtractLoadoutFromConfig);
};

#ifdef DEBUG_MODE_NORMAL
if (count _loadoutHierarchy == 0) then {
    INFO_1("no loadout config values could be found for %1", _unit);
};
#endif

_actualLoadout = [_loadoutHierarchy] call GRAD_Loadout_fnc_mergeLoadoutHierarchy;

_actualLoadout
