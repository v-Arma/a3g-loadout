params ["_isMissionStart"];

// Make sure that only local player is considered as target on respawn.
// This is because AI don't respawn, and we especially don't want to have local AI go through an entire loadout loop again, everytime the player respawns that the AI belongs to.


private _units = [];
if( !_isMissionStart ) then {
	_units pushBack player;
} else {
	{
		if ( local _x ) then {
			_units pushBack _x;
		};
	} forEach allUnits;
};

_units
