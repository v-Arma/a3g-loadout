// Get config entry
_configPath = _this select 0;

removeAllAssignedItems player;
removeHeadgear player;

{
	// Workaround since linkedItems contains other items than the vest. isKindOf makes sure only the vest is applied.
	// Items other than a vest will still remove the vest item from the player as per addVest specification.
	_class = [_x] call BIS_fnc_classWeapon;
	_parents = [_class, true] call BIS_fnc_returnParents;
	if("Vest_Camo_Base" in _parents || "Vest_NoCamo_Base" in _parents) then {
		player addVest _x;
	} else {
		player linkItem _x;
	};
} forEach getArray (_configPath);