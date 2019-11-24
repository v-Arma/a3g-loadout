# Installation

You should know what the `description.ext` (aka *missionconfig*) is. If you don't, you can read about it [here](https://community.bistudio.com/wiki/Description.ext).

## Dependencies

* [CBA_A3](https://github.com/CBATeam/CBA_A3/releases)
* [ACE3](https://github.com/acemod/ACE3/releases), specifically the `ace_interact_menu` component, is required if you want to use [customGear](customGear.md)

## Installing Manually

1. Create a folder in your mission root folder and name it `modules`. Then create one inside there and call it `grad-loadout`. If you want change the containing directory name you will have to adjust the MODULES_DIRECTORY definition, see [Configuration](configuration.md)
2. Download the contents of this repository (there's a download link in the sidebar) and put it into the directory you just created.
3. Append the following lines of code to the `description.ext`:

```sqf
class CfgFunctions {
  #include "modules\grad-loadout\CfgFunctions.hpp"
};
```

## Installing Via npm

*For details about what npm is and how to use it, look it up on [npmjs.com](https://www.npmjs.com/).*

1. Install package `grad-loadout` : `npm install --save grad-loadout`
2. Prepend your mission's `description.ext` with `#define MODULES_DIRECTORY node_modules`
3. Append the following lines of code to the `description.ext`:

```sqf
class CfgFunctions {
  #include "node_modules\grad-loadout\CfgFunctions.hpp"
};
```
