// Get config entry
_configFile = _this select 0;
_configEntry = _this select 1;
_loadoutTarget = _this select 2;;


// ========================================== Arsenal =============================================
// This is being done first, so it can be overwritten at a later time, when it is needed.
if (isArray (_configFile >> _configEntry >> "linkedItems")) then {
  [_configFile >> _configEntry >> "linkedItems", _loadoutTarget] call A3G_Loadout_fnc_ReplaceLinkedItems;
};


// ======================================== Containers ============================================
// Uniform
if (isText (_configFile >> _configEntry >> "uniform")) then {
  [_configFile >> _configEntry >> "uniform", _loadoutTarget] call A3G_Loadout_fnc_ReplaceUniform;
};

// Backpack
if (isText (_configFile >> _configEntry >> "backpack")) then {
  [_configFile >> _configEntry >> "backpack", _loadoutTarget] call A3G_Loadout_fnc_ReplaceBackpack;
};

// Vest
if (isText (_configFile >> _configEntry >> "vest")) then {
  [_configFile >> _configEntry >> "vest", _loadoutTarget] call A3G_Loadout_fnc_ReplaceVest;
};


// ==================================== Items & Magazines =========================================
// Items
if (isArray (_configFile >> _configEntry >> "items")) then {
  [_configFile >> _configEntry >> "items", _loadoutTarget] call A3G_Loadout_fnc_ReplaceItems;
};

// Magazines
if (isArray (_configFile >> _configEntry >> "magazines")) then {
  [_configFile >> _configEntry >> "magazines", _loadoutTarget] call A3G_Loadout_fnc_ReplaceMagazines;
};

// Added items
if (isArray (_configFile >> _configEntry >> "addItems")) then {
  [_configFile >> _configEntry >> "addItems", _loadoutTarget] call A3G_Loadout_fnc_AddItems;
};

// Added magazines
if (isArray (_configFile >> _configEntry >> "addMagazines")) then {
  [_configFile >> _configEntry >> "addMagazines", _loadoutTarget] call A3G_Loadout_fnc_AddMagazines;
};


// ========================================= Weapons ==============================================
// Arsenal weapon list
if (isArray (_configFile >> _configEntry >> "weapons")) then {
  [_configFile >> _configEntry >> "weapons", _loadoutTarget] call A3G_Loadout_fnc_ReplaceWeapons;
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
if (isText (_configFile >> _configEntry >> "primaryWeapon")) then {
  [_configFile >> _configEntry >> "primaryWeapon", _loadoutTarget] call A3G_Loadout_fnc_ReplacePrimaryWeapon;
};

// Launcher
if (isText (_configFile >> _configEntry >> "secondaryWeapon")) then {
  [_configFile >> _configEntry >> "secondaryWeapon", _loadoutTarget] call A3G_Loadout_fnc_ReplaceSecondaryWeapon;
};

// Sidearm
if (isText (_configFile >> _configEntry >> "handgunWeapon")) then {
  [_configFile >> _configEntry >> "handgunWeapon", _loadoutTarget] call A3G_Loadout_fnc_ReplaceHandgunWeapon;
} else {
  // Add handgun back to complete the workaround above
  // Complete retard shit here, but basically it is required to replace the default handgun with something else, as neither adding nor removing it works
  // That's why you get a different pistol here
  if(_handgunBackup == "hgun_P07_F") then {
    // We're only adding extra magazines if they were not removed under the magazine category above, for consistency sake.
    // ie. If someone replaced all magazines already, they'd have to add them manually.
    if(!isArray (_configFile >> _configEntry >> "magazines")) then {
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
if (isArray (_configFile >> _configEntry >> "primaryWeaponAttachments")) then {
  [_configFile >> _configEntry >> "primaryWeaponAttachments", _loadoutTarget] call A3G_Loadout_fnc_ReplacePrimaryAttachments;
};

// Secondary weapon attachments
if (isArray (_configFile >> _configEntry >> "secondaryWeaponAttachments")) then {
  [_configFile >> _configEntry >> "secondaryWeaponAttachments", _loadoutTarget] call A3G_Loadout_fnc_ReplaceSecondaryAttachments;
};

// Handgun weapon attachments
if (isArray (_configFile >> _configEntry >> "handgunWeaponAttachments")) then {
  [_configFile >> _configEntry >> "handgunWeaponAttachments", _loadoutTarget] call A3G_Loadout_fnc_ReplaceHandgunAttachments;
};


// ======================================= Linked Items ===========================================
// Headgear
if (isText (_configFile >> _configEntry >> "headgear")) then {
  [_configFile >> _configEntry >> "headgear", _loadoutTarget] call A3G_Loadout_fnc_ReplaceHeadgear;
};

// Goggles ( No, this is NOT Night Vision Goggles )
if (isText (_configFile >> _configEntry >> "goggles")) then {
  [_configFile >> _configEntry >> "goggles", _loadoutTarget] call A3G_Loadout_fnc_ReplaceGoggles;
};

// Nightvision goggles
if (isText (_configFile >> _configEntry >> "nvgoggles")) then {
  [_configFile >> _configEntry >> "nvgoggles", _loadoutTarget] call A3G_Loadout_fnc_ReplaceNVGoggles;
};

// Binoculars
if (isText (_configFile >> _configEntry >> "binoculars")) then {
  [_configFile >> _configEntry >> "binoculars", _loadoutTarget] call A3G_Loadout_fnc_ReplaceBinoculars;
};

// Map
if (isText (_configFile >> _configEntry >> "map")) then {
  [_configFile >> _configEntry >> "map", _loadoutTarget] call A3G_Loadout_fnc_ReplaceMap;
};

// GPS
if (isText (_configFile >> _configEntry >> "gps")) then {
  [_configFile >> _configEntry >> "gps", _loadoutTarget] call A3G_Loadout_fnc_ReplaceGPS;
};

// Compass
if (isText (_configFile >> _configEntry >> "compass")) then {
  [_configFile >> _configEntry >> "compass", _loadoutTarget] call A3G_Loadout_fnc_ReplaceCompass;
};

// Watch
if (isText (_configFile >> _configEntry >> "watch")) then {
  [_configFile >> _configEntry >> "watch", _loadoutTarget] call A3G_Loadout_fnc_ReplaceWatch;
};