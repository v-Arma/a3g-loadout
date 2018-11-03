
#define PREFIX grad
#define COMPONENT loadout
#include "\x\cba\addons\main\script_macros_mission.hpp"

params ["_unit", "_configPath"];

private _getSidePath = {
    _configPath >> "Side" >> _this;
};

TRACE_2("finding config values for %1 in path %2 ...", _unit, _configPath);

private _loadoutHierarchy = [];

private _extractor = [_unit, _loadoutHierarchy] call FUNC(GetPathExtractor);

[_configPath >> "AllUnits", {true}] call _extractor;
[_configPath >> "AllAi", {!isPlayer _unit}] call _extractor;
[_configPath >> "AllPlayable", {_unit in playableUnits}] call _extractor;
[_configPath >> "AllPlayers", {isPlayer _unit}] call _extractor;

[_configPath >> "AllUnits" >> "Type" >> typeOf _unit, {true}] call _extractor;
[_configPath >> "AllAi" >> "Type" >> typeOf _unit, {!isPlayer _unit}] call _extractor;
[_configPath >> "AllPlayable" >> "Type" >> typeOf _unit, {_unit in playableUnits}] call _extractor;
[_configPath >> "AllPlayers" >> "Type" >> typeOf _unit, {isPlayer _unit}] call _extractor;

[("Blufor" call _getSidePath), {side _unit == blufor}] call _extractor;
[("Opfor" call _getSidePath),{side _unit == opfor}] call _extractor;
[("Independent" call _getSidePath), {side _unit == independent}] call _extractor;
[("Civilian" call _getSidePath), {side _unit == civilian}] call _extractor;

["BluforAi" call _getSidePath, { side _unit == blufor && { !isPlayer _unit }}] call _extractor;
["OpforAi" call _getSidePath, {side _unit == opfor && { !isPlayer _unit }}] call _extractor;
["IndependentAi" call _getSidePath, { side _unit == independent && { !isPlayer _unit }}] call _extractor;
["CivilianAi" call _getSidePath, {side _unit == civilian && { !isPlayer _unit }}] call _extractor;

["BluforPlayers" call _getSidePath, { side _unit == blufor && { isPlayer _unit }}] call _extractor;
["OpforPlayers" call _getSidePath, {side _unit == opfor && { isPlayer _unit }}] call _extractor;
["IndependentPlayers" call _getSidePath, { side _unit == independent && { isPlayer _unit }}] call _extractor;
["CivilianPlayers" call _getSidePath, {side _unit == civilian && { isPlayer _unit }}] call _extractor;

[_configPath >> "Type" >> typeOf _unit, {true}] call _extractor;
[_configPath >> "Rank" >> rank _unit, {true}] call _extractor;
[_configPath >> "Type" >> typeof _unit >> "Rank" >> rank _unit, {true}] call _extractor;

private _str = str _unit splitString "_" select 0;
private _namePath = _configPath >> "Name" >> _str;
[_namePath, {true}] call _extractor;

private _role = [roleDescription _unit] call BIS_fnc_filterString;
private _rolePath = _configPath >> "Role" >> _role;
[_rolePath, {true}] call _extractor; // Roledescription based loadouts

private _factionPathBit = ([faction _unit] call FUNC(FactionGetLoadout));
private _factionPath = _configPath >> "Faction" >> _factionPathBit;

[_factionPath >> "AllUnits", {true}] call _extractor;
[_factionPath >> "AllAi", {!isPlayer _unit}] call _extractor;

[_factionPath >> "AllPlayers", {isPlayer _unit}] call _extractor;

private _factionTypeConfig = "true" configClasses (_factionPath >> "Type");
if (count _factionTypeConfig > 0) then {
    TRACE_1("type configs for faction %1 exist", _factionPath);
    private _typeBit = [_unit] call FUNC(DefactionizeType);
    if (_typeBit != "") then {
        [_factionPath >> "Type" >> _typeBit, {true}] call _extractor;
        [_factionPath >> "Type" >> _typeBit >> "Rank" >> rank _unit, {true}] call _extractor;
    };
} else {
    TRACE_1("no type configs for faction %1", _factionPath);
};

[_factionPath >> "Rank" >> (rank _unit), {true}] call _extractor;
[_factionPath >> "Role" >> _role, {true}] call _extractor;

#ifdef DEBUG_MODE_NORMAL
if (count _loadoutHierarchy == 0) then {
    INFO_1("no loadout config values could be found for %1", _unit);
};
#endif
#ifdef DEBUG_MODE_FULL
if (_unit == player) then {
    INFO_1("complete loadout config for player: %1", _loadoutHierarchy);
};
#endif

private _actualLoadout = [_loadoutHierarchy] call FUNC(MergeLoadoutHierarchy);

_actualLoadout
