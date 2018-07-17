#define PREFIX grad
#define COMPONENT loadout
#include "\x\cba\addons\main\script_macros_mission.hpp"


// DIALOG DEFINES ==============================================================
#define SZ_SCALE    (safezoneW min safezoneH)
#define X_SCALE     (SZ_SCALE * 0.75)
#define Y_SCALE     (SZ_SCALE * 1.0)

#define PADDING_X   (0.025 * X_SCALE)
#define PADDING_Y   (0.025 * Y_SCALE)

#define CONTENT_Y   (safeZoneY + PADDING_Y)
#define CONTENT_X   (safeZoneX + PADDING_X)

#define TREE_X      (safeZoneX + PADDING_X)
#define TREE_Y      (safeZoneY + PADDING_Y)
#define TREE_W      (0.500 * X_SCALE)
#define TREE_H      (safeZoneH - 2 * PADDING_Y)


// CREATE DIALOG ===============================================================
private _display = (findDisplay 46) createDisplay "RscDisplayEmpty";
if (isNull _display) exitWith {systemChat "[GRAD] (loadout) ERROR: Display is null."};


private _bgCtrl = _display ctrlCreate ["RscBackground",-1];
_bgCtrl ctrlSetPosition [safeZoneX,safeZoneY,safeZoneW,safeZoneH];
_bgCtrl ctrlSetBackgroundColor [0.1,0.1,0.1,1];
_bgCtrl ctrlCommit 0;


private _tvCtrl = _display ctrlCreate ["RscTree",-1];
_tvCtrl ctrlSetPosition [CONTENT_X,CONTENT_Y,TREE_W,TREE_H];
_tvCtrl ctrlCommit 0;


// FILL DIALOG =================================================================
private _sides = _this;
if (count _sides == 0) then {_sides = [WEST,EAST,INDEPENDENT,CIVILIAN]};

private _unitsCache = [];
{
    _sideUnitsCache = _unitsCache select (_unitsCache pushBack []);
    _side = _x;
    _sideGroups = allGroups select {side _x == _side};
    _sidePath = [_tvCtrl tvAdd [[],str _side]];
    {
        _groupUnitsCache = _sideUnitsCache select (_sideUnitsCache pushBack []);
        _groupPath = _sidePath + [_tvCtrl tvAdd [_sidePath,str _x]];
        {
            _unit = _x;

            _groupUnitsCache pushBack _unit;
            _unitDisplayName = roleDescription _unit;
            if (_unitDisplayName == "") then {
                _unitDisplayName = [configfile >> "CfgVehicles" >> typeOf _unit,"displayName","ERROR: NO DISPLAYNAME"] call BIS_fnc_returnConfigEntry;
            };
            _unitPath = _groupPath + [_tvCtrl tvAdd [_groupPath,_unitDisplayName]];
            _tvCtrl tvSetTooltip [_unitPath,typeOf _unit];

            {
                _sanitizedX = _x select {_x != ""};
                _containerClassName = [QGVAR(STR_ASSIGNED_ITEMS),uniform _unit,vest _unit,backpack _unit,primaryWeapon _unit,secondaryWeapon _unit,handgunWeapon _unit] select _forEachIndex;
                _config = ["CfgWeapons","CfgVehicles"] select (_forEachIndex in [0,3]);
                _containerDisplayName = [configfile >> _config >> _containerClassName,"displayName",["ERROR: NO DISPLAYNAME","Assigned Items"] select (_forEachIndex == 0)] call BIS_fnc_returnConfigEntry;

                if (_containerClassName != "") then {
                    _containerPath = _unitPath + [_tvCtrl tvAdd [_unitPath,_containerDisplayName]];
                    _tvCtrl tvSetTooltip [_containerPath,_containerClassName];
                    _tvCtrl tvSetData [_containerPath,_containerClassName];
                };
            } forEach [assignedItems _unit,uniformItems _unit,vestItems _unit,backpackItems _unit,primaryWeaponItems _unit,secondaryWeaponItems _unit,handgunItems _unit];

        } forEach (units _x);
    } forEach _sideGroups;
} forEach _sides;

_display setVariable [QGVAR(unitsCache),_unitsCache];


// DIALOG FUNCTIONALITY ========================================================
_tvCtrl ctrlAddEventHandler ["treeSelChanged",{
    params ["_tvCtrl","_selPath"];
    _selPath params [["_sideIndex",999999],["_groupIndex",999999],["_unitIndex",999999],["_containerIndex",999999],["_itemIndex",999999]];

    _display = ctrlParent _tvCtrl;

    switch (count _selPath) do {

        // unit selected
        case (3): {
            _unitsCache = _display getVariable [QGVAR(unitsCache),[]];
            _unit = _unitsCache select _sideIndex select _groupIndex select _unitIndex;
        };
    };
}];
