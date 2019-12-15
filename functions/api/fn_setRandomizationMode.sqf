#include "component.hpp"

params [["_unit", objNull], ["_randomization", 0, [0]]];

_unit setVariable [QGVAR(randomizationMode), _randomization, true];
