//Checks if weapons in contetn can fit and corrects the configFile
// input: ["stanag_foo", "stanag_blub", "weapon", "something_else"]
// output: ["stanag_foo", "stanag_blub", ["weapon","","","",[],[],""], "something_else"]

params ["_contentFromConfig"];

private _CBA_fnc_hashIncr = {
   params ["_hash","_key"];

    _value = 1;
    if ([_hash, _key] call CBA_fnc_hashHasKey) then {
        _value = _value + ([_hash, _key] call CBA_fnc_hashGet);
    };
    [_hash, _key, _value] call CBA_fnc_hashSet;
};

private _checkIfWeaponFits = {
   params ["_backpackClass", "_weapon"];

   private _backpack = _backpackClass createVehicle [0,0,-1000];

   private _result = _backpack backpackSpaceFor _weapon;
   deleteVehicle _backpack;

   _result
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

        if (_className isKindOf ["CA_Magazine", configFile >> "CfgMagazines"]) then {
            _contentForLoadout pushBack [_key, _value, 1];
        } else {
            _contentForLoadout pushBack [_key, _value];
        };
    }
] call CBA_fnc_hashEachPair;

_contentForLoadout
