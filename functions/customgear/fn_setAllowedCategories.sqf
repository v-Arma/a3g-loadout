#include "component.hpp"

params [["_unit", objNull], ["_allowedCategories", []]];

_unit setVariable [QGVAR(customGearAllowedCategories), _allowedCategories, true];
