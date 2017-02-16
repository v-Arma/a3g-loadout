
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

var useListNMacro = true;

var depth = 0;

export function unitLoadoutToGradLoadout(inputArray: Array<any>) {

    var loadout: Loadout = {};
    
    assign(loadout, 
        augmentWeapon('primaryWeapon', inputArray[0]),
        augmentWeapon('secondaryWeapon', inputArray[1]),
        augmentWeapon('handgunWeapon', inputArray[2])
    );

    loadout.uniform = inputArray[3][0] || "";
    if (loadout.uniform) {
        loadout.addItemsToUniform = transformContainerContents(inputArray[3][1]);
    }
    loadout.vest = inputArray[4][0] || "";
    if (loadout.vest) {
        loadout.addItemsToVest = transformContainerContents(inputArray[4][1]);
    }
    loadout.backpack = inputArray[5][0] || "";
    if (loadout.backpack) {
        loadout.addItemsToBackpack = transformContainerContents(inputArray[5][1]);
    }
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

    let out = stringifyToConfig('', loadout);

    if (useListNMacro) {
        out = out.replace(/"LIST_(\d+)\(\\"([^\)]+)\\"\)"/g, 'LIST_$1("$2")');
    }

    return out;
}

function transformContainerContents(contents: Array<string|Array<string>>): Array<string> {
    const result = [];

    contents.forEach(function (contentItem: string|Array<any>) {
        if (typeof  contentItem === 'string') {
            contentItem = [contentItem, 1];
        }
        if (Array.isArray(contentItem)) {
            if (useListNMacro && contentItem[1] > 1) {
                result.push(asListNExpression(contentItem));
            } else {
                result.push(...expandContents(contentItem));
            }
        }
    });

    return result;
}

function asListNExpression(arr: Array<any>): string {
    let [className, count] = arr;
    if (count > 1) {
        return `LIST_${count}("${className}")`;
    }
}

function expandContents(arr: Array<any>): Array<string> {
    let [classname, count] = arr;
    return new Array(...(new Array(count))).map(() => classname)
}

function cleanupGradLoadoutConfig(loadout: Loadout) {
    Object.getOwnPropertyNames(loadout).forEach(function (key: string) {
        if (loadout[key] === "") {
            delete loadout[key];
        }
    });
}

function stringifyToConfig(name: string, object: Object): string {

    depth += 1;

    let contents = Object.getOwnPropertyNames(object).map(function (key: string): string {
        const subject = object[key];
        if (Array.isArray(subject)) {
            return stringifyArray(key, subject);
        }
        if (subject && typeof subject === 'object') {
            return stringifyToConfig(key, subject);
        }

        if (typeof subject === 'boolean') {
            return stringifyScalar(key, subject ? 1 : 0);
        }
        if (typeof subject === 'string' || typeof subject === 'number') {
            return stringifyScalar(key, subject);
        }

        throw new Error('unexpected value ' + subject);
    });

    depth -= 1;

    return formatClass(name || 'NAME', contents.join('\n'));
}

interface Formatter {
    (name: string, subject: any): string;
}

function addIndentationDecorator(fn: Formatter): Formatter {
    const maxIndent = (new Array(...(new Array(10)))).map(() => '\t').join('');
    return function (name: string, subject: any): string {
        return maxIndent.substr(0, depth) + fn.apply(this, arguments);
    };
}

let stringifyScalar = addIndentationDecorator(function stringifyScalar(name: string, value: number|string): string {
    const valAsString = JSON.stringify(value);
    return `${name} = ${valAsString};`;
});

let stringifyArray = addIndentationDecorator(function (name: string, arr: Array<any>) {
    return JSON.stringify(arr).replace(/^\[(.*)]$/, `${name}[] = {$1};`);
});

let formatClass = addIndentationDecorator(function (name: string, contents: string) {
    return `class ${name} {\n${contents}\n};\n`;
});
