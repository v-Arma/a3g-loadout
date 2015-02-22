private ["_configPath", "_loadoutTarget", "_handgunBackup", "_handgunMagazineBackup"];

// Get config entry
_configPath = _this select 0;
_loadoutTarget = _this select 1;


// ========================================== Arsenal =============================================
// This is being done first, so it can be overwritten at a later time, when it is needed.
if ( [_configPath, "linkedItems"] call A3G_Loadout_fnc_IsConfigEntry ) then {
  [_configPath >> "linkedItems", _loadoutTarget] call A3G_Loadout_fnc_ReplaceLinkedItems;
};


// ======================================== Containers ============================================
// Uniform
if ( [_configPath, "uniform"] call A3G_Loadout_fnc_IsConfigEntry ) then {
  [_configPath >> "uniform", _loadoutTarget] call A3G_Loadout_fnc_ReplaceUniform;
};

// Vest
if ( [_configPath, "vest"] call A3G_Loadout_fnc_IsConfigEntry ) then {
  [_configPath >> "vest", _loadoutTarget] call A3G_Loadout_fnc_ReplaceVest;
};

// Backpack
if ( [_configPath, "backpack"] call A3G_Loadout_fnc_IsConfigEntry ) then {
  [_configPath >> "backpack", _loadoutTarget] call A3G_Loadout_fnc_ReplaceBackpack;
};


// ==================================== Items & Magazines =========================================
// Items
if ( [_configPath, "items"] call A3G_Loadout_fnc_IsConfigEntry ) then {
  [_configPath >> "items", _loadoutTarget] call A3G_Loadout_fnc_ReplaceItems;
};

// Magazines
if ( [_configPath, "magazines"] call A3G_Loadout_fnc_IsConfigEntry ) then {
  [_configPath >> "magazines", _loadoutTarget] call A3G_Loadout_fnc_ReplaceMagazines;
};

// Sorted items
// Uniform items & magazines
if ( [_configPath, "addItemsToUniform"] call A3G_Loadout_fnc_IsConfigEntry ) then {
  [_configPath >> "addItemsToUniform", _loadoutTarget] call A3G_Loadout_fnc_AddItemsToUniform;
};

// Vest items & magazines
if ( [_configPath, "addItemsToVest"] call A3G_Loadout_fnc_IsConfigEntry ) then {
  [_configPath >> "addItemsToVest", _loadoutTarget] call A3G_Loadout_fnc_AddItemsToVest;
};

// Backpack items & magazines
if ( [_configPath, "addItemsToBackpack"] call A3G_Loadout_fnc_IsConfigEntry ) then {
  [_configPath >> "addItemsToBackpack", _loadoutTarget] call A3G_Loadout_fnc_AddItemsToBackpack;
};

// Unsorted items
// Added items
if ( [_configPath, "addItems"] call A3G_Loadout_fnc_IsConfigEntry ) then {
  [_configPath >> "addItems", _loadoutTarget] call A3G_Loadout_fnc_AddItems;
};

// Added magazines
if ( [_configPath, "addMagazines"] call A3G_Loadout_fnc_IsConfigEntry ) then {
  [_configPath >> "addMagazines", _loadoutTarget] call A3G_Loadout_fnc_AddMagazines;
};


// ========================================= Weapons ==============================================
// Arsenal weapons
if ( [_configPath, "weapons"] call A3G_Loadout_fnc_IsConfigEntry ) then {
  [_configPath >> "weapons", _loadoutTarget] call A3G_Loadout_fnc_ReplaceWeapons;
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
if ( [_configPath, "primaryWeapon"] call A3G_Loadout_fnc_IsConfigEntry ) then {
  [_configPath >> "primaryWeapon", _loadoutTarget] call A3G_Loadout_fnc_ReplacePrimaryWeapon;
};

// Launcher
if ( [_configPath, "secondaryWeapon"] call A3G_Loadout_fnc_IsConfigEntry ) then {
  [_configPath >> "secondaryWeapon", _loadoutTarget] call A3G_Loadout_fnc_ReplaceSecondaryWeapon;
};

// Sidearm
if ( [_configPath, "handgunWeapon"] call A3G_Loadout_fnc_IsConfigEntry ) then {
  [_configPath >> "handgunWeapon", _loadoutTarget] call A3G_Loadout_fnc_ReplaceHandgunWeapon;
} else {
  // Add handgun back to complete the workaround above
  // Complete retard shit here, but basically it is required to replace the default handgun with something else, as neither adding nor removing it works
  // That's why you get a different pistol here
  if(_handgunBackup == "hgun_P07_F") then {
    // We're only adding extra magazines if they were not removed under the magazine category above, for consistency sake.
    // ie. If someone replaced all magazines already, they'd have to add them manually.
    if( !( [_configPath, "magazines"] call A3G_Loadout_fnc_IsConfigEntry )) then {
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
if ( [_configPath, "primaryWeaponAttachments"] call A3G_Loadout_fnc_IsConfigEntry ) then {
  [_configPath >> "primaryWeaponAttachments", _loadoutTarget] call A3G_Loadout_fnc_ReplacePrimaryAttachments;
};

// Secondary weapon attachments
if ( [_configPath, "secondaryWeaponAttachments"] call A3G_Loadout_fnc_IsConfigEntry ) then {
  [_configPath >> "secondaryWeaponAttachments", _loadoutTarget] call A3G_Loadout_fnc_ReplaceSecondaryAttachments;
};

// Handgun weapon attachments
if ( [_configPath, "handgunWeaponAttachments"] call A3G_Loadout_fnc_IsConfigEntry ) then {
  [_configPath >> "handgunWeaponAttachments", _loadoutTarget] call A3G_Loadout_fnc_ReplaceHandgunAttachments;
};


// ======================================= Linked Items ===========================================
// Headgear
if ( [_configPath, "headgear"] call A3G_Loadout_fnc_IsConfigEntry ) then {
  [_configPath >> "headgear", _loadoutTarget] call A3G_Loadout_fnc_ReplaceHeadgear;
};

// Goggles ( No, this is NOT Night Vision Goggles )
if ( [_configPath, "goggles"] call A3G_Loadout_fnc_IsConfigEntry ) then {
  [_configPath >> "goggles", _loadoutTarget] call A3G_Loadout_fnc_ReplaceGoggles;
};

// Nightvision goggles
if ( [_configPath, "nvgoggles"] call A3G_Loadout_fnc_IsConfigEntry ) then {
  [_configPath >> "nvgoggles", _loadoutTarget] call A3G_Loadout_fnc_ReplaceNVGoggles;
};

// Binoculars
if ( [_configPath, "binoculars"] call A3G_Loadout_fnc_IsConfigEntry ) then {
  [_configPath >> "binoculars", _loadoutTarget] call A3G_Loadout_fnc_ReplaceBinoculars;
};

// Map
if ( [_configPath, "map"] call A3G_Loadout_fnc_IsConfigEntry ) then {
  [_configPath >> "map", _loadoutTarget] call A3G_Loadout_fnc_ReplaceMap;
};

// GPS
if ( [_configPath, "gps"] call A3G_Loadout_fnc_IsConfigEntry ) then {
  [_configPath >> "gps", _loadoutTarget] call A3G_Loadout_fnc_ReplaceGPS;
};

// Compass
if ( [_configPath, "compass"] call A3G_Loadout_fnc_IsConfigEntry ) then {
  [_configPath >> "compass", _loadoutTarget] call A3G_Loadout_fnc_ReplaceCompass;
};

// Watch
if ( [_configPath, "watch"] call A3G_Loadout_fnc_IsConfigEntry ) then {
  [_configPath >> "watch", _loadoutTarget] call A3G_Loadout_fnc_ReplaceWatch;
};