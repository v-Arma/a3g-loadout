// usage: ["BLU_T", "BwFleck"] call GRAD_Loadout_FactionSetLoadout;

private _faction = param [0];
private _loadoutClass = param [1];

[GRAD_Loadout_factionPathMap, _faction, _loadoutClass] call CBA_fnc_hashSet;
