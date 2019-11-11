// usage: ["BLU_T", "BwFleck"] call GRAD_Loadout_FactionSetLoadout;

#include "component.hpp"

params [["_faction",""],["_loadoutClass",""],["_global",false]];

GVAR(factionPathMap) setVariable [_faction,_loadoutClass,_global];
