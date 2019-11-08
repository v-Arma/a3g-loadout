#include "component.hpp"

["grad-loadout", {
    params ["_command"];

    switch (_command) do {
        case ("viewer"): {
            [] call FUNC(loadoutViewer);
        };
        case ("verify"): {
            [] spawn FUNC(verifyLoadouts);
        };
    };
},"admin"] call CBA_fnc_registerChatCommand;
