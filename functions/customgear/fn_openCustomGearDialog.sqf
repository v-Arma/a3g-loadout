#include "component.hpp"

params ["",["_unit", objNull]];

// save currently selected weapon for camera, because unit will re-select primary on every setUnitLoadout without actually switching to it
GVAR(curSelectedWeaponID) = -1;
private _curWeapon = currentWeapon _unit;
{
    if (_curWeapon == _x) exitWith {
        GVAR(curSelectedWeaponID) = _foreachindex;
    };
} forEach [
    primaryWeapon _unit,
    secondaryWeapon _unit,
    handgunWeapon _unit
];

disableSerialization;

// create camera
if !(isNull (missionNamespace getVariable [QGVAR(customGearCam), objNull])) exitWith {};
GVAR(customGearCam) = "camera" camcreate (getPos _unit);
GVAR(customGearCam) cameraeffect ["External", "back"];
showCinemaBorder false;
[_unit, "uniform", 0] call FUNC(updateCamera);

// get gear options
private _configPath = missionConfigFile >> "Loadouts";
if (GVAR(Chosen_Prefix) != "") then {
    _configPath = _configPath >> GVAR(Chosen_Prefix);
};
private _loadoutHash = [_unit, _configPath] call FUNC(GetUnitLoadoutFromConfig);
private _loadoutOptionsHash = [_unit, _loadoutHash] call FUNC(getCustomGearOptions);

// create dialog
private _display = (findDisplay 46) createDisplay "RscDisplayEmpty";
uiNamespace setVariable [QGVAR(customGearDisplay), _display];
_display setVariable [QGVAR(loadoutOptionsHash), _loadoutOptionsHash];
_display setVariable [QGVAR(unit), _unit];

_display displayAddEventHandler ["unload", {_this call FUNC(onCustomGearUnload)}];

[_display] call FUNC(createCustomGearDialog);
