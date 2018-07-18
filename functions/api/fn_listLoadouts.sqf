#define PREFIX grad
#define COMPONENT loadout
#include "\x\cba\addons\main\script_macros_mission.hpp"


// DIALOG DEFINES ==============================================================
#define SZ_SCALE            (safezoneW min safezoneH)
#define X_SCALE             (SZ_SCALE * 0.75)
#define Y_SCALE             (SZ_SCALE * 1.0)

#define PADDING_X           (0.025 * X_SCALE)
#define PADDING_Y           (0.025 * Y_SCALE)


#define CAMERA_W            (0.75 * X_SCALE)
#define COLUMN_Y            (safeZoneY + PADDING_Y)
#define COLUMN_W            ((safeZoneW - 4 * PADDING_X - CAMERA_W) / 2)
#define CAMERA_X            (safeZoneX + 2 * PADDING_X + COLUMN_W)
#define COLUMN_H            (safeZoneH - 2 * PADDING_Y)

#define COLUMN1_X           (safeZoneX + PADDING_X)
#define COLUMN2_X           (safeZoneX + safeZoneW - PADDING_X - COLUMN_W)

// OTHER DEFINES ===============================================================
#define DEFAULT_CAMPROPS    [7,45,20,[0,0,0.9],objNull]


// SUBFUNCTIONS ================================================================
private _fnc_getParentClass = {
    params ["_thisItemClassname"];
    private _parentClass = "";
    {
        if (isClass (configFile >> _x >> _thisItemClassname)) exitWith {_parentClass = _x};
        false
    } count ["CfgWeapons","CfgMagazines","CfgVehicles"];
    _parentClass
};

private _fnc_addSide = {
    params ["_side"];

    _sideUnitsCache = _unitsCache select (_unitsCache pushBack []);
    _sideGroups = allGroups select {side _x == _side};
    _sidePath = [_tvCtrl tvAdd [[],str _side]];
    {[_sidePath,_x] call _fnc_addGroup} forEach _sideGroups;
};

private _fnc_addGroup = {
    params ["_sidePath","_group"];

    _groupUnitsCache = _sideUnitsCache select (_sideUnitsCache pushBack []);
    _groupPath = _sidePath + [_tvCtrl tvAdd [_sidePath,str _group]];
    {[_groupPath,_x] call _fnc_addUnit} forEach (units _group);
};

private _fnc_addUnit = {
    params ["_groupPath","_unit"];

    _groupUnitsCache pushBack _unit;
    _unitDisplayName = roleDescription _unit;
    if (_unitDisplayName == "") then {
        _unitDisplayName = [configfile >> "CfgVehicles" >> typeOf _unit,"displayName","ERROR: NO DISPLAYNAME"] call BIS_fnc_returnConfigEntry;
    };
    _unitPath = _groupPath + [_tvCtrl tvAdd [_groupPath,_unitDisplayName]];
    _tvCtrl tvSetTooltip [_unitPath,typeOf _unit];

    {
        [_unitPath,_x,_forEachIndex] call _fnc_addItem;
    } forEach [assignedItems _unit,uniformItems _unit,vestItems _unit,backpackItems _unit,primaryWeaponItems _unit,secondaryWeaponItems _unit,handgunItems _unit];
};

private _fnc_addItem = {
    params ["_unitPath","_itemsList","_containerType"];

    _sanitizedItemsList = _itemsList select {_x != ""};
    _uniqueItemsList = _sanitizedItemsList arrayIntersect _sanitizedItemsList;
    _containerClassName = [QGVAR(STR_ASSIGNED_ITEMS),uniform _unit,vest _unit,backpack _unit,primaryWeapon _unit,secondaryWeapon _unit,handgunWeapon _unit] select _containerType;
    _containerDisplayName = [[configFile >> [_containerClassName] call _fnc_getParentClass >> _containerClassName,"displayName","ERROR: NO DISPLAY NAME"] call BIS_fnc_returnConfigEntry,"Assigned Items"] select (_containerType == 0);

    if (_containerClassName != "") then {
        _containerPath = _unitPath + [_tvCtrl tvAdd [_unitPath,_containerDisplayName]];
        _tvCtrl tvSetTooltip [_containerPath,_containerClassName];
        _tvCtrl tvSetData [_containerPath,_containerClassName];

        {
            _itemClassname = _x;
            _itemCount = {_x == _itemClassname} count _sanitizedItemsList;
            _itemParentClass = [_itemClassname] call _fnc_getParentClass;
            _itemPic = [_itemClassname,_itemParentClass] call _fnc_getItemPic;

            _itemPath = _containerPath + [_tvCtrl tvAdd [_containerPath,format ["%1x %2",_itemCount,[configFile >> _itemParentClass >> _itemClassname,"displayName","ERROR: NO DISPLAY NAME"] call BIS_fnc_returnConfigEntry]]];
            _tvCtrl tvSetTooltip [_itemPath,_itemClassname];
            _tvCtrl tvSetValue [_itemPath,_itemCount];
            _tvCtrl tvSetData [_itemPath,_itemClassname];
            _tvCtrl tvSetPicture [_itemPath,[configFile >> _itemParentClass >> _itemClassname,"picture",""] call BIS_fnc_returnConfigEntry];
        } forEach _uniqueItemsList;
    };
};

private _fnc_updateCamera = {
    params [["_display",displayNull]];

    if (isNull _display) exitWith {};

    _cam = _display getVariable [QGVAR(cam),objNull];
    _camProperties = _display getVariable [QGVAR(camProperties),DEFAULT_CAMPROPS];
    _camProperties params ["_dis","_dirH","_dirV","_targetHelperOffset",["_targetUnit",objNull]];

    _targetHelper = _targetUnit getVariable [QGVAR(targetHelper),objNull];
    if (isNull _targetHelper) exitWith {ERROR("_targetHelper is null")};

    [_targetHelper,[_dirH + 180,-_dirV,0]] call bis_fnc_setobjectrotation;
    _targetHelper attachto [_targetUnit,_targetHelperOffset,""];

    diag_log ["_targetHelper",_targetHelper];
    _cam setpos (_targetHelper modeltoworld [0,-_dis,0]);
    _cam setvectordirandup [vectordir _targetHelper,vectorup _targetHelper];

    //--- Make sure the camera is not underground
    if ((getposasl _cam select 2) < (getposasl _cam select 2)) then {
        _disCoef = ((getposasl _targetHelper select 2) - (getposasl _cam select 2)) / ((getposasl _targetHelper select 2) - (getposasl _cam select 2) + 0.001);
        _cam setpos (_targetHelper modeltoworldvisual [0,-_dis * _disCoef,0]);
    };

    _cam camCommit 0;
};


// CREATE DIALOG ===============================================================
private _display = (findDisplay 46) createDisplay "RscDisplayEmpty";
if (isNull _display) exitWith {systemChat "[GRAD] (loadout) ERROR: Display is null."};

_display setVariable [QGVAR(fnc_updateCamera),_fnc_updateCamera];

{
    _bgCtrl = _display ctrlCreate ["RscBackground",-1];
    _bgCtrl ctrlSetPosition _x;
    _bgCtrl ctrlSetBackgroundColor [0.1,0.1,0.1,1];
    _bgCtrl ctrlCommit 0;
} forEach [
    [safeZoneX,safeZoneY,safeZoneW,PADDING_Y],
    [safeZoneX,safeZoneY + safeZoneH - PADDING_Y,safeZoneW,PADDING_Y],
    [safeZoneX,safeZoneY + PADDING_Y,2 * PADDING_X + COLUMN_W,safeZoneH - 2 * PADDING_Y],
    [safeZoneX + safeZoneW - 2 * PADDING_X - COLUMN_W,safeZoneY + PADDING_Y,2 * PADDING_X + COLUMN_W,safeZoneH - 2 * PADDING_Y]
];

private _camInteractionCtrl = _display ctrlCreate ["RscTextMulti",-1];
_camInteractionCtrl ctrlSetPosition [CAMERA_X,COLUMN_Y,CAMERA_W,COLUMN_H];
_camInteractionCtrl ctrlSetBackgroundColor [0,0,0,0];
_camInteractionCtrl ctrlCommit 0;

private _tvCtrl = _display ctrlCreate ["RscTree",-1];
_tvCtrl ctrlSetPosition [COLUMN1_X,COLUMN_Y,COLUMN_W,COLUMN_H];
_tvCtrl ctrlCommit 0;



// CREATE CAMERA ===============================================================
private _cam = "camera" camcreate (getPos player);
_cam cameraeffect ["External","back"];

showCinemaBorder false;
if (sunOrMoon < 0.35) then {camUseNVG true};

_display setVariable [QGVAR(camProperties),DEFAULT_CAMPROPS];
_display setVariable [QGVAR(cam),_cam];


// FILL DIALOG =================================================================
private _sides = _this;
if (count _sides == 0) then {_sides = [WEST,EAST,INDEPENDENT,CIVILIAN]};

private _unitsCache = [];
{
    [_x] call _fnc_addSide;
} forEach _sides;

_display setVariable [QGVAR(unitsCache),_unitsCache];


// DIALOG FUNCTIONALITY ========================================================
_tvCtrl ctrlAddEventHandler ["treeSelChanged",{
    params ["_tvCtrl","_selPath"];
    _selPath params [["_sideIndex",999999],["_groupIndex",999999],["_unitIndex",999999],["_containerIndex",999999],["_itemIndex",999999]];

    _display = ctrlParent _tvCtrl;

    _unitsCache = _display getVariable [QGVAR(unitsCache),[]];

    _unit = if (count _selPath > 1) then {
        if (count _selPath > 2) then {
            _unitsCache select _sideIndex select _groupIndex select _unitIndex
        } else {
            leader (_unitsCache select _sideIndex select _groupIndex select 0)
        };
    } else {objNull};

    if (!isNull _unit) then {
        _camProperties = _display getVariable [QGVAR(camProperties),DEFAULT_CAMPROPS];
        _camProperties params ["_dis","_dirH","_dirV","_targetHelperOffset",["_targetUnit",objNull]];

        if (_targetUnit != _unit) then {
            deleteVehicle (_targetUnit getVariable [QGVAR(targetHelper),objNull]);
            _camProperties set [4,_unit];

            _targetHelper = createagent ["Logic",getPos _unit,[],0,"NONE"];
            _targetHelper attachto [_unit,_targetHelperOffset,""];
            _unit setVariable [QGVAR(targetHelper),_targetHelper];
        };

        [_display] call (_display getVariable [QGVAR(fnc_updateCamera),{ERROR("_fnc_updateCamera not found")}]);
    };
}];

_camInteractionCtrl ctrlAddEventHandler ["mouseMoving",{
    params ["_camInteractionCtrl","_mouseX","_mouseY","_mouseOver"];

    _display = ctrlParent _camInteractionCtrl;
    _display setVariable [QGVAR(mouseOver),_mouseOver];

    if !(_display getVariable [QGVAR(rMouseDown),false]) exitWith {
        _display setVariable [QGVAR(oldMouseCoords),[_mouseX,_mouseY]];
    };

    if (isNil {_display getVariable (QGVAR(oldMouseCoords))}) exitWith {
        _display setVariable [QGVAR(oldMouseCoords),[_mouseX,_mouseY]];
    };

    (_display getVariable [QGVAR(oldMouseCoords),[0,0]]) params ["_mouseXOld","_mouseYOld"];

    _camProperties = _display getVariable [QGVAR(camProperties),DEFAULT_CAMPROPS];
    _camProperties params ["_dis","_dirH","_dirV","_targetHelperOffset",["_targetUnit",objNull]];;

    _dX = (_mouseXOld - _mouseX) * 0.75;
    _dY = (_mouseYOld - _mouseY) * 0.75;
    _targetHelperOffset = [
        [0,0,_targetHelperOffset select 2],
        [[0,0,0],_targetHelperOffset] call bis_fnc_distance2D,
        ([[0,0,0],_targetHelperOffset] call bis_fnc_dirto) - _dX * 180
    ] call bis_fnc_relpos;

    _camProperties set [1,(_dirH - _dX * 180) % 360];
    _camProperties set [2,(_dirV - _dY * 100) max -89 min 89];
    _camProperties set [3,_targetHelperOffset];

    _display setVariable [QGVAR(oldMouseCoords),[_mouseX,_mouseY]];

    [_display] call (_display getVariable [QGVAR(fnc_updateCamera),{ERROR("_fnc_updateCamera not found")}]);
}];

_camInteractionCtrl ctrlAddEventHandler ["mouseZChanged",{
    params ["_camInteractionCtrl","_mouseZ"];

    _display = ctrlParent _camInteractionCtrl;
    if !(_display getVariable [QGVAR(mouseOver),false]) exitWith {};

    _camProperties = _display getVariable [QGVAR(camProperties),DEFAULT_CAMPROPS];

    _camProperties params ["_dis"];
    _camProperties set [0,((_dis - _mouseZ/2) max 2) min 20];

    [_display] call (_display getVariable [QGVAR(fnc_updateCamera),{ERROR("_fnc_updateCamera not found")}]);
}];

_display displayAddEventHandler ["unload",{
    params ["_display","_exitCode"];

    _cam = _display getVariable [QGVAR(cam),objNull];
    _cam cameraeffect ["terminate", "back"];
    camDestroy _cam;
}];

_display displayaddeventhandler ["mousebuttondown",{
    params ["_display","_button"];
    if (_button == 1) then {
        _display setVariable [QGVAR(rMouseDown),true];
    };
}];

_display displayaddeventhandler ["mousebuttonup",{
    params ["_display","_button"];
    if (_button == 1) then {
        _display setVariable [QGVAR(rMouseDown),false];
    };
}];
