#include "component.hpp"

private _handleRadios = [(missionConfigFile >> "Loadouts"), "handleRadios", 0] call BIS_fnc_returnConfigEntry;
if (_handleRadios == 1) then {
    _units = [true] call FUNC(GetApplicableUnits);
    {
        _x unlinkItem "ItemRadio";
    } forEach _units;
};
