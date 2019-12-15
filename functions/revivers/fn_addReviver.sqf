#include "component.hpp"

params [["_callBack",{}],["_propertyName",""],["_global",false]];

private _pRevivers = GVAR(revivers) getVariable [_propertyName,[]];

_pRevivers pushBack _callback;
GVAR(revivers) setVariable [_propertyName,_pRevivers,_global];
