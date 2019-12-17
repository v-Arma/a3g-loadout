# Configuration
You can configure GRAD Loadout by adding the `Loadouts` class to your `description.ext`. This is entirely optional, as all parameters have default values.

## Parameters

Parameter                   | Default Value | Description
----------------------------|---------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
baseDelay                   | 10            | Number - Base delay in seconds after mission start before loadout is applied.
perPlayerDelay              | 1             | Number - A random delay between 0 and `(number of players) * perPlayerDelay` is added to `baseDelay`.
handleRadios                | 0             | 0/1 - Sets if loadouts will contain radios. Set this to 0 if you plan on using TFAR's automatic radio distribution for example.
resetLoadout                | 0             | 0/1 - Sets if a unit's default loadout will be cleared before GRAD Loadout is applied. Set this to 0 if you plan to only replace a factions uniforms for example.
randomizationMode           | 1             | 0/1/2/3 - Sets randomization mode (if [supported by loadout](creatingLoadouts.md#Randomization)). 0 to disable, 1 to enable, 2 to enable for players only, 3 to enable for AI only.
customGear                  | 300           | Number or Statement - See [customGear](customGear.md) for more info. Condition for `customGear` interaction. Set to -1 to disable `customGear`.
customGearAllowedCategories | all supported | Array of strings - See [customGear](customGear.md) for more info. Sets allowed categories that can be customized with `customGear`.

## Example

```sqf
class Loadouts {
    baseDelay = 10;
    perPlayerDelay = 1;
    handleRadios = 0;
    resetLoadout = 1;
    randomizationMode = 1;
    customGear = 300;
    customGearAllowedCategories[] = {"uniform","vest"};
};
```
