#ifndef MODULES_DIRECTORY
    #define MODULES_DIRECTORY modules
#endif

class A3G_Loadout {

  class Arsenal {
    file = MODULES_DIRECTORY\a3g-loadout\functions\arsenal;
    class ReplaceLinkedItems {};
    class ReplaceWeapons {};
  };

  class Attachments {
    file = MODULES_DIRECTORY\a3g-loadout\functions\attachments;
    class ReplacePrimaryAttachments {};
    class ReplaceSecondaryAttachments {};
    class ReplaceHandgunAttachments {};
  };

  class Containers {
    file = MODULES_DIRECTORY\a3g-loadout\functions\containers;
    class ReplaceUniform {};
    class ReplaceBackpack {};
    class ReplaceVest {};
  };

  class General {
    file = MODULES_DIRECTORY\a3g-loadout\functions\general;
    class AddItems {};
    class AddMagazines {};
    class AddItemsToUniform {};
    class AddItemsToVest {};
    class AddItemsToBackpack {};
    class ReplaceItems {};
    class ReplaceMagazines {};
  };

  class Init {
    file = MODULES_DIRECTORY\a3g-loadout\functions\init;

    class ApplyLoadout {};
    class AssignRespawn {
      postInit = 1;
    };

    class DoLoadout {};
    class IsConfigEntry {};
    class ScheduleLoadout {
      postInit = 1;
    };
  };

  class LinkedItems {
    file = MODULES_DIRECTORY\a3g-loadout\functions\linkedItems;
    class ReplaceBinoculars {};
    class ReplaceCompass {};
    class ReplaceGoggles {};
    class ReplaceGPS {};
    class ReplaceHeadgear {};
    class ReplaceMap {};
    class ReplaceNVGoggles {};
    class ReplaceWatch {};
  };

  class Weapons {
    file = MODULES_DIRECTORY\a3g-loadout\functions\weapons;
    class ReplaceHandgunWeapon {};
    class ReplacePrimaryWeapon {};
    class ReplaceSecondaryWeapon {};
  };

};
