#include "component.hpp"

params ["_button", "_isLeftSide"];

private _display = ctrlParent _button;
private _unit = _display getVariable [QGVAR(unit), objNull];

// move selection indicator to selected tab
private _ctrlTabSelected = _display getVariable [[QGVAR(ctrlTabSelectedRight), QGVAR(ctrlTabSelectedLeft)] select _isLeftSide, controlNull];
private _ctrlTabSelectedPosition = ctrlPosition _ctrlTabSelected;
_ctrlTabSelectedPosition set [1, (ctrlPosition _button) select 1];
_ctrlTabSelected ctrlSetPosition _ctrlTabSelectedPosition;
_ctrlTabSelected ctrlSetFade 0;
_ctrlTabSelected ctrlCommit 0;

// get available options for selected category
private _hashKey = _button getVariable [QGVAR(hashKey), ""];
private _loadoutOptionsHash = _display getVariable [QGVAR(loadoutOptionsHash), []];
private _availableOptions = if !([_loadoutOptionsHash] call CBA_fnc_isHash) then {
    ERROR("_loadoutOptionsHash got lost along the way and is no longer a hash.");
    []
} else {
    [_loadoutOptionsHash, _hashKey] call CBA_fnc_hashGet
};

// fill listbox with available options
// check if _availableOptions is type array, because default return for hash is *false*
if (_availableOptions isEqualType []) then {
    private _ctrlListBox = _display getVariable [[QGVAR(ctrlListBoxRight), QGVAR(ctrlListBoxLeft)] select _isLeftSide, controlNull];
    _ctrlListBox setVariable [QGVAR(hashKey), _hashKey];
    lbClear _ctrlListBox;
    private _ctrlListBoxPosition = ctrlPosition _ctrlListBox;
    _ctrlListBoxPosition set [1, [-safeZoneH, (ctrlPosition _button) select 1] select (count _availableOptions > 0)];
    _ctrlListBox ctrlSetPosition _ctrlListBoxPosition;
    _ctrlListBox ctrlSetFade 0;
    _ctrlListBox ctrlCommit 0;
    {
        private _itemClassname = _x;
        private _displayName = "";
        private _parentClass = "";

        if (_itemClassname == "") then {
            _displayName = "empty";
        } else {
            {
                if (isClass (configFile >> _x >> _itemClassname)) exitWith {_parentClass = _x};
            } forEach ["CfgWeapons", "CfgMagazines", "CfgVehicles", "CfgGlasses"];
            _displayName = [configFile >> _parentClass >> _itemClassname, "displayName", "ERROR: NO DISPLAY NAME"] call BIS_fnc_returnConfigEntry;
        };

        private _pic = [configFile >> _parentClass >> _itemClassname, "picture", ""] call BIS_fnc_returnConfigEntry;

        private _lbIndex = _ctrlListBox lbAdd _displayName;
        _ctrlListBox lbSetData [_lbIndex, _itemClassname];
        _ctrlListBox lbSetPicture [_lbIndex, _pic];

        if (
            (toLower _itemClassname) == (toLower ([_unit, _hashKey, true] call FUNC(getCurrentItem)))
        ) then {
            _ctrlListBox lbSetCurSel _lbIndex;
        };
    } forEach _availableOptions;
};

//update camera
[_unit, _hashKey] call FUNC(updateCamera);

if (_isLeftSide) then {

    private _weaponID = ["primaryWeapon", "secondaryWeapon", "handgunWeapon"] find _hashKey;
    private _attachmentButtons = _display getVariable [QGVAR(attachmentButtons), []];

    // hide right side selection indicator
    private _ctrlTabSelectedRight = _display getVariable [QGVAR(ctrlTabSelectedRight), controlNull];
    _ctrlTabSelectedRight ctrlSetFade 1;
    _ctrlTabSelectedRight ctrlCommit 0;

    // hide right side listbox
    private _ctrlListBoxRight = _display getVariable [QGVAR(ctrlListBoxRight), controlNull];
    _ctrlListBoxRight ctrlSetFade 1;
    _ctrlListBoxRight ctrlCommit 0;

    // activate right side tabs and listbox, if weapon has been selected
    if (_weaponID >= 0) then {
        private _hashKeyArray = [
            ["primaryWeaponOptics", "primaryWeaponPointer", "primaryWeaponMuzzle", "primaryWeaponUnderbarrel"],
            ["secondaryWeaponMuzzle", "secondaryWeaponOptics", "secondaryWeaponPointer", "secondaryWeaponUnderbarrel"],
            ["handgunWeaponMuzzle", "handgunWeaponOptics", "handgunWeaponPointer", "handgunWeaponUnderbarrel"]
        ] select _weaponID;

        private _firstActivated = false;
        {
            private _ctrlButton = _x;
            private _tooltip = _ctrlButton getVariable [QGVAR(tooltip), ""];

            _hashKey = _hashKeyArray select _forEachIndex;
            _ctrlButton setVariable [QGVAR(hashKey), _hashKey];
            _availableOptions = [_loadoutOptionsHash, _hashKey] call CBA_fnc_hashGet;

            if !(_availableOptions isEqualType [] && {count _availableOptions > 0}) then {
                _ctrlButton ctrlEnable false;
                _ctrlButton ctrlSetTooltip format ["%1 unavailable", _tooltip];
                _ctrlButton ctrlSetFade 0.5;
                _ctrlButton ctrlCommit 0;
            } else {
                _ctrlButton ctrlSetTooltip _tooltip;
                _x ctrlEnable true;
                _x ctrlSetFade 0;
                _x ctrlCommit 0;
                if (!_firstActivated) then {
                    [_x, false] call FUNC(onCustomGearTabButton);
                    _firstActivated = true;
                };
            };

        } forEach _attachmentButtons;

    // otherwise hide right side
    } else {
        {
            _x ctrlEnable false;
            _x ctrlSetFade 1;
            _x ctrlCommit 0;
        } forEach _attachmentButtons;

        _ctrlTabSelected ctrlSetFade 1;
        _ctrlTabSelected ctrlCommit 0;
    };
};
