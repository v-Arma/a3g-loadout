if ( isDedicated ) exitWith {};

if( isNumber ( missionConfigFile >> "CfgLoadouts" >> "allowRespawn")) then {
	player addEventHandler ["Respawn", { [] call A3G_Loadout_fnc_ApplyLoadout }];
};