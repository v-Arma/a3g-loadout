#include "component.hpp"

private _configPath = missionConfigFile >> "Loadouts";

if (GRAD_Loadout_Chosen_Prefix != "") then {
    _configPath = _configPath >> GRAD_Loadout_Chosen_Prefix;
};

_configPath
