
#define PREFIX grad
#define COMPONENT loadout
#include "\x\cba\addons\main\script_macros_mission.hpp"

if ( isDedicated ) exitWith {};

player addEventHandler ["Respawn", FUNC(ApplyLoadout)];
