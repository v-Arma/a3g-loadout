// usage: ["BLU_T", "BwFleck"] call GRAD_Loadout_FactionSetLoadout;

params ["_faction", "_loadoutClass"];

[GRAD_Loadout_factionPathMap, _faction, _loadoutClass] call CBA_fnc_hashSet;
