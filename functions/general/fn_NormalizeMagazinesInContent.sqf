// normalize magazines in content.
// input: ["stanag_foo", "stanag_blub", "handgrenade", "something_else"]
// outpuit: [["stanag_foo", 2], ["handgrenade", 1],  "something_else"]

params ["_contentFromConfig"];

private _CBA_fnc_hashIncr = {
    params ["_hash", "_key"];
    _value = 1;
    if ([_hash, _key] call CBA_fnc_hashHasKey) then {
        _value = _value + ([_hash, _key] call CBA_fnc_hashGet);
    };
    [_hash, _key, _value] call CBA_fnc_hashSet;
};

private _magazines = [] call CBA_fnc_hashCreate;
private _contentForLoadout = [];

{
    if (_x isKindof ["CA_Magazine", configfile >> "CfgMagazines"]) then {
        [_magazines, _x] call _CBA_fnc_hashIncr;
    } else {
        _contentForLoadout pushBack _x;
    };
} forEach _contentFromConfig;

[
    _magazines,
    {
        _contentForLoadout pushBack [_key, _value, 1];
    }
] call CBA_fnc_hashEachPair;

_contentForLoadout
