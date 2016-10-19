declare function require(module: string): any;
declare var process: any;

function assign(target: Object, ...sources: Array<Object>) {
    sources.forEach(function (source: Object) {
        Object.getOwnPropertyNames(source).forEach(function (key: string) {
            target[key] = source[key];
        });
    });
}

interface Loadout {
    uniform?: Array<string|Array<any>>;
    backpack?: Array<string|Array<any>>;
    vest?: Array<string|Array<any>>;
    addItemsToUniform?: Array<string|Array<string>>;
    addItemsToVest?: Array<string|Array<string>>;
    addItemsToBackpack?: Array<string|Array<string>>;
    primaryWeapon?: string;
    secondaryWeapon?: string;
    handgunWeapon?: string;
    primaryWeaponMuzzle?: string;
    primaryWeaponOptics?: string;
    primaryWeaponPointer?: string;
    primaryWeaponUnderbarrel?: string;
    secondaryWeaponMuzzle?: string;
    secondaryWeaponOptics?: string;
    secondaryWeaponPointer?: string;
    secondaryWeaponUnderbarrel?: string;
    handgunWeaponMuzzle?: string;
    handgunWeaponOptics?: string;
    handgunWeaponPointer?: string;
    handgunWeaponUnderbarrel?: string;
    headgear?: string;
    goggles?: string;
    nvgoggles?: string;
    binoculars?: string;
    map?: string;
    gps?: string;
    compass?: string;
    watch?: string;
    radio?: string;
}


function augmentWeapon(weaponName: string, weaponArray: Array<any>): Object {

    let result = {};
    result[weaponName] = weaponArray[0] || "";
    result[weaponName + 'Muzzle'] = weaponArray[1] || "";
    result[weaponName + 'Pointer'] = weaponArray[2] || "";
    result[weaponName + 'Optics'] = weaponArray[3] || "";
    result[weaponName + 'Underbarrel'] = weaponArray[6] || "";

    return result;
}

var readline = require('readline');
var rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
  terminal: false
});

var input = [];

rl.on('line', function(line) {
    input.push(line);
});

rl.on('close', function () {
    var inputString: string = input.join('');

    let inputArray: Array<any> = JSON.parse(inputString);

    var loadout: Loadout = {};
    
    assign(loadout, 
        augmentWeapon('primary', inputArray[0]),
        augmentWeapon('secondary', inputArray[0]),
        augmentWeapon('handgun', inputArray[0])
    );

    loadout.uniform = inputArray[3][0] || "";
    loadout.addItemsToUniform =  inputArray[3][1];

    loadout.vest = inputArray[4][0] || "";
    loadout.addItemsToVest = inputArray[4][1];

    loadout.backpack = inputArray[5][0];
    loadout.addItemsToBackpack = inputArray[5][1];

    loadout.headgear = inputArray[6];
    loadout.goggles = inputArray[7];

    loadout.binoculars = inputArray[8][0] || "";

    loadout.map = inputArray[9][0] || "";
    loadout.gps = inputArray[9][1] || "";
    loadout.radio = inputArray[9][2] || "";
    loadout.compass = inputArray[9][3] || "";
    loadout.watch = inputArray[9][4] || "";
    loadout.nvgoggles = inputArray[9][5] || "";

    cleanupGradLoadoutConfig(loadout);

    process.stdout.write(JSON.stringify(loadout, null, '\t'));
});

function cleanupGradLoadoutConfig(loadout: Loadout) {
    Object.getOwnPropertyNames(loadout).forEach(function (key: string) {
        if (loadout[key] === "") {
            delete loadout[key];
        }
    });
}