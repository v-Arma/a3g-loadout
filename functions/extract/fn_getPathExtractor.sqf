#include "component.hpp"

params ["_unit", "_loadoutHierarchy"];

#ifdef DEBUG_MODE_FULL
    assert (_unit in allUnits);
    assert (typeName _loadoutHierarchy == "ARRAY");
#endif

{
    params ["_path", "_discriminator"];

    if (isClass(_path) && ([_unit] call _discriminator)) then {
        TRACE_2("adding values from %1 to %2", _path, _unit);
        _loadoutHierarchy pushBack ([_path] call FUNC(ExtractLoadoutFromConfig));
    };
};
