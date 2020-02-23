#include "component.hpp"

#define X_SCALE     (((safezoneW / safezoneH) min 1.2) / 40)
#define Y_SCALE     ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)


params [["_display",displayNull]];

private _tabXRight = safezoneX + safezoneW - 2 * X_SCALE;
private _tabXLeft = safezoneX + 0.5 * X_SCALE;
private _tabW = 1.4 * X_SCALE;
private _tabH = ((1.4 * Y_SCALE) min (safezoneH / 18 / 1.5));

private _loadoutOptionsHash = _display getVariable [QGVAR(loadoutOptionsHash), []];

// shows which tab is currently selected --> is moved on tab selector button click
private _ctrlTabSelectedLeft = _display ctrlCreate ["RscText", -1];
_display setVariable [QGVAR(ctrlTabSelectedLeft), _ctrlTabSelectedLeft];
_ctrlTabSelectedLeft ctrlSetPosition [safeZoneX, -safeZoneH, 0.5 * X_SCALE, 1.4 * Y_SCALE];
_ctrlTabSelectedLeft ctrlSetBackgroundColor [0, 0, 0, 0.8];
_ctrlTabSelectedLeft ctrlCommit 0;

// create right selection indicator
private _ctrlTabSelectedRight = _display ctrlCreate ["RscText", -1];
_display setVariable [QGVAR(ctrlTabSelectedRight), _ctrlTabSelectedRight];
_ctrlTabSelectedRight ctrlSetPosition [_tabXRight + _tabW, -safeZoneH, 0.7 * X_SCALE, 1.4 * Y_SCALE];
_ctrlTabSelectedRight ctrlSetBackgroundColor [0, 0, 0, 0.8];
_ctrlTabSelectedRight ctrlCommit 0;

// create left list
private _ctrlListBoxLeft = _display ctrlCreate ["RscListBox", -1];
_display setVariable [QGVAR(ctrlListBoxLeft), _ctrlListBoxLeft];
_ctrlListBoxLeft ctrlSetPosition [safezoneX + 2.5 * X_SCALE, -safeZoneH, 15 * X_SCALE, 10 * Y_SCALE];
_ctrlListBoxLeft ctrlSetBackgroundColor [0,0,0,1];
_ctrlListBoxLeft ctrlCommit 0;
_ctrlListBoxLeft ctrlAddEventHandler ["lbSelChanged", {_this call FUNC(onCustomGearListSelection)}];

// create right list
private _ctrlListBoxRight = _display ctrlCreate ["RscListBox", -1];
_display setVariable [QGVAR(ctrlListBoxRight), _ctrlListBoxRight];
_ctrlListBoxRight ctrlSetPosition [safezoneX + safezoneW - 17.5 * X_SCALE, -safeZoneH, 15 * X_SCALE, 10 * Y_SCALE];
_ctrlListBoxRight ctrlSetBackgroundColor [0,0,0,1];
_ctrlListBoxRight ctrlSetFade 1;
_ctrlListBoxRight ctrlCommit 0;
_ctrlListBoxRight ctrlAddEventHandler ["lbSelChanged", {_this call FUNC(onCustomGearListSelection)}];

// create tab buttons
private _ctrlFirstActivated = controlNull;
{
    _x params ["_tooltip", "_pic", "_hashKey", ["_subKeys", []]];

    private _tabY = safezoneY + 0.02 + _forEachIndex * 1.5 * (((safezoneH - 0.1) / 18 / 1.5) min (0.04));

    private _ctrlButton = _display ctrlCreate ["RscButtonArsenal", -1];
    _ctrlButton ctrlSetPosition [_tabXLeft, _tabY, _tabW, _tabH];
    _ctrlButton ctrlSetText format ["\A3\Ui_f\data\GUI\Rsc\RscDisplayArsenal\%1", _pic];
    _ctrlButton ctrlCommit 0;
    _ctrlButton setVariable [QGVAR(hashKey), _hashKey];
    _ctrlButton ctrlAddEventHandler ["buttonClick", {[_this#0, true] call FUNC(onCustomGearTabButton)}];

    private _availableOptions = [_loadoutOptionsHash, _hashKey] call CBA_fnc_hashGet;

    // check if weapon categories have accessories available
    private _hasSubOptionsAvailable = false;
    {
        private _availableSubOptions = [_loadoutOptionsHash, _x] call CBA_fnc_hashGet;
        if (_availableSubOptions isEqualType [] && {count _availableSubOptions > 0}) exitWith {
            _hasSubOptionsAvailable = true;
        };
    } forEach _subkeys;

    if ((_availableOptions isEqualType [] && {count _availableOptions > 0}) || _hasSubOptionsAvailable) then {
        _ctrlButton ctrlSetTooltip _tooltip;
        if (isNull _ctrlFirstActivated) then {
            _ctrlFirstActivated = _ctrlButton;
        };
    } else {
        _ctrlButton ctrlEnable false;
        _ctrlButton ctrlSetTooltip format ["%1 unavailable", _tooltip];
        _ctrlButton ctrlSetFade 0.5;
        _ctrlButton ctrlCommit 0;
    };

} forEach [
    ["Rifle", "PrimaryWeapon_ca.paa", "primaryWeapon", ["primaryWeaponOptics", "primaryWeaponMuzzle", "primaryWeaponPointer", "primaryWeaponUnderbarrel"]],
    ["Launcher", "SecondaryWeapon_ca.paa", "secondaryWeapon", ["secondaryWeaponOptics", "secondaryWeaponMuzzle", "secondaryWeaponPointer", "secondaryWeaponUnderbarrel"]],
    ["Handgun", "Handgun_ca.paa", "handgunWeapon", ["handgunWeaponOptics", "handgunWeaponMuzzle", "handgunWeaponPointer", "handgunWeaponUnderbarrel"]],
    ["Uniform", "Uniform_ca.paa", "uniform"],
    ["Vest", "Vest_ca.paa", "vest"],
    ["Backpack", "Backpack_ca.paa", "backpack"],
    ["Headgear", "Headgear_ca.paa", "headgear"],
    ["Facewear", "Goggles_ca.paa", "goggles"],
    ["Nightvision", "NVGs_ca.paa", "nvgoggles"],
    ["Binoculars", "Binoculars_ca.paa", "binoculars"],
    ["Map", "Map_ca.paa", "map"],
    ["GPS", "GPS_ca.paa", "gps"],
    ["Radio", "Radio_ca.paa", "radio"],
    ["Compass", "Compass_ca.paa", "compass"],
    ["Watch", "Watch_ca.paa", "watch"]
];

_display setVariable [QGVAR(attachmentButtons), []];
private _attachmentButtons = _display getVariable [QGVAR(attachmentButtons), []];
{
    _x params ["_tooltip", "_pic"];

    private _tabY = safezoneY + 0.02 + _forEachIndex * 1.5 * (((safezoneH - 0.1) / 18 / 1.5) min (0.04));

    private _ctrlButton = _display ctrlCreate ["RscButtonArsenal", -1];
    _ctrlButton ctrlSetPosition [_tabXRight, _tabY, _tabW, _tabH];
    _ctrlButton ctrlSetText format ["\A3\Ui_f\data\GUI\Rsc\RscDisplayArsenal\%1", _pic];
    _ctrlButton ctrlAddEventHandler ["buttonClick", {[_this#0, false] call FUNC(onCustomGearTabButton)}];
    _ctrlButton ctrlSetTooltip _tooltip;
    _ctrlButton ctrlEnable false;
    _ctrlButton ctrlSetFade 1;
    _ctrlButton ctrlCommit 0;
    _ctrlButton setVariable [QGVAR(tooltip), _tooltip];

    _attachmentButtons set [_forEachIndex, _ctrlButton];

} forEach [
    ["Optics", "ItemOptic_ca.paa"],
    ["Rail Attachment", "ItemAcc_ca.paa"],
    ["Muzzle Attachment", "ItemMuzzle_ca.paa"],
    ["Underbarrel Attachment", "ItemBipod_ca.paa"]
];

// activate first button on left side last, so right side is already loaded
[_ctrlFirstActivated, true] call FUNC(onCustomGearTabButton);
