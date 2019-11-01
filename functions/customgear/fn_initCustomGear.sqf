#define PREFIX grad
#define COMPONENT loadout
#include "\x\cba\addons\main\script_macros_mission.hpp"


private _enabled = [missionConfigFile >> "Loadouts", "customGear", 300] call BIS_fnc_returnConfigEntry;
if (_enabled isEqualType 0 && {_enabled <= 0}) exitWith {};

if (!(_enabled isEqualType 0) && !(_enabled isEqualType "")) exitWith {
    ERROR_1("[missionConfigFile >> Loadouts >> customGear] is of type %1 - only number or string allowed.", typeName _enabled);
};

if !(isClass (configfile >> "CfgPatches" >> "ace_interact_menu")) exitWith {
    ERROR("customGear needs ace_interact_menu addon.");
};

// user supplied number for custom gear timeout
GVAR(customGearCondition) = if (_enabled isEqualType 0) then {
    GVAR(customGearTimeout) = _enabled;
    {
        params ["_unit"];
        (CBA_missionTime - (_unit getVariable [QGVAR(lastLoadoutApplicationTime), 0])) < GVAR(customGearTimeout)
    }

// user supplied string for custom gear condition
} else {
    compile _enabled
};

// notification the first time customization becomes available after loadout application
[QGVAR(loadoutApplied), {
    params [["_unit", objNull]];

    if (_unit != ACE_player) exitWith {};

    [{(missionNamespace getVariable ["CBA_missionTime",0]) > 10 && {[_this] call GVAR(customGearCondition)}}, {
        if (isClass (configfile >> "CfgNotifications" >> "GRAD_saveMarkers_notification")) then {
            ["GRAD_saveMarkers_notification",["GRAD CUSTOM GEAR","Loadout customization now available. (Selfinteract >> Equipment)"]] call BIS_fnc_showNotification;
        } else {
            ["TaskUpdated",["","Loadout customization now available. (Selfinteract >> Equipment)"]] call BIS_fnc_showNotification;
        };
    },_unit] call CBA_fnc_waitUntilAndExecute;
}] call CBA_fnc_addEventHandler;

// add interaction
private _action = [QGVAR(customGearAction), "Customize loadout", "", {[{_this call FUNC(openCustomGearDialog)}, _this] call CBA_fnc_execNextFrame}, GVAR(customGearCondition)] call ace_interact_menu_fnc_createAction;
["CAManBase", 1, ["ACE_SelfActions", "ACE_Equipment"], _action, true] call ace_interact_menu_fnc_addActionToClass;
