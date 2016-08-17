#ifndef MODULES_DIRECTORY
    #define MODULES_DIRECTORY modules
#endif

#define PROJECT_NAME grad-loadout

class A3G_Loadout {

  class Arsenal {
    file = MODULES_DIRECTORY\PROJECT_NAME\functions\arsenal;
    class ReplaceLinkedItems {};
    class ReplaceWeapons {};
  };

  class Attachments {
    file = MODULES_DIRECTORY\PROJECT_NAME\functions\attachments;
    class ReplacePrimaryAttachments {};
    class ReplaceSecondaryAttachments {};
    class ReplaceHandgunAttachments {};
  };

  class Containers {
    file = MODULES_DIRECTORY\PROJECT_NAME\functions\containers;
    class ReplaceUniform {};
    class ReplaceBackpack {};
    class ReplaceVest {};
  };

  class General {
    file = MODULES_DIRECTORY\PROJECT_NAME\functions\general;
    class AddItems {};
    class AddMagazines {};
    class AddItemsToUniform {};
    class AddItemsToVest {};
    class AddItemsToBackpack {};
    class ReplaceItems {};
    class ReplaceMagazines {};
  };

  class Init {
    file = MODULES_DIRECTORY\PROJECT_NAME\functions\init;

    class ApplyLoadout {};
    class AssignRespawn {
      postInit = 1;
    };

    class DoLoadout {};
    class ExtractLoadoutFromConfig {};
    class GetApplicableUnits {};
    class MergeLoadoutHierarchy {};
    class RemoveRadios {
        preinit = 1;
    };
    class ScheduleLoadout {
      postInit = 1;
    };
  };

  class LinkedItems {
    file = MODULES_DIRECTORY\PROJECT_NAME\functions\linkedItems;
    class ReplaceBinoculars {};
    class ReplaceCompass {};
    class ReplaceGoggles {};
    class ReplaceGPS {};
    class ReplaceHeadgear {};
    class ReplaceMap {};
    class ReplaceNVGoggles {};
    class ReplaceRadio {};
    class ReplaceWatch {};
  };

  class Weapons {
    file = MODULES_DIRECTORY\PROJECT_NAME\functions\weapons;
    class ReplaceHandgunWeapon {};
    class ReplacePrimaryWeapon {};
    class ReplaceSecondaryWeapon {};
  };

};
