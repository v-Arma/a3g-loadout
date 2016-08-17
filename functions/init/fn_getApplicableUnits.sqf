params ["_isMissionStart"];
private ["_units"];

_units = [];
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
