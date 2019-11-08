#include "component.hpp"

params ["_weaponClassName", "_magazineClassName"];

private _compatibleMagazines = (configFile >> "CfgWeapons" >> _weaponClassName >> "magazines") call BIS_fnc_getCfgData;

(_magazineClassName in _compatibleMagazines)
