params ["_configValue", "_loadoutTarget"];

{ _loadoutTarget removeItem _x; } forEach items _loadoutTarget;
{ _loadoutTarget addItem _x; } forEach _configValue;
