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
  // General
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

  // Sides
  // All blufor units
  if(isClass (_configFile >> "AllBlufor") && side _x == blufor) then {
    [_configFile, "AllBlufor", _x] call A3G_Loadout_fnc_DoLoadout;
  };

  // All opfor units
  if(isClass (_configFile >> "AllOpfor") && side _x == opfor) then {
    [_configFile, "AllOpfor", _x] call A3G_Loadout_fnc_DoLoadout;
  };

  // All independent units
  if(isClass (_configFile >> "AllIndependent") && side _x == independent) then {
    [_configFile, "AllIndependent", _x] call A3G_Loadout_fnc_DoLoadout;
  };

  // All civilian units
  if(isClass (_configFile >> "AllCivilians") && side _x == civilian) then {
    [_configFile, "AllCivilians", _x] call A3G_Loadout_fnc_DoLoadout;
  };

  // Class & Unique
  // Class based loadouts
  if(isClass (_configFile >> typeof _x)) then {
    [_configFile, typeof _x, _x] call A3G_Loadout_fnc_DoLoadout;
  };

  // Name based loadouts
  if(isClass (_configFile >> str _x)) then {
    [_configFile, str _x, _x] call A3G_Loadout_fnc_DoLoadout;
  };
} forEach _units;