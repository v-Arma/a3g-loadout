
#define PREFIX grad
#define COMPONENT loadout
#include "\x\cba\addons\main\script_macros_mission.hpp"

params  ["_loadoutHash", "_loadoutTarget"];

if (typeName _loadoutHash != "ARRAY") then {
    throw "loadoutHash is not of type array (and thus, no cba hash) :(("
};

_unitLoadout = [
  [], [], [], // weapons
  [], [], [], // containers
  "", "", // helm, goggles
  [], // binos (weap4)
  ["", "", "", "", "", "" ] // assignedItems
];

_resetLoadout = [(missionConfigFile >> "Loadouts"), "resetLoadout", 0] call BIS_fnc_returnConfigEntry;
if (_resetLoadout == 0) then {
    _unitLoadout = getUnitLoadout _loadoutTarget;
};
if (count _unitLoadout == 0) exitWith {};

_unitLoadout = [_loadoutHash, _unitLoadout] call FUNC(hashToUnitLoadout);

if (_loadoutTarget == player) then {
    diag_log _unitLoadout;
};

_loadoutTarget setUnitLoadout [_unitLoadout, true];

_loadoutTarget setVariable ["GRAD_loadout_applicationCount", (_loadoutTarget getVariable ["GRAD_loadout_applicationCount", 0]) + 1];
