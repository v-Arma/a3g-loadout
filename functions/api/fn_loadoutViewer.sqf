#include "component.hpp"

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

#define TREE_H              (COLUMN_H - 2 * PADDING_Y)
#define CHECKBOX_Y          (COLUMN_Y + COLUMN_H - PADDING_Y)

#define INFOPIC_W           (COLUMN_W - 8 * PADDING_X)
#define INFOPIC_H           (COLUMN_H/2 - 8 * PADDING_Y)
#define INFOPIC_X           (COLUMN2_X + 4 * PADDING_X)
#define INFOPIC_Y           (COLUMN_Y + 8 * PADDING_Y)

#define INFOTEXT_W          ((COLUMN_W - 3 * PADDING_X)/2)
#define INFOTEXTL_X         (COLUMN2_X + 2 * PADDING_X)
#define INFOTEXTR_X         (INFOTEXTL_X + INFOTEXT_W - PADDING_X)
#define INFOTEXT_Y          (INFOPIC_Y + INFOPIC_H + PADDING_Y)
#define INFOTEXT_H          (5.000 * Y_SCALE)

#define SWITCHBUTTON_H      (0.025 * Y_SCALE)
#define SWITCHBUTTON_W      (COLUMN_W - 6 * PADDING_X)
#define SWITCHBUTTON_X      (COLUMN2_X + (COLUMN_W - SWITCHBUTTON_W) / 2)
#define SWITCHBUTTON_Y      (safeZoneY + safeZoneH - PADDING_Y - SWITCHBUTTON_H)


// OTHER DEFINES ===============================================================
#define DEFAULT_CAMPROPS            [7,45,20,[0,0,0.9],objNull]
#define BACKGROUND_COLOR            [0.1,0.1,0.1,1]
#define QUADS(var1,var2,var3,var4)  ##var1##_##var2##_##var3##_##var4
#define DISPLAYFUNC(var)            (_display getVariable [QUOTE(QUADS(PREFIX,COMPONENT,fnc,var)),{}])
#define DISPLAYCONTROL(var)         (_display getVariable [QUOTE(TRIPLES(PREFIX,COMPONENT,var)),controlNull])
#define DISPLAYVAR(var1,var2)       (_display getVariable [QGVAR(var1),var2])
#define CONVERTTOKG(var)            (round ((0.1 * var) * (1/2.2046) * 100)) / 100

// CREATE DIALOG ===============================================================
private _display = (findDisplay 46) createDisplay "RscDisplayEmpty";
if (isNull _display) exitWith {systemChat "[GRAD] (loadout) ERROR: Display is null."};
_display setVariable [QGVAR(sides),_this];

{
    _bgCtrl = _display ctrlCreate ["RscBackground",-1];
    _bgCtrl ctrlSetPosition _x;
    _bgCtrl ctrlSetBackgroundColor BACKGROUND_COLOR;
    _bgCtrl ctrlCommit 0;
} forEach [
    [safeZoneX,safeZoneY,safeZoneW,PADDING_Y],
    [safeZoneX,safeZoneY + safeZoneH - PADDING_Y,safeZoneW,PADDING_Y],
    [safeZoneX,safeZoneY + PADDING_Y,2 * PADDING_X + COLUMN_W,safeZoneH - 2 * PADDING_Y],
    [safeZoneX + safeZoneW - 2 * PADDING_X - COLUMN_W,safeZoneY + PADDING_Y,2 * PADDING_X + COLUMN_W,safeZoneH - 2 * PADDING_Y]
];

private _camInteractionCtrl = _display ctrlCreate ["RscTextMulti",-1];
_camInteractionCtrl ctrlSetPosition [CAMERA_X,COLUMN_Y,CAMERA_W,COLUMN_H];
_camInteractionCtrl ctrlSetBackgroundColor BACKGROUND_COLOR;
_camInteractionCtrl ctrlCommit 0;
_display setVariable [QGVAR(camInteractionCtrl),_camInteractionCtrl];

private _tvCtrl = _display ctrlCreate ["RscTree",-1];
_tvCtrl ctrlSetPosition [COLUMN1_X,COLUMN_Y,COLUMN_W,TREE_H];
_tvCtrl ctrlCommit 0;
_display setVariable [QGVAR(tvCtrl),_tvCtrl];

private _checkboxCtrl = _display ctrlCreate ["RscCheckBox",-1];
_checkboxCtrl ctrlSetPosition [COLUMN1_X,CHECKBOX_Y,PADDING_X,PADDING_Y];
_checkboxCtrl ctrlCommit 0;
_checkboxCtrl cbSetChecked (missionNamespace getVariable [QGVAR(loadoutViewer_onlyPlayable),false]);
_display setVariable [QGVAR(checkboxCtrl),_checkboxCtrl];

private _checkboxTextCtrl = _display ctrlCreate ["RscText",-1];
_checkboxTextCtrl ctrlSetPosition [COLUMN1_X + PADDING_X,CHECKBOX_Y,COLUMN_W,PADDING_Y];
_checkboxTextCtrl ctrlSetText (["Hide Non-Playable (only in works in multiplayer)","Hide Non-Playable"] select isMultiplayer);
_checkboxTextCtrl ctrlCommit 0;

private _infoPicCtrl = _display ctrlCreate ["RscPictureKeepAspect",-1];
_infoPicCtrl ctrlSetPosition [INFOPIC_X,INFOPIC_Y,INFOPIC_W,INFOPIC_H];
_infoPicCtrl ctrlCommit 0;
_display setVariable [QGVAR(infoPicCtrl),_infoPicCtrl];

private _infoTextCtrlL = _display ctrlCreate ["RscStructuredText",-1];
_infoTextCtrlL ctrlSetPosition [INFOTEXTL_X,INFOTEXT_Y,2 * X_SCALE,5 * X_SCALE];
_infoTextCtrlL ctrlCommit 0;
_display setVariable [QGVAR(infoTextCtrlL),_infoTextCtrlL];

private _infoTextCtrlR = _display ctrlCreate ["RscStructuredText",-1];
_infoTextCtrlR ctrlSetPosition [INFOTEXTR_X,INFOTEXT_Y,INFOTEXT_W,INFOTEXT_H];
_infoTextCtrlR ctrlCommit 0;
_display setVariable [QGVAR(infoTextCtrlR),_infoTextCtrlR];

private _switchUnitCtrl = _display ctrlCreate ["RscButtonMenu",-1];
_switchUnitCtrl ctrlSetPosition [SWITCHBUTTON_X,SWITCHBUTTON_Y,SWITCHBUTTON_W,SWITCHBUTTON_H];
_switchUnitCtrl ctrlSetBackgroundColor [profilenamespace getvariable ['GUI_BCG_RGB_R',0.13],profilenamespace getvariable ['GUI_BCG_RGB_G',0.54],profilenamespace getvariable ['GUI_BCG_RGB_B',0.21],profilenamespace getvariable ['GUI_BCG_RGB_A',0.8]];
_switchUnitCtrl ctrlSetText "Switch to Unit";
_switchUnitCtrl ctrlEnable false;
_switchUnitCtrl ctrlCommit 0;
_display setVariable [QGVAR(switchUnitCtrl),_switchUnitCtrl];


// SUBFUNCTIONS ================================================================
_display setVariable [QGVAR(fnc_getParentClass),{
    params ["_thisItemClassname"];
    private _parentClass = "";
    {
        if (isClass (configFile >> _x >> _thisItemClassname)) exitWith {_parentClass = _x};
        false
    } count ["CfgWeapons","CfgMagazines","CfgVehicles"];
    _parentClass
}];

_display setVariable [QGVAR(fnc_fillDialog),{
    params ["_display","_sides","_onlyPlayable"];

    tvClear DISPLAYCONTROL(tvCtrl);

    if (count _sides == 0) then {_sides = [WEST,EAST,INDEPENDENT,CIVILIAN]};

    private _unitsCache = [];
    {
        [_display,_x,_onlyPlayable] call DISPLAYFUNC(addSide);
    } forEach _sides;
    _display setVariable [QGVAR(unitsCache),_unitsCache];
}];

_display setVariable [QGVAR(fnc_addSide),{
    params ["_display","_side","_onlyPlayable"];

    _sideUnitsCache = _unitsCache select (_unitsCache pushBack []);
    _sideGroups = allGroups select {side _x == _side && {count units _x > 0}};
    _filteredGroups = _sideGroups select {!_onlyPlayable || {{_x in playableUnits} count (units _x) > 0}};

    _sidePath = [DISPLAYCONTROL(tvCtrl) tvAdd [[],str _side]];
    {[_display,_sidePath,_x,_onlyPlayable] call DISPLAYFUNC(addGroup)} forEach _filteredGroups;
}];

_display setVariable [QGVAR(fnc_addGroup),{
    params ["_display","_sidePath","_group","_onlyPlayable"];

    _groupUnitsCache = _sideUnitsCache select (_sideUnitsCache pushBack []);
    _groupPath = _sidePath + [DISPLAYCONTROL(tvCtrl) tvAdd [_sidePath,str _group]];
    _filteredUnits = (units _group) select {!_onlyPlayable || {_x in playableUnits}};
    {[_display,_groupPath,_x] call DISPLAYFUNC(addUnit)} forEach _filteredUnits;
}];

_display setVariable [QGVAR(fnc_addUnit),{
    params ["_display","_groupPath","_unit"];

    _groupUnitsCache pushBack _unit;
    _unitDisplayName = roleDescription _unit;
    if (_unitDisplayName == "") then {
        _unitDisplayName = [configfile >> "CfgVehicles" >> typeOf _unit,"displayName","ERROR: NO DISPLAYNAME"] call BIS_fnc_returnConfigEntry;
    };
    _unitPath = _groupPath + [DISPLAYCONTROL(tvCtrl) tvAdd [_groupPath,_unitDisplayName]];
    DISPLAYCONTROL(tvCtrl) tvSetTooltip [_unitPath,typeOf _unit];

    {
        [_display,_unitPath,_x,_forEachIndex] call DISPLAYFUNC(addAnItem);
    } forEach [
        (assignedItems _unit) + [headgear _unit,goggles _unit,hmd _unit],
        uniformItems _unit,
        vestItems _unit,
        backpackItems _unit,
        (primaryWeaponItems _unit) + (primaryWeaponMagazine _unit),
        (secondaryWeaponItems _unit) + (secondaryWeaponMagazine _unit),
        (handgunItems _unit) + (handgunMagazine _unit)
    ];
}];

_display setVariable [QGVAR(fnc_addAnItem),{
    params ["_display","_unitPath","_itemsList","_containerType"];

    _sanitizedItemsList = _itemsList select {_x != ""};
    _uniqueItemsList = _sanitizedItemsList arrayIntersect _sanitizedItemsList;
    _containerClassName = [QGVAR(STR_ASSIGNED_ITEMS),uniform _unit,vest _unit,backpack _unit,primaryWeapon _unit,secondaryWeapon _unit,handgunWeapon _unit] select _containerType;
    _containerParentClass = [_containerClassName] call DISPLAYFUNC(getParentClass);
    _containerDisplayName = [[configFile >> _containerParentClass >> _containerClassName,"displayName","ERROR: NO DISPLAY NAME"] call BIS_fnc_returnConfigEntry,"Assigned Items"] select (_containerType == 0);

    _tvCtrl = DISPLAYCONTROL(tvCtrl);

    if (_containerClassName != "") then {
        _containerContentMass = 0;
        _containerPath = _unitPath + [_tvCtrl tvAdd [_unitPath,_containerDisplayName]];
        _tvCtrl tvSetTooltip [_containerPath,_containerClassName];
        _tvCtrl tvSetData [_containerPath,_containerClassName];
        _tvCtrl tvSetPicture [_containerPath,[configFile >> _containerParentClass >> _containerClassName,"picture",""] call BIS_fnc_returnConfigEntry];

        {
            _itemClassname = _x;
            _itemCount = {_x == _itemClassname} count _sanitizedItemsList;
            _itemParentClass = [_itemClassname] call DISPLAYFUNC(getParentClass);
            _itemPic = [_itemClassname,_itemParentClass] call DISPLAYFUNC(getItemPic);

            _itemPath = _containerPath + [_tvCtrl tvAdd [_containerPath,format ["%1x %2",_itemCount,[configFile >> _itemParentClass >> _itemClassname,"displayName","ERROR: NO DISPLAY NAME"] call BIS_fnc_returnConfigEntry]]];
            _tvCtrl tvSetTooltip [_itemPath,_itemClassname];
            _tvCtrl tvSetValue [_itemPath,_itemCount];
            _tvCtrl tvSetData [_itemPath,_itemClassname];
            _tvCtrl tvSetPicture [_itemPath,[configFile >> _itemParentClass >> _itemClassname,"picture",""] call BIS_fnc_returnConfigEntry];

            _containerContentMass = _containerContentMass + _itemCount * ([_itemClassname] call DISPLAYFUNC(getItemMass));
        } forEach _uniqueItemsList;
        _tvCtrl tvSetValue [_containerPath,_containerContentMass * 100];
    };
}];

_display setVariable [QGVAR(fnc_updateCamera),{
    params [["_display",displayNull]];

    if (isNull _display) exitWith {};

    private _cam = DISPLAYVAR(cam,objNull);
    private _camProperties = _display getVariable [QGVAR(camProperties),DEFAULT_CAMPROPS];
    _camProperties params ["_dis","_dirH","_dirV","_targetHelperOffset",["_targetUnit",objNull]];

    private _targetHelper = _targetUnit getVariable [QGVAR(targetHelper),objNull];
    if (isNull _targetHelper) exitWith {ERROR("_targetHelper is null")};

    [_targetHelper,[_dirH + 180,-_dirV,0]] call bis_fnc_setobjectrotation;
    _targetHelper attachto [_targetUnit,_targetHelperOffset,""];

    _cam setpos (_targetHelper modeltoworld [0,-_dis,0]);
    _cam setvectordirandup [vectordir _targetHelper,vectorup _targetHelper];

    //--- Make sure the camera is not underground
    if ((getposasl _cam select 2) < (getposasl _cam select 2)) then {
        _disCoef = ((getposasl _targetHelper select 2) - (getposasl _cam select 2)) / ((getposasl _targetHelper select 2) - (getposasl _cam select 2) + 0.001);
        _cam setpos (_targetHelper modeltoworldvisual [0,-_dis * _disCoef,0]);
    };

    _cam camCommit 0;
}];

_display setVariable [QGVAR(fnc_getItemMass),{
    params ["_className"];

    private _mass = [configFile >> "CfgWeapons" >> _className >> "ItemInfo","mass",0] call BIS_fnc_returnConfigEntry;
    if (_mass isEqualTo 0) then {
        _mass = [configFile >> "CfgWeapons" >> _className >> "WeaponSlotsInfo","mass",0] call BIS_fnc_returnConfigEntry;
    };
    if (_mass isEqualTo 0) then {
        _mass = [configFile >> "CfgMagazines" >> _className,"mass",0] call BIS_fnc_returnConfigEntry;
    };
    if (_mass isEqualTo 0) then {
        _mass = [configFile >> "CfgVehicles" >> _className,"mass",0] call BIS_fnc_returnConfigEntry;
    };
    if !(_mass isEqualType 0) then {
        _mass = 0;
    };
    CONVERTTOKG(_mass)
}];


// CREATE CAMERA ===============================================================
private _cam = "camera" camcreate (getPos player);
_cam cameraeffect ["External","back"];

showCinemaBorder false;
if (sunOrMoon < 0.35) then {camUseNVG true};

_display setVariable [QGVAR(camProperties),DEFAULT_CAMPROPS];
_display setVariable [QGVAR(cam),_cam];


// DIALOG FUNCTIONALITY ========================================================
_tvCtrl ctrlAddEventHandler ["treeSelChanged",{
    params ["_tvCtrl","_selPath"];
    _selPath params [["_sideIndex",999999],["_groupIndex",999999],["_unitIndex",999999],["_containerIndex",999999],["_itemIndex",999999]];

    _display = ctrlParent _tvCtrl;
    _switchUnitCtrl = _display getVariable [QGVAR(switchUnitCtrl),controlNull];

    // center cam on selected unit/group
    _unitsCache = DISPLAYVAR(unitsCache,[]);
    _unit = if (count _selPath > 1) then {
        if (count _selPath > 2) then {
            _unitsCache select _sideIndex select _groupIndex select _unitIndex
        } else {
            leader (_unitsCache select _sideIndex select _groupIndex select 0)
        };
    } else {objNull};

    _camProperties = _display getVariable [QGVAR(camProperties),DEFAULT_CAMPROPS];
    _camProperties params ["_dis","_dirH","_dirV","_targetHelperOffset",["_targetUnit",objNull]];

    if (count _selPath > 2 && {!isNull _unit} && {!isPlayer _unit}) then {
        _switchUnitCtrl ctrlEnable true;
    } else {
        _switchUnitCtrl ctrlEnable false;
    };

    if (!isNull _unit) then {
        if (isNull _targetUnit) then {
            DISPLAYCONTROL(camInteractionCtrl) ctrlSetBackgroundColor [0,0,0,0];
        };

        if (_targetUnit != _unit) then {
            deleteVehicle (_targetUnit getVariable [QGVAR(targetHelper),objNull]);
            _camProperties set [4,_unit];

            _targetHelper = createagent ["Logic",getPos _unit,[],0,"NONE"];
            _targetHelper attachto [_unit,_targetHelperOffset,""];
            _unit setVariable [QGVAR(targetHelper),_targetHelper];
        };

        [_display] call DISPLAYFUNC(updateCamera);
    } else {
        if (!isNull _targetUnit) then {
            DISPLAYCONTROL(camInteractionCtrl) ctrlSetBackgroundColor BACKGROUND_COLOR;
            _camProperties set [4,_unit];
        };
    };

    // display info
    _infoPicCtrl = DISPLAYCONTROL(infoPicCtrl);
    _infoTextCtrlL = DISPLAYCONTROL(infoTextCtrlL);
    _infoTextCtrlR = DISPLAYCONTROL(infoTextCtrlR);

    if (count _selPath > 2) then {
        // _infoTextArrayR needs <br/> instead of lineBreak because it's converted to structured text differently in order for <t align='right'> to work
        _infoTextArrayL = [(_tvCtrl tvText _selPath),lineBreak,lineBreak];
        _infoTextArrayR = ["<br/>","<br/>"];

        if (count _selPath == 3) then {
            _infoTextArrayL pushBack "Total Load:";
            _infoTextArrayR pushBack format ["%1 kg",CONVERTTOKG(loadAbs _unit)];
        };

        if (count _selPath in [4,5]) then {
            _infoPicCtrl ctrlSetText (_tvCtrl tvPicture _selPath);

            _itemWeight = [_tvCtrl tvData _selPath] call DISPLAYFUNC(getItemMass);

            // assigned items container has no weight
            if (_selPath select 3 > 0 || count _selPath == 5) then {
                _infoTextArrayL pushBack "Item Weight:";
                _infoTextArrayR pushBack format ["%1 kg",_itemWeight];
                _infoTextArrayL pushBack lineBreak;
                _infoTextArrayR pushBack "<br/>";
            };

            if (count _selPath == 4) then {
                _containerClassName = (_tvCtrl tvData _selPath);
                _infoTextArrayL pushBack "Content Weight:";
                _infoTextArrayR pushBack format ["%1 kg",(_tvCtrl tvValue _selPath)/100];


                if ((isClass (configFile >> "CfgWeapons" >> _containerClassName) || (isClass (configFile >> "CfgVehicles" >> _containerClassName))) && {getContainerMaxLoad _containerClassName > -1}) then {
                    _infoTextArrayL pushBack lineBreak;
                    _infoTextArrayR pushBack "<br/>";

                    _maxLoad = CONVERTTOKG(getContainerMaxLoad _containerClassName);
                    _currentLoad = ((_tvCtrl tvValue _selPath)/100);
                    _spaceleft = _maxLoad - _currentLoad;

                    _infoTextArrayL pushBack "Space Left:";
                    _infoTextArrayR pushBack ([
                        format ["%1 kg (%2%3)",_spaceleft,(round ((_spaceleft/(_maxLoad max 0.0001))*100)),"%"],
                        "<t color='#ff2b2b'>Beyond max. capacity!"
                    ] select (_spaceleft < 0));
                };
            };

            if (count _selPath == 5 && {(_tvCtrl tvValue _selPath) > 1}) then {
                _infoTextArrayL pushBack "Total Weight:";
                _infoTextArrayR pushBack format ["%1 kg",_itemWeight * (_tvCtrl tvValue _selPath)];
            };
        } else {
            _infoPicCtrl ctrlSetText "";
        };

        _infoTextCtrlL ctrlSetStructuredText composeText _infoTextArrayL;
        _infoTextCtrlR ctrlSetStructuredText parseText call {_t = "<t align='right'>"; {_t=_t+_x} forEach _infoTextArrayR;_t + "</t>"};
    } else {
        _infoTextCtrlL ctrlSetStructuredText parseText "";
        _infoTextCtrlR ctrlSetStructuredText parseText "";
        _infoPicCtrl ctrlSetText "";
    };
}];

_switchUnitCtrl ctrlAddEventHandler ["buttonClick",{
    params [["_switchUnitCtrl",controlNull]];


    _display = ctrlParent _switchUnitCtrl;
    _tvCtrl = _display getVariable [QGVAR(tvCtrl),controlNull];
    _selPath = tvCurSel _tvCtrl;

    _selPath params [["_sideIndex",999999],["_groupIndex",999999],["_unitIndex",999999],["_containerIndex",999999],["_itemIndex",999999]];
    _unitsCache = DISPLAYVAR(unitsCache,[]);

    _unit = if (count _selPath > 1) then {
        if (count _selPath > 2) then {
            _unitsCache select _sideIndex select _groupIndex select _unitIndex
        } else {
            leader (_unitsCache select _sideIndex select _groupIndex select 0)
        };
    } else {objNull};

    if (!isNull _unit) then {
        _display closeDisplay 1;
        selectPlayer _unit;
        player action ["Gear",player];
    } else {
        _switchUnitCtrl ctrlEnable false;
        playSound "taskFailed";
    };
}];

_camInteractionCtrl ctrlAddEventHandler ["mouseMoving",{
    params ["_camInteractionCtrl","_mouseX","_mouseY","_mouseOver"];

    _display = ctrlParent _camInteractionCtrl;
    _display setVariable [QGVAR(mouseOver),_mouseOver];

    if !(DISPLAYVAR(rMouseDown,false)) exitWith {
        _display setVariable [QGVAR(oldMouseCoords),[_mouseX,_mouseY]];
    };

    if (isNil {DISPLAYVAR(oldMouseCoords,nil)}) exitWith {
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

    [_display] call DISPLAYFUNC(updateCamera);
}];

_camInteractionCtrl ctrlAddEventHandler ["mouseZChanged",{
    params ["_camInteractionCtrl","_mouseZ"];

    _display = ctrlParent _camInteractionCtrl;
    if !(DISPLAYVAR(mouseOver,false)) exitWith {};

    _camProperties = _display getVariable [QGVAR(camProperties),DEFAULT_CAMPROPS];

    _camProperties params ["_dis"];
    _camProperties set [0,((_dis - _mouseZ/2) max 2) min 20];

    [_display] call DISPLAYFUNC(updateCamera);
}];

_checkboxCtrl ctrlAddEventHandler ["checkedChanged",{
    params ["_checkboxCtrl","_checkedID"];

    missionNamespace setVariable [QGVAR(loadoutViewer_onlyPlayable),_checkedID == 1];
    _display = ctrlParent _checkboxCtrl;
    [_display,DISPLAYVAR(sides,[]),_checkedID == 1] call DISPLAYFUNC(fillDialog);
}];

_display displayAddEventHandler ["unload",{
    params ["_display","_exitCode"];

    _cam = DISPLAYVAR(cam,objNull);
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

// FILL DIALOG =================================================================
[_display,_this,missionNamespace getVariable [QGVAR(loadoutViewer_onlyPlayable),false]] call DISPLAYFUNC(fillDialog);
