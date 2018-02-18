// usage: ["BLU_T", "BwFleck"] call GRAD_Loadout_FactionSetLoadout;

#define PREFIX grad
#define COMPONENT loadout
#include "\x\cba\addons\main\script_macros_mission.hpp"

params [["_faction",""],["_loadoutClass",""],["_global",false]];

GVAR(factionPathMap) setVariable [_faction,_loadoutClass,_global];
