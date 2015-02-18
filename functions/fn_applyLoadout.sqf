_configFile = missionConfigFile >> "CfgLoadouts";

_respawn = if ( isNil { _this select 0 }) then { true } else { false };

// Make sure that only local player is considered as target on respawn.
// This is because AI don't respawn, and we especially don't want to have local AI go through an entire loadout loop again, everytime the player respawns that the AI belongs to.
_units = [];
if( _respawn ) then {
  _units pushBack player;
} else {
  {
    if ( local _x ) then {
      _units pushBack _x;
    };
  } forEach allUnits;
};

{
  // General --------------------------------------------------------------------------------------
  // Every single unit
  if(isClass (_configFile >> "AllUnits")) then {
    [_configFile, "AllUnits", _x] call A3G_Loadout_fnc_DoLoadout;
  };

  // All AI units
  if(isClass (_configFile >> "AllAi") && !isPlayer _x) then {
    [_configFile, "AllAi", _x] call A3G_Loadout_fnc_DoLoadout;
  };

  // All players
  if(isClass (_configFile >> "AllPlayers") && isPlayer _x) then {
    [_configFile, "AllPlayers", _x] call A3G_Loadout_fnc_DoLoadout;
  };

  // General sides --------------------------------------------------------------------------------
  // All blufor units
  if(isClass (_configFile >> "Blufor") && side _x == blufor) then {
    [_configFile, "Blufor", _x] call A3G_Loadout_fnc_DoLoadout;
  };

  // All opfor units
  if(isClass (_configFile >> "Opfor") && side _x == opfor) then {
    [_configFile, "Opfor", _x] call A3G_Loadout_fnc_DoLoadout;
  };

  // All independent units
  if(isClass (_configFile >> "Independent") && side _x == independent) then {
    [_configFile, "Independent", _x] call A3G_Loadout_fnc_DoLoadout;
  };

  // All civilian units
  if(isClass (_configFile >> "Civilian") && side _x == civilian) then {
    [_configFile, "Civilian", _x] call A3G_Loadout_fnc_DoLoadout;
  };

  // AI sides -------------------------------------------------------------------------------------
  // All blufor AI units
  if(isClass (_configFile >> "BluforAi") && !isPlayer _x && side _x == blufor) then {
    [_configFile, "BluforAi", _x] call A3G_Loadout_fnc_DoLoadout;
  };

  // All opfor AI units
  if(isClass (_configFile >> "OpforAi") && !isPlayer _x && side _x == opfor) then {
    [_configFile, "OpforAi", _x] call A3G_Loadout_fnc_DoLoadout;
  };

  // All independent AI units
  if(isClass (_configFile >> "IndependentAi") && !isPlayer _x && side _x == independent) then {
    [_configFile, "IndependentAi", _x] call A3G_Loadout_fnc_DoLoadout;
  };

  // All civilian AI units
  if(isClass (_configFile >> "CivilianAi") && !isPlayer _x && side _x == civilian) then {
    [_configFile, "CivilianAi", _x] call A3G_Loadout_fnc_DoLoadout;
  };

  // Player sides ---------------------------------------------------------------------------------
  // All blufor units
  if(isClass (_configFile >> "BluforPlayers") && isPlayer _x && side _x == blufor) then {
    [_configFile, "BluforPlayers", _x] call A3G_Loadout_fnc_DoLoadout;
  };

  // All opfor units
  if(isClass (_configFile >> "OpforPlayers") && isPlayer _x && side _x == opfor) then {
    [_configFile, "OpforPlayers", _x] call A3G_Loadout_fnc_DoLoadout;
  };

  // All independent units
  if(isClass (_configFile >> "IndependentPlayers") && isPlayer _x && side _x == independent) then {
    [_configFile, "IndependentPlayers", _x] call A3G_Loadout_fnc_DoLoadout;
  };

  // All civilian units
  if(isClass (_configFile >> "CivilianPlayers") && isPlayer _x && side _x == civilian) then {
    [_configFile, "CivilianPlayers", _x] call A3G_Loadout_fnc_DoLoadout;
  };

  // Class & Unique -------------------------------------------------------------------------------
  // Class based loadouts
  if(isClass (_configFile >> typeof _x)) then {
    [_configFile, typeof _x, _x] call A3G_Loadout_fnc_DoLoadout;
  };

  // Name based loadouts
  if(isClass (_configFile >> str _x)) then {
    [_configFile, str _x, _x] call A3G_Loadout_fnc_DoLoadout;
  };
} forEach _units;