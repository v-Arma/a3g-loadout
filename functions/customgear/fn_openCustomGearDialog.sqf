#define PREFIX grad
#define COMPONENT loadout
#include "\x\cba\addons\main\script_macros_mission.hpp"

params [["_unit", objNull]];

disableSerialization;

// create camera
if !(isNull (missionNamespace getVariable [QGVAR(customGearCam), objNull])) exitWith {};
GVAR(customGearCam) = "camera" camcreate (getPos _unit);
GVAR(customGearCam) cameraeffect ["External", "back"];
showCinemaBorder false;
GVAR(customGearCam) camSetTarget _unit;
GVAR(customGearCam) camSetRelPos [0, 3, 2];
GVAR(customGearCam) camCommit 0;

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

_display displayAddEventHandler ["unload" ,{
    GVAR(customGearCam) cameraeffect ["terminate", "back"];
    camDestroy GVAR(customGearCam);
    GVAR(customGearCam) = nil;
}];

[_display] call FUNC(createCustomGearDialog);
