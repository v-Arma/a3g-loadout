#ifndef MODULES_DIRECTORY
    #define MODULES_DIRECTORY modules
#endif

#define PROJECT_NAME grad-loadout

class A3G_Loadout {
    class General {
        file = MODULES_DIRECTORY\PROJECT_NAME\functions\general;
        class ApplyLoadout {};
        class AssignRespawn {
          postInit = 1;
        };
        class DoLoadout {};
        class ExtractLoadoutFromConfig {};
        class GetApplicableUnits {};
        class GetUnitLoadoutFromConfig {};
        class HashToUnitLoadout {};
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
