class A3G_Loadout {
	class Functions {
		file = "a3g-loadout\functions";
		class ApplyLoadout { 
			description = "Reads and instructs the loadout function based on config entries.";
			postInit = 1;
		};
		class DoLoadout {
			description = "Applies the loadout";
		};
		class AssignRespawn {
			postInit = 1;
		};
		
		// Arsenal
		class ReplaceLinkedItems {
			description = "Replaces the arsenal linked list.";
		};
		class ReplaceWeapons {
			description = "Replaces the arsenal weapon list.";
		};
		
		// Containers
		class ReplaceUniform {
			description = "Replaces a uniform. Preserves items inside.";
		};
		class ReplaceBackpack {
			description = "Replaces a backpack. Preserves items inside.";
		};
		class ReplaceVest {
			description = "Replaces a backpack. Preserves items inside.";
		};
		
		// Weapons
		class ReplacePrimaryWeapon {
			description = "Replaces the primary weapon.";
		};
		class ReplaceSecondaryWeapon {
			description = "Replaces the secondary ( launcher ) weapon.";
		};
		class ReplaceHandgunWeapon {
			description = "Replaces the handgun weapon.";
		};
		class ReplacePrimaryAttachments {
			description = "Replaces the primary weapon attachments.";
		};
		class ReplaceSecondaryAttachments {
			description = "Replaces the secondary weapon attachments.";
		};
		class ReplaceHandgunAttachments {
			description = "Replaces the handgun attachments.";
		};	
		
		// Items & Magazines
		class ReplaceItems {
			description = "Replaces all items.";
		};
		class ReplaceMagazines {
			description = "Replaces all magazines.";
		};
		class AddItems {
			description = "Adds to the existing items.";
		};
		class AddMagazines {
			description = "Adds to the existing magazines.";
		};
		
		// Linked items
		class ReplaceHeadgear {
			description = "Replaces the active headgear.";
		};
		class ReplaceGoggles {
			description = "Replaces the active goggles.";
		};
		class ReplaceNVGoggles {
			description = "Replaces the active nightvision goggles.";
		};
		class ReplaceBinoculars {
			description = "Replaces the active binoculars.";
		};
		class ReplaceMap {
			description = "Replaces the active map.";
		};
		class ReplaceGPS {
			description = "Replaces the active gps.";
		};
		class ReplaceCompass {
			description = "Replaces the active compass.";
		};
		class ReplaceWatch {
			description = "Replaces the active watch.";
		};
	};
};
