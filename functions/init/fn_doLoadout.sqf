params  ["_loadoutHash", "_loadoutTarget"];
private ["_handgunBackup", "_handgunMagazineBackup"];

// ========================================== Arsenal =============================================
// This is being done first, so it can be overwritten at a later time, when it is needed.
if ( [_loadoutHash, "linkedItems"] call CBA_fnc_hashHasKey ) then {
    _xxx = [_loadoutHash, "linkedItems"] call CBA_fnc_hashGet;
    [_xxx, _loadoutTarget] call A3G_Loadout_fnc_ReplaceLinkedItems;
};

// ======================================== Containers ============================================
// Uniform
if ( [_loadoutHash, "uniform"] call CBA_fnc_hashHasKey ) then {
    _xxx = [_loadoutHash, "uniform"] call CBA_fnc_hashGet;
    [_xxx, _loadoutTarget] call A3G_Loadout_fnc_ReplaceUniform;
};

// Vest
if ( [_loadoutHash, "vest"] call CBA_fnc_hashHasKey ) then {
    _xxx = [_loadoutHash, "vest"] call CBA_fnc_hashGet;
    [_xxx, _loadoutTarget] call A3G_Loadout_fnc_ReplaceVest;
};

// Backpack
if ( [_loadoutHash, "backpack"] call CBA_fnc_hashHasKey ) then {
    _xxx = [_loadoutHash, "backpack"] call CBA_fnc_hashGet;
	[_xxx, _loadoutTarget] call A3G_Loadout_fnc_ReplaceBackpack;
};


// ==================================== Items & Magazines =========================================
// Items
if ( [_loadoutHash, "items"] call CBA_fnc_hashHasKey ) then {
    _xxx = [_loadoutHash, "items"] call CBA_fnc_hashGet;
	[_xxx, _loadoutTarget] call A3G_Loadout_fnc_ReplaceItems;
};

// Magazines
if ( [_loadoutHash, "magazines"] call CBA_fnc_hashHasKey ) then {
    _xxx = [_loadoutHash, "magazines"] call CBA_fnc_hashGet;
	[_xxx, _loadoutTarget] call A3G_Loadout_fnc_ReplaceMagazines;
};

// Sorted items
// Uniform items & magazines
if ( [_loadoutHash, "addItemsToUniform"] call CBA_fnc_hashHasKey ) then {
    _xxx = [_loadoutHash, "addItemsToUniform"] call CBA_fnc_hashGet;
	[_xxx, _loadoutTarget] call A3G_Loadout_fnc_AddItemsToUniform;
};

// Vest items & magazines
if ( [_loadoutHash, "addItemsToVest"] call CBA_fnc_hashHasKey ) then {
    _xxx = [_loadoutHash, "addItemsToVest"] call CBA_fnc_hashGet;
	[_xxx, _loadoutTarget] call A3G_Loadout_fnc_AddItemsToVest;
};

// Backpack items & magazines
if ( [_loadoutHash, "addItemsToBackpack"] call CBA_fnc_hashHasKey ) then {
    _xxx = [_loadoutHash, "addItemsToBackpack"] call CBA_fnc_hashGet;
	[_xxx, _loadoutTarget] call A3G_Loadout_fnc_AddItemsToBackpack;
};

// Unsorted items
// Added items
if ( [_loadoutHash, "addItems"] call CBA_fnc_hashHasKey ) then {
    _xxx = [_loadoutHash, "addItems"] call CBA_fnc_hashGet;
	[_xxx, _loadoutTarget] call A3G_Loadout_fnc_AddItems;
};

// Added magazines
if ( [_loadoutHash, "addMagazines"] call CBA_fnc_hashHasKey ) then {
    _xxx = [_loadoutHash, "addMagazines"] call CBA_fnc_hashGet;
	[_xxx, _loadoutTarget] call A3G_Loadout_fnc_AddMagazines;
};


// ========================================= Weapons ==============================================
// Arsenal weapons
if ( [_loadoutHash, "weapons"] call CBA_fnc_hashHasKey ) then {
    _xxx = [_loadoutHash, "weapons"] call CBA_fnc_hashGet;
	[_xxx, _loadoutTarget] call A3G_Loadout_fnc_ReplaceWeapons;
};

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

// Primary weapon
if ( [_loadoutHash, "primaryWeapon"] call CBA_fnc_hashHasKey ) then {
    _xxx = [_loadoutHash, "primaryWeapon"] call CBA_fnc_hashGet;
	[_xxx, _loadoutTarget] call A3G_Loadout_fnc_ReplacePrimaryWeapon;
};

// Launcher
if ( [_loadoutHash, "secondaryWeapon"] call CBA_fnc_hashHasKey ) then {
    _xxx = [_loadoutHash, "secondaryWeapon"] call CBA_fnc_hashGet;
	[_xxx, _loadoutTarget] call A3G_Loadout_fnc_ReplaceSecondaryWeapon;
};

// Sidearm
if ( [_loadoutHash, "handgunWeapon"] call CBA_fnc_hashHasKey ) then {
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


// ======================================= Attachments ============================================
// Primary weapon attachments
if ( [_loadoutHash, "primaryWeaponAttachments"] call CBA_fnc_hashHasKey ) then {
    _xxx = [_loadoutHash, "primaryWeaponAttachments"] call CBA_fnc_hashGet;
    [_xxx, _loadoutTarget] call A3G_Loadout_fnc_ReplacePrimaryAttachments;
};

// Secondary weapon attachments
if ( [_loadoutHash, "secondaryWeaponAttachments"] call CBA_fnc_hashHasKey ) then {
    _xxx = [_loadoutHash, "secondaryWeaponAttachments"] call CBA_fnc_hashGet;
	[_xxx, _loadoutTarget] call A3G_Loadout_fnc_ReplaceSecondaryAttachments;
};

// Handgun weapon attachments
if ( [_loadoutHash, "handgunWeaponAttachments"] call CBA_fnc_hashHasKey ) then {
    _xxx = [_loadoutHash, "handgunWeaponAttachments"] call CBA_fnc_hashGet;
	[_xxx, _loadoutTarget] call A3G_Loadout_fnc_ReplaceHandgunAttachments;
};


// ======================================= Linked Items ===========================================
// Headgear
if ( [_loadoutHash, "headgear"] call CBA_fnc_hashHasKey ) then {
    _xxx = [_loadoutHash, "headgear"] call CBA_fnc_hashGet;
	[_xxx, _loadoutTarget] call A3G_Loadout_fnc_ReplaceHeadgear;
};

// Goggles ( No, this is NOT Night Vision Goggles )
if ( [_loadoutHash, "goggles"] call CBA_fnc_hashHasKey ) then {
    _xxx = [_loadoutHash, "goggles"] call CBA_fnc_hashGet;
	[_xxx, _loadoutTarget] call A3G_Loadout_fnc_ReplaceGoggles;
};

// Nightvision goggles
if ( [_loadoutHash, "nvgoggles"] call CBA_fnc_hashHasKey ) then {
    _xxx = [_loadoutHash, "nvgoggles"] call CBA_fnc_hashGet;
	[_xxx, _loadoutTarget] call A3G_Loadout_fnc_ReplaceNVGoggles;
};

// Binoculars
if ( [_loadoutHash, "binoculars"] call CBA_fnc_hashHasKey ) then {
    _xxx = [_loadoutHash, "binoculars"] call CBA_fnc_hashGet;
	[_xxx, _loadoutTarget] call A3G_Loadout_fnc_ReplaceBinoculars;
};

// Map
if ( [_loadoutHash, "map"] call CBA_fnc_hashHasKey ) then {
    _xxx = [_loadoutHash, "map"] call CBA_fnc_hashGet;
	[_xxx, _loadoutTarget] call A3G_Loadout_fnc_ReplaceMap;
};

// GPS
if ( [_loadoutHash, "gps"] call CBA_fnc_hashHasKey ) then {
    _xxx = [_loadoutHash, "gps"] call CBA_fnc_hashGet;
	[_xxx, _loadoutTarget] call A3G_Loadout_fnc_ReplaceGPS;
};

// Compass
if ( [_loadoutHash, "compass"] call CBA_fnc_hashHasKey ) then {
    _xxx = [_loadoutHash, "compass"] call CBA_fnc_hashGet;
	[_xxx, _loadoutTarget] call A3G_Loadout_fnc_ReplaceCompass;
};

// Watch
if ( [_loadoutHash, "watch"] call CBA_fnc_hashHasKey ) then {
    _xxx = [_loadoutHash, "watch"] call CBA_fnc_hashGet;
	[_xxx, _loadoutTarget] call A3G_Loadout_fnc_ReplaceWatch;
};
