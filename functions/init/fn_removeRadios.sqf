
_handleRadios = [(missionConfigFile >> "Loadouts"), "handleRadios", 0] call BIS_fnc_returnConfigEntry;
if (_handleRadios == 1) then {
    _units = [true] call A3G_Loadout_fnc_GetApplicableUnits;
    {
        _x unlinkItem "ItemRadio";
    } forEach _units;
};
