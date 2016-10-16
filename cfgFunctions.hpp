#ifndef MODULES_DIRECTORY
    #define MODULES_DIRECTORY modules
#endif

class GRAD_Loadout {
    class General {
        file = MODULES_DIRECTORY\grad-loadout\functions\general;
        class ApplyLoadout {};
        class AssignRespawn {
          postInit = 1;
        };
        class DoLoadout {};
        class ExtractLoadoutFromConfig {};
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
    };
};
