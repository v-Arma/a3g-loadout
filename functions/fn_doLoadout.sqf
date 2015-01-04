// Get config entry
_configFile = _this select 0;
_configEntry = _this select 1;

// ========================================== Arsenal =============================================
// This is being done first, so it can be overwritten at a later time, when it is needed.
if (isArray (_configFile >> _configEntry >> "linkedItems")) then {
	[_configFile >> _configEntry >> "linkedItems"] call A3G_Loadout_fnc_ReplaceLinkedItems;
};

// ======================================== Containers ============================================
// Uniform
if (isText (_configFile >> _configEntry >> "uniform")) then {
	[_configFile >> _configEntry >> "uniform"] call A3G_Loadout_fnc_ReplaceUniform;
};

// Backpack
if (isText (_configFile >> _configEntry >> "backpack")) then {
	[_configFile >> _configEntry >> "backpack"] call A3G_Loadout_fnc_ReplaceBackpack;
};

// Vest
if (isText (_configFile >> _configEntry >> "vest")) then {
	[_configFile >> _configEntry >> "vest"] call A3G_Loadout_fnc_ReplaceVest;
};

// ==================================== Items & Magazines =========================================
// Items
if (isArray (_configFile >> _configEntry >> "items")) then {
	[_configFile >> _configEntry >> "items"] call A3G_Loadout_fnc_ReplaceItems;
};

// Magazines
if (isArray (_configFile >> _configEntry >> "magazines")) then {
	[_configFile >> _configEntry >> "magazines"] call A3G_Loadout_fnc_ReplaceMagazines;
};

// Added items
if (isArray (_configFile >> _configEntry >> "addItems")) then {
	[_configFile >> _configEntry >> "addItems"] call A3G_Loadout_fnc_AddItems;
};

// Added magazines
if (isArray (_configFile >> _configEntry >> "addMagazines")) then {
	[_configFile >> _configEntry >> "addMagazines"] call A3G_Loadout_fnc_AddMagazines;
};

// ========================================= Weapons ==============================================
// Arsenal weapon list
if (isArray (_configFile >> _configEntry >> "weapons")) then {
	[_configFile >> _configEntry >> "weapons"] call A3G_Loadout_fnc_ReplaceWeapons;
};

// Workaround to prevent weapon switching when replacing the primary weapon, remove pistol first, add it later after the primary weapon was changed
// Second workaround because for some reason "hgun_P07_F" cannot be removed via removeWeapon
// Instead add a placeholder handgun that can immediately be removed again now ( somehow this works )
_handgunBackup = handgunWeapon player;
_handgunMagazineBackup = handgunMagazine player;

if (handgunWeapon player == "hgun_P07_F") then {
	player addWeapon "hgun_Pistol_heavy_01_F";
	player removeWeapon "hgun_Pistol_heavy_01_F";
	player removeMagazine "16Rnd_9x21_Mag";
	player removeMagazine "16Rnd_9x21_Mag";
} else {
	player removeWeapon (handgunWeapon player);
};

// Primary weapon
if (isText (_configFile >> _configEntry >> "primaryWeapon")) then {
	[_configFile >> _configEntry >> "primaryWeapon"] call A3G_Loadout_fnc_ReplacePrimaryWeapon;
};

// Launcher
if (isText (_configFile >> _configEntry >> "secondaryWeapon")) then {
	[_configFile >> _configEntry >> "secondaryWeapon"] call A3G_Loadout_fnc_ReplaceSecondaryWeapon;
};

// Sidearm
if (isText (_configFile >> _configEntry >> "handgunWeapon")) then {
	[_configFile >> _configEntry >> "handgunWeapon"] call A3G_Loadout_fnc_ReplaceHandgunWeapon;
} else {
	// Add handgun back to complete the workaround above
	// Complete retard shit here, but basically it is required to replace the default handgun with something else, as neither adding nor removing it works
	// That's why you get a different pistol here
	if(_handgunBackup == "hgun_P07_F") then {	
		// We're only adding extra magazines if they were not removed under the magazine category above, for consistency sake.
		// ie. If someone replaced all magazines already, they'd have to add them manually.
		if(!isArray (_configFile >> _configEntry >> "magazines")) then {
			player addMagazine "11Rnd_45ACP_Mag";
			player addMagazine "11Rnd_45ACP_Mag";
		};
		player addMagazine "11Rnd_45ACP_Mag";
		player addWeapon "hgun_Pistol_heavy_01_F";
	} else {
		player addMagazine (_handgunMagazineBackup select 0);
		player addWeapon _handgunBackup;
	};
};

// ======================================= Attachments ============================================
// Primary weapon attachments
if (isArray (_configFile >> _configEntry >> "primaryWeaponAttachments")) then {
	[_configFile >> _configEntry >> "primaryWeaponAttachments"] call A3G_Loadout_fnc_ReplacePrimaryAttachments;
};

// Secondary weapon attachments
if (isArray (_configFile >> _configEntry >> "secondaryWeaponAttachments")) then {
	[_configFile >> _configEntry >> "secondaryWeaponAttachments"] call A3G_Loadout_fnc_ReplaceSecondaryAttachments;
};

// Handgun weapon attachments
if (isArray (_configFile >> _configEntry >> "handgunWeaponAttachments")) then {
	[_configFile >> _configEntry >> "handgunWeaponAttachments"] call A3G_Loadout_fnc_ReplaceHandgunAttachments;
};

// ======================================= Linked Items ===========================================
// Headgear
if (isText (_configFile >> _configEntry >> "headgear")) then {
	[_configFile >> _configEntry >> "headgear"] call A3G_Loadout_fnc_ReplaceHeadgear;
};

// Goggles ( No, this is NOT Night Vision Goggles )
if (isText (_configFile >> _configEntry >> "goggles")) then {
	[_configFile >> _configEntry >> "goggles"] call A3G_Loadout_fnc_ReplaceGoggles;
};

// Nightvision goggles
if (isText (_configFile >> _configEntry >> "nvgoggles")) then {
	[_configFile >> _configEntry >> "nvgoggles"] call A3G_Loadout_fnc_ReplaceNVGoggles;
};

// Binoculars
if (isText (_configFile >> _configEntry >> "binoculars")) then {
	[_configFile >> _configEntry >> "binoculars"] call A3G_Loadout_fnc_ReplaceBinoculars;
};

// Map
if (isText (_configFile >> _configEntry >> "map")) then {
	[_configFile >> _configEntry >> "map"] call A3G_Loadout_fnc_ReplaceMap;
};

// GPS
if (isText (_configFile >> _configEntry >> "gps")) then {
	[_configFile >> _configEntry >> "gps"] call A3G_Loadout_fnc_ReplaceGPS;
};

// Compass
if (isText (_configFile >> _configEntry >> "compass")) then {
	[_configFile >> _configEntry >> "compass"] call A3G_Loadout_fnc_ReplaceCompass;
};

// Watch
if (isText (_configFile >> _configEntry >> "watch")) then {
	[_configFile >> _configEntry >> "watch"] call A3G_Loadout_fnc_ReplaceWatch;
};