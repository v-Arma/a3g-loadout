// ========================================== Checks ==============================================
// Make sure only clients run this script
if (isDedicated) exitWith {};

_configFile = missionConfigFile >> "CfgLoadouts";

_hasGeneric = false;
_hasClass = false;
_hasSnowflake = false;

// Find out if the player has a generic set up.
if(isClass (_configFile >> "Everyone")) then {
	_hasGeneric = true;
};

// Find out if player has a class loadout set up.
if(isClass (_configFile >> (typeof player))) then {
	_hasClass = true;
};

// Find out if player has a unique loadout set up.
if(isClass (_configFile >> (str player))) then {
	_hasSnowflake = true;
};

// Run the loadout multiple times, with descending priority
while { _hasGeneric || _hasClass || _hasSnowflake } do {
	if(_hasGeneric) then {
		[_configFile, "Everyone"] call A3G_Loadout_fnc_doLoadout;
		_hasGeneric = false;
	} else {
		if(_hasClass) then {
			[_configFile, (typeof player)] call A3G_Loadout_fnc_doLoadout;
			_hasClass = false;
		} else {
			if(_hasSnowflake) then {
				[_configFile, (str player)] call A3G_Loadout_fnc_doLoadout;
				_hasSnowflake = false;
			};
		};
	};
};