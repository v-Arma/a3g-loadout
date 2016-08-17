params  ["_loadoutHash", "_loadoutTarget"];
private ["_handgunBackup", "_handgunMagazineBackup"];

_assign = {
    params ["_entryName", "_assignFunction"];
    if ( [_loadoutHash, _entryName] call CBA_fnc_hashHasKey ) then {
        _xxx = [_loadoutHash, _entryName] call CBA_fnc_hashGet;
        [_xxx, _loadoutTarget] call _assignFunction;
    };
};

["linkedItems", A3G_Loadout_fnc_ReplaceLinkedItems] call _assign;
["uniform", A3G_Loadout_fnc_ReplaceUniform] call _assign;
["vest", A3G_Loadout_fnc_ReplaceVest] call _assign;
["backpack", A3G_Loadout_fnc_ReplaceBackpack] call _assign;
["items", A3G_Loadout_fnc_ReplaceItems] call _assign;
["magazines", A3G_Loadout_fnc_ReplaceMagazines] call _assign;
["addItemsToUniform", A3G_Loadout_fnc_AddItemsToUniform] call _assign;
["addItemsToVest", A3G_Loadout_fnc_AddItemsToVest] call _assign;
["addItemsToBackpack", A3G_Loadout_fnc_AddItemsToBackpack] call _assign;
["addItems", A3G_Loadout_fnc_AddItems] call _assign;
["addMagazines", A3G_Loadout_fnc_AddMagazines] call _assign;

["weapons", A3G_Loadout_fnc_ReplaceWeapons] call _assign;


// Workaround to prevent weapon switching when replacing the primary weapon, remove pistol first, add it later after the primary weapon was changed
// Second workaround because for some reason "hgun_P07_F" cannot be removed via removeWeapon
// Instead add a placeholder handgun that can immediately be removed again now ( somehow this works )
_handgunBackup = handgunWeapon _loadoutTarget;
_handgunMagazineBackup = handgunMagazine _loadoutTarget;

if (handgunWeapon _loadoutTarget == "hgun_P07_F") then {
  _loadoutTarget addWeapon "hgun_Pistol_heavy_01_F";
  _loadoutTarget removeWeapon "hgun_Pistol_heavy_01_F";
  _loadoutTarget removeMagazine "16Rnd_9x21_Mag";
  _loadoutTarget removeMagazine "16Rnd_9x21_Mag";
} else {
  _loadoutTarget removeWeapon (handgunWeapon _loadoutTarget);
};

["primaryWeapon", A3G_Loadout_fnc_ReplacePrimaryWeapon] call _assign;
["secondaryWeapon", A3G_Loadout_fnc_ReplaceSecondaryWeapon] call _assign;

// Sidearm
if ( [_loadoutHash, ""] call CBA_fnc_hashHasKey ) then {
    _xxx = [_loadoutHash, "handgunWeapon"] call CBA_fnc_hashGet;
	[_xxx, _loadoutTarget] call A3G_Loadout_fnc_ReplaceHandgunWeapon;
} else {
    // Add handgun back to complete the workaround above
    // Complete retard shit here, but basically it is required to replace the default handgun with something else, as neither adding nor removing it works
    // That's why you get a different pistol here
    if(_handgunBackup == "hgun_P07_F") then {
        // We're only adding extra magazines if they were not removed under the magazine category above, for consistency sake.
        // ie. If someone replaced all magazines already, they'd have to add them manually.
        if( !( [_loadoutHash, "magazines"] call CBA_fnc_hashHasKey )) then {
            _loadoutTarget addMagazine "11Rnd_45ACP_Mag";
            _loadoutTarget addMagazine "11Rnd_45ACP_Mag";
        };
        _loadoutTarget addMagazine "11Rnd_45ACP_Mag";
        _loadoutTarget addWeapon "hgun_Pistol_heavy_01_F";
    } else {
        _loadoutTarget addMagazine (_handgunMagazineBackup select 0);
        _loadoutTarget addWeapon _handgunBackup;
    };
};

["primaryWeaponAttachments", A3G_Loadout_fnc_ReplacePrimaryAttachments] call _assign;
["secondaryWeaponAttachments", A3G_Loadout_fnc_ReplaceSecondaryAttachments] call _assign;
["handgunWeaponAttachments", A3G_Loadout_fnc_ReplaceHandgunAttachments] call _assign;

["headgear", A3G_Loadout_fnc_ReplaceHeadgear] call _assign;
["goggles", A3G_Loadout_fnc_ReplaceGoggles] call _assign;
["nvgoggles", A3G_Loadout_fnc_ReplaceNVGoggles] call _assign;
["binoculars", A3G_Loadout_fnc_ReplaceBinoculars] call _assign;
["map", A3G_Loadout_fnc_ReplaceMap] call _assign;
["gps", A3G_Loadout_fnc_ReplaceGPS] call _assign;
["compass",A3G_Loadout_fnc_ReplaceCompass ] call _assign;
["watch", A3G_Loadout_fnc_ReplaceWatch] call _assign;
["radio", A3G_Loadout_fnc_ReplaceRadio] call _assign;
