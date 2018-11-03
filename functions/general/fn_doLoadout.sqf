
#define PREFIX grad
#define COMPONENT loadout
#include "\x\cba\addons\main\script_macros_mission.hpp"

params ["_loadoutHash", "_loadoutTarget"];

if (typeName _loadoutHash != "ARRAY") then {
    throw "loadoutHash is not of type array (and thus, no cba hash) :(("
};

private _unitLoadout = [
  [], [], [], // weapons
  [], [], [], // containers
  "", "", // helm, goggles
  [], // binos (weap4)
  ["", "", "", "", "", "" ] // assignedItems
];

private _resetLoadout = [(missionConfigFile >> "Loadouts"), "resetLoadout", 0] call BIS_fnc_returnConfigEntry;
if (_resetLoadout == 0) then {
    _unitLoadout = getUnitLoadout _loadoutTarget;
};
if (count _unitLoadout == 0) exitWith {};

_unitLoadout = [_loadoutHash, _unitLoadout] call FUNC(HashToUnitLoadout);

if (_loadoutTarget == player) then {
    INFO_1("player loadout: %1", _unitLoadout);
};

[_loadoutTarget, [_unitLoadout, true]] remoteExec ["setUnitLoadout", _loadoutTarget, false];
[QGVAR(loadoutApplied), [_loadoutTarget, _unitLoadout], _loadoutTarget] call CBA_fnc_targetEvent;

_loadoutTarget setVariable [QGVAR(applicationCount), (_loadoutTarget getVariable [QGVAR(applicationCount), 0]) + 1, true];
