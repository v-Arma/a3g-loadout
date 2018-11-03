#ifndef MODULES_DIRECTORY
    #define MODULES_DIRECTORY modules
#endif

class GRAD_Loadout {
    class Api {
        file = MODULES_DIRECTORY\grad-loadout\functions\api;
        class doLoadoutForUnit {};
        class loadoutViewer {};
        class verifyLoadouts {};
    };
    class Defactionizers {
        file = MODULES_DIRECTORY\grad-loadout\functions\defactionizers;
        class vanillaCivDefactionizer {};
        class vanillaMilitaryDefactionizer {};
    };
    class Extract {
        file = MODULES_DIRECTORY\grad-loadout\functions\extract;
        class getPathExtractor {};
        class extractLoadoutFromConfig {};
    };
    class General {
        file = MODULES_DIRECTORY\grad-loadout\functions\general;
        class addChatCommands {postInit = 1;};
        class applyLoadout {};
        class assignRespawn {postInit = 1;};
        class defactionizeType {};
        class doLoadout {};
        class factionGetLoadout {};
        class factionSetLoadout {};
        class getApplicableUnits {};
        class getLoadoutConfigPath {};
        class getUnusedConfigs {};
        class getUnitLoadoutFromConfig {};
        class hashToUnitLoadout {};
        class initGlobals {preinit = 1;};
        class mergeLoadoutHierarchy {};
        class normalizeContent {};
        class removeRadios {preinit = 1;};
        class scheduleLoadout {postInit = 1;};
        class weaponIsCompatibleMagazine {};
    };
    class Revivers {
        file = MODULES_DIRECTORY\grad-loadout\functions\revivers;
        class getRevivers {};
        class addReviver {};
        class applyRevivers {};
    };
};
