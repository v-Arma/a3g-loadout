// normalize magazines in content.
// input: ["stanag_foo", "stanag_blub", "handgrenade", "something_else"]
// output: [["stanag_foo", 2], ["handgrenade", 1],  "something_else"]

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
    [_magazines, _x] call _CBA_fnc_hashIncr;
} forEach _contentFromConfig;

[
    _magazines,
    {
        _className = _key;

        if (_className isKindof ["CA_Magazine", configfile >> "CfgMagazines"]) then {
            _contentForLoadout pushBack [_key, _value, 1];
        } else {
            _contentForLoadout pushBack [_key, _value];
        };
    }
] call CBA_fnc_hashEachPair;

_contentForLoadout
