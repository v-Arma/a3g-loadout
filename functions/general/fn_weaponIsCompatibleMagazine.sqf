private _weaponClassName = param [0];
private _magazineClassName = param[1];

private _compatibleMagazines = (configFile >> "CfgWeapons" >> _weaponClassName >> "magazines") call BIS_fnc_getCfgData;

(_magazineClassName in _compatibleMagazines)
