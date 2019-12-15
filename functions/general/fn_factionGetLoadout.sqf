#include "component.hpp"

params [["_faction",""]];

// return faction as path if no value exists
GVAR(factionPathMap) getVariable [_faction,_faction]
