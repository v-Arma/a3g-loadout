#include "component.hpp"

params [["_obj", objNull], ["_condition", {true}], ["_actionPath", ["ACE_MainActions"]]];

private _action = [
    QGVAR(customGearAction),
    "Customize loadout",
    "\A3\Ui_f\data\GUI\Rsc\RscDisplayArsenal\uniform_ca.paa",
    {[{_this call FUNC(openCustomGearDialog)}, _this] call CBA_fnc_execNextFrame},
    _condition
] call ace_interact_menu_fnc_createAction;
[_obj, 0, _actionPath, _action] call ace_interact_menu_fnc_addActionToObject;
