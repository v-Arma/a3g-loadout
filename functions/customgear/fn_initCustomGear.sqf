#include "component.hpp"

private _enabled = [missionConfigFile >> "Loadouts", "customGear", 300] call BIS_fnc_returnConfigEntry;
if (_enabled isEqualType 0 && {_enabled <= 0}) exitWith {};

if (!(_enabled isEqualType 0) && !(_enabled isEqualType "")) exitWith {
    ERROR_1("[missionConfigFile >> Loadouts >> customGear] is of type %1 - only number or string allowed.", typeName _enabled);
};

if !(isClass (configfile >> "CfgPatches" >> "ace_interact_menu")) exitWith {
    ERROR("customGear needs ace_interact_menu addon.");
};

// get allowed categories from config
GVAR(customGearAllowedCategories) = [missionConfigFile >> "Loadouts", "customGearAllowedCategories", [CUSTOMGEAR_SUPPORTED_KEYS]] call BIS_fnc_returnConfigEntry;

// user supplied number for custom gear timeout
GVAR(customGearCondition) = if (_enabled isEqualType 0) then {
    GVAR(customGearTimeout) = _enabled;
    {
        params ["_unit"];
        (CBA_missionTime - (_unit getVariable [QGVAR(lastLoadoutApplicationTime), 0])) < GVAR(customGearTimeout) &&
        {(_unit getVariable [QGVAR(applicationCount), 0]) > 0}
    }

// user supplied string for custom gear condition
} else {
    compile _enabled
};

[QGVAR(loadoutApplied), {
    params [["_unit", objNull]];

    if (_unit != ACE_player) exitWith {};

    // cache loadout options for interaction condition check
    private _configPath = missionConfigFile >> "Loadouts";
    if ((missionNamespace getVariable [QGVAR(Chosen_Prefix), ""]) != "") then {
        _configPath = _configPath >> GVAR(Chosen_Prefix);
    };
    private _loadoutHash = [_unit, _configPath] call FUNC(GetUnitLoadoutFromConfig);
    private _customGearOptionsHash = [_unit, _loadoutHash, true] call FUNC(getCustomGearOptions);
    _unit setVariable [QGVAR(customGearOptionsCache), _customGearOptionsHash];

    // notification the first time customization becomes available after loadout application
    if (count ([_customGearOptionsHash] call CBA_fnc_hashKeys) > 0) then {
        [{(missionNamespace getVariable ["CBA_missionTime", 0]) > 10 && {[_this] call GVAR(customGearCondition)}}, {
            if (isClass (configfile >> "CfgNotifications" >> "GRAD_saveMarkers_notification")) then {
                ["GRAD_saveMarkers_notification", ["GRAD CUSTOM GEAR", "Loadout customization now available. (Selfinteract >> Equipment)"]] call BIS_fnc_showNotification;
            } else {
                ["TaskUpdated", ["", "Loadout customization now available. (Selfinteract >> Equipment)"]] call BIS_fnc_showNotification;
            };
        },_unit] call CBA_fnc_waitUntilAndExecute;
    };
}] call CBA_fnc_addEventHandler;

// add interaction
private _action = [
    QGVAR(customGearAction),
    "Customize loadout",
    "\A3\Ui_f\data\GUI\Rsc\RscDisplayArsenal\uniform_ca.paa",
    {
        [{_this call FUNC(openCustomGearDialog)}, _this] call CBA_fnc_execNextFrame
    },
    {
        params ["_unit"];
        !visibleMap &&
        {[_unit] call GVAR(customGearCondition)} &&
        {
            private _customGearOptionsHash = _unit getVariable QGVAR(customGearOptionsCache);
            if (isNil "_customGearOptionsHash") then {
                private _configPath = missionConfigFile >> "Loadouts";
                if (GVAR(Chosen_Prefix) != "") then {
                    _configPath = _configPath >> GVAR(Chosen_Prefix);
                };
                private _loadoutHash = [_unit, _configPath] call FUNC(GetUnitLoadoutFromConfig);
                private _customGearOptionsHash = [_unit, _loadoutHash] call FUNC(getCustomGearOptions);
            };
            count ([_customGearOptionsHash] call CBA_fnc_hashKeys) > 0
        }
    }
] call ace_interact_menu_fnc_createAction;
["CAManBase", 1, ["ACE_SelfActions", "ACE_Equipment"], _action, true] call ace_interact_menu_fnc_addActionToClass;
