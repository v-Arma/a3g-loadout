#ifndef MODULES_DIRECTORY
    #define MODULES_DIRECTORY modules
#endif

class GRAD_Loadout {
    class Extract {
        file = MODULES_DIRECTORY\grad-loadout\functions\extract;
        class GetPathExtractor {};
        class ExtractLoadoutFromConfig {};
    };
    class General {
        file = MODULES_DIRECTORY\grad-loadout\functions\general;
        class ApplyLoadout {};
        class AssignRespawn {
          postInit = 1;
        };
        class DefactionizeType {};
        class DoLoadout {};
        class FactionGetLoadout {};
        class FactionSetLoadout {};
        class GetApplicableUnits {};
        class GetLoadoutConfigPath {};
        class GetUnusedConfigs {};
        class GetUnitLoadoutFromConfig {};
        class HashToUnitLoadout {};
        class InitGlobals {
            preinit = 1;
        };
        class MergeLoadoutHierarchy {};
        class NormalizeMagazinesInContent {};
        class RemoveRadios {
            preinit = 1;
        };
        class ScheduleLoadout {
          postInit = 1;
        };
        class WeaponIsCompatibleMagazine {};
    };
    class Revivers {
        file = MODULES_DIRECTORY\grad-loadout\functions\revivers;
        class GetRevivers {};
        class AddReviver {};
        class ApplyRevivers {};
    };
};
