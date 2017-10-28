
#define PREFIX grad
#define COMPONENT loadout
#include "\x\cba\addons\main\script_macros_mission.hpp"

private _unit = param [0];
private _loadoutHierarchy = param [1];


#ifdef DEBUG_MODE_FULL
    assert (_unit in allUnits);
    assert (typeName _loadoutHierarchy == "ARRAY");
#endif

{
    private _path = param [0];
    private _discriminator = param [1];
    if (isClass(_path) && ([_unit] call _discriminator)) then {
        TRACE_2("adding values from %1 to %2", _path, _unit);
        _loadoutHierarchy pushBack ([_path] call FUNC(ExtractLoadoutFromConfig));
    };
};
