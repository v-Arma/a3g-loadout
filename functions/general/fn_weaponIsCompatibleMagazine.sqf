_weaponClassName = param [0];
_magazineClassName = param[1];

_compatibleMagazines = (configFile >> "CfgWeapons" >> _weaponClassName >> "magazines") call BIS_fnc_getCfgData;

(_magazineClassName in _compatibleMagazines)
