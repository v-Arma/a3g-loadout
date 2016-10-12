
#define PREFIX grad
#define COMPONENT loadout
#include "\x\cba\addons\main\script_macros_mission.hpp"

params ["_unit", "_configPath"];
private ["_loadoutHierarchy"];

_getSidePath = {
    _configPath >> "Side" >> _this;
};

_msg = format ["finding config values for %1 in path %2 :", _unit, _configPath];
LOG(_msg);

// General --------------------------------------------------------------------------------------
// Every single unit
_loadoutHierarchy = [];

if (isClass (_configPath >> "AllUnits")) then {
    LOG("adding values from AllUnits");
    _loadoutHierarchy pushBack ([_configPath >> "AllUnits"] call A3G_Loadout_fnc_ExtractLoadoutFromConfig);
};

// All AI units
if( !isPlayer _unit && { isClass ( _configPath >> "AllAi" )}) then {
    LOG("adding values from AllAi");
    _loadoutHierarchy pushBack ([_configPath >> "AllAi"] call A3G_Loadout_fnc_ExtractLoadoutFromConfig);
};

// All playable units
if (_unit in playableUnits && { isClass ( _configPath >> "AllPlayable")}) then {
    LOG("adding values from AllPlayable");
    _loadoutHierarchy pushBack ([_configPath >> "AllPlayable"] call A3G_Loadout_fnc_ExtractLoadoutFromConfig);
};

// All players
if( isPlayer _unit && { isClass ( _configPath >> "AllPlayers" )}) then {
    LOG("adding values from AllPlayers");
    _loadoutHierarchy pushBack ([_configPath >> "AllPlayers"] call A3G_Loadout_fnc_ExtractLoadoutFromConfig);
};

// General of certain Type ---------------------------------------------------------------------
// Every single unit
if (isClass (_configPath >> "AllUnits" >> "Type" >> typeof _unit)) then {
    LOG("adding values from Type/<type>");
    _loadoutHierarchy pushBack ([_configPath >> "AllUnits"  >> "Type" >> typeof _unit] call A3G_Loadout_fnc_ExtractLoadoutFromConfig);
};

// All AI units
if( !isPlayer _unit && { isClass ( _configPath >> "AllAi" >> "Type" >> typeof _unit )}) then {
    LOG("adding values from AllAi/Type/<type>");
    _loadoutHierarchy pushBack ([_configPath >> "AllAi"  >> "Type" >> typeof _unit] call A3G_Loadout_fnc_ExtractLoadoutFromConfig);
};

// All playable units
if (_unit in playableUnits && { isClass ( _configPath >> "AllPlayable" >> "Type" >> typeof _unit)}) then {
    LOG("adding values from AllPlayable/Type/<type>");
      _loadoutHierarchy pushBack ([_configPath >> "AllPlayable"  >> "Type" >> typeof _unit] call A3G_Loadout_fnc_ExtractLoadoutFromConfig);
};

// All players
if( isPlayer _unit && { isClass ( _configPath >> "AllPlayers" >> "Type" >> typeof _unit)}) then {
    LOG("adding values from AllPlayers/Type/<type>");
    _loadoutHierarchy pushBack ([_configPath >> "AllPlayers"  >> "Type" >> typeof _unit] call A3G_Loadout_fnc_ExtractLoadoutFromConfig);
};

// General sides --------------------------------------------------------------------------------

_sidePath = "Blufor" call _getSidePath;
if( side _unit == blufor && { isClass (_sidePath)}) then {
    _msg = format["adding values from %1", _sidePath];
    LOG(_msg);
    _loadoutHierarchy pushBack ([_sidePath] call A3G_Loadout_fnc_ExtractLoadoutFromConfig);
};

_sidePath = "Opfor" call _getSidePath;
if( side _unit == opfor && { isClass (_sidePath)}) then {
    _msg = format["adding values from %1", _sidePath];
    LOG(_msg);
    _loadoutHierarchy pushBack ([_sidePath] call A3G_Loadout_fnc_ExtractLoadoutFromConfig);
};

_sidePath = "Independent" call _getSidePath;
if( side _unit == independent && { isClass (_sidePath)}) then {
    _msg = format["adding values from %1", _sidePath];
    LOG(_msg);
    _loadoutHierarchy pushBack ([_sidePath] call A3G_Loadout_fnc_ExtractLoadoutFromConfig);
};

// All civilian units
_sidePath = "Civilian" call _getSidePath;
if( side _unit == civilian && { isClass (_sidePath)}) then {
    _msg = format["adding values from %1", _sidePath];
    LOG(_msg);
    _loadoutHierarchy pushBack ([_sidePath] call A3G_Loadout_fnc_ExtractLoadoutFromConfig);
};

// AI sides -------------------------------------------------------------------------------------
if( side _unit == blufor && { !isPlayer _unit } && { isClass (_sidePath)}) then {
    _sidePath = "BluforAi" call _getSidePath;
    _loadoutHierarchy pushBack ([_sidePath] call A3G_Loadout_fnc_ExtractLoadoutFromConfig);
};

_sidePath = "OpforAi" call _getSidePath;
if( side _unit == opfor && { !isPlayer _unit } && { isClass (_sidePath)}) then {
    _msg = format["adding values from %1", _sidePath];
    LOG(_msg);
    _loadoutHierarchy pushBack ([_sidePath] call A3G_Loadout_fnc_ExtractLoadoutFromConfig);
};

_sidePath = "IndependentAi" call _getSidePath;
if( side _unit == independent && { !isPlayer _unit } && { isClass (_sidePath)}) then {
    _msg = format["adding values from %1", _sidePath];
    LOG(_msg);
    _loadoutHierarchy pushBack ([_sidePath] call A3G_Loadout_fnc_ExtractLoadoutFromConfig);
};

_sidePath = "CivilianAi" call _getSidePath;
if( side _unit == civilian && { !isPlayer _unit } && { isClass (_sidePath)}) then {
    _msg = format["adding values from %1", _sidePath];
    LOG(_msg);
    _loadoutHierarchy pushBack ([_sidePath] call A3G_Loadout_fnc_ExtractLoadoutFromConfig);
};

// Player sides ---------------------------------------------------------------------------------
_sidePath = "BluforPlayers" call _getSidePath;
if( side _unit == blufor && { isPlayer _unit } && { isClass (_sidePath)}) then {
    _msg = format["adding values from %1", _sidePath];
    LOG(_msg);
    _loadoutHierarchy pushBack ([_sidePath] call A3G_Loadout_fnc_ExtractLoadoutFromConfig);
};

_sidePath = "OpforPlayers" call _getSidePath;
if( side _unit == opfor && { isPlayer _unit } && { isClass (_sidePath)}) then {
    _msg = format["adding values from %1", _sidePath];
    LOG(_msg);
    _loadoutHierarchy pushBack ([_sidePath] call A3G_Loadout_fnc_ExtractLoadoutFromConfig);
};

_sidePath = "IndependentPlayers" call _getSidePath;
if( side _unit == independent && { isPlayer _unit } && { isClass (_sidePath)}) then {
    _msg = format["adding values from %1", _sidePath];
    LOG(_msg);
    _loadoutHierarchy pushBack ([_sidePath] call A3G_Loadout_fnc_ExtractLoadoutFromConfig);
};

_sidePath = "CivilianPlayers" call _getSidePath;
if( side _unit == civilian && { isPlayer _unit } && { isClass (_sidePath)}) then {
    _msg = format["adding values from %1", _sidePath];
    LOG(_msg);
    _loadoutHierarchy pushBack ([_sidePath] call A3G_Loadout_fnc_ExtractLoadoutFromConfig);
};

_typePath = _configPath >> "Type" >> typeof _unit;
if( isClass (_typePath)) then {
    _msg = format["adding values from %1", _typePath];
    LOG(_msg);
    _loadoutHierarchy pushBack ([_typePath] call A3G_Loadout_fnc_ExtractLoadoutFromConfig);
};

_rankPath = _configPath >> "Rank" >> rank _unit;
if( isClass (_rankPath)) then {
    _msg = format["adding values from %1", _rankPath];
    LOG(_msg);
    _loadoutHierarchy pushBack ([_rankPath] call A3G_Loadout_fnc_ExtractLoadoutFromConfig);
};

_str = str _unit splitString "_" select 0;
_namePath = _configPath >> "Name" >> _str;
if( isClass (_namePath)) then {
    _msg = format["adding values from %1", _namePath];
    LOG(_msg);
  _loadoutHierarchy pushBack ([_namePath] call A3G_Loadout_fnc_ExtractLoadoutFromConfig);
};

// Roledescription based loadouts
_role = [roleDescription _unit] call BIS_fnc_filterString;
_rolePath = _configPath >> "Role" >> _role;
if( isClass (_rolePath)) then {
    _msg = format["adding values from %1", _rolePath];
    LOG(_msg);
    _loadoutHierarchy pushBack ([_rolePath] call A3G_Loadout_fnc_ExtractLoadoutFromConfig);
};

#ifdef DEBUG_MODE_NORMAL
if (count _loadoutHierarchy == 0) then {
    _msg = format ["no loadout config values could be found for %1", _unit];
    LOG(_msg);
};
#endif

_actualLoadout = [_loadoutHierarchy] call A3G_Loadout_fnc_mergeLoadoutHierarchy;

_actualLoadout
