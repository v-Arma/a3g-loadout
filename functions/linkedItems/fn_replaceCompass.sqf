params ["_configValue", "_loadoutTarget"];

if(_configValue == "") then {
    _loadoutTarget unlinkItem "ItemCompass";
} else {
    _loadoutTarget linkItem _configValue;
};
