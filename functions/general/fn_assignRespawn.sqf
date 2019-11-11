#include "component.hpp"

if ( isDedicated ) exitWith {};

player addEventHandler ["Respawn", FUNC(ApplyLoadout)];
