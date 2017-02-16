"use strict";
function assign(target) {
    var sources = [];
    for (var _i = 1; _i < arguments.length; _i++) {
        sources[_i - 1] = arguments[_i];
    }
    sources.forEach(function (source) {
        Object.getOwnPropertyNames(source).forEach(function (key) {
            target[key] = source[key];
        });
    });
}
function augmentWeapon(weaponName, weaponArray) {
    var result = {};
    result[weaponName] = weaponArray[0] || "";
    result[weaponName + 'Muzzle'] = weaponArray[1] || "";
    result[weaponName + 'Pointer'] = weaponArray[2] || "";
    result[weaponName + 'Optics'] = weaponArray[3] || "";
    result[weaponName + 'Underbarrel'] = weaponArray[6] || "";
    return result;
}
var useListNMacro = true;
var depth = 0;
function unitLoadoutToGradLoadout(inputArray) {
    var loadout = {};
    assign(loadout, augmentWeapon('primaryWeapon', inputArray[0]), augmentWeapon('secondaryWeapon', inputArray[1]), augmentWeapon('handgunWeapon', inputArray[2]));
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
    var out = stringifyToConfig('', loadout);
    if (useListNMacro) {
        out = out.replace(/"LIST_(\d+)\(\\"([^\)]+)\\"\)"/g, 'LIST_$1("$2")');
    }
    return out;
}
exports.unitLoadoutToGradLoadout = unitLoadoutToGradLoadout;
function transformContainerContents(contents) {
    var result = [];
    contents.forEach(function (contentItem) {
        if (typeof contentItem === 'string') {
            contentItem = [contentItem, 1];
        }
        if (Array.isArray(contentItem)) {
            if (useListNMacro && contentItem[1] > 1) {
                result.push(asListNExpression(contentItem));
            }
            else {
                result.push.apply(result, expandContents(contentItem));
            }
        }
    });
    return result;
}
function asListNExpression(arr) {
    var className = arr[0], count = arr[1];
    if (count > 1) {
        return "LIST_" + count + "(\"" + className + "\")";
    }
}
function expandContents(arr) {
    var classname = arr[0], count = arr[1];
    return new (Array.bind.apply(Array, [void 0].concat((new Array(count)))))().map(function () { return classname; });
}
function cleanupGradLoadoutConfig(loadout) {
    Object.getOwnPropertyNames(loadout).forEach(function (key) {
        if (loadout[key] === "") {
            delete loadout[key];
        }
    });
}
function stringifyToConfig(name, object) {
    depth += 1;
    var contents = Object.getOwnPropertyNames(object).map(function (key) {
        var subject = object[key];
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
function addIndentationDecorator(fn) {
    var maxIndent = (new (Array.bind.apply(Array, [void 0].concat((new Array(10)))))()).map(function () { return '\t'; }).join('');
    return function (name, subject) {
        return maxIndent.substr(0, depth) + fn.apply(this, arguments);
    };
}
var stringifyScalar = addIndentationDecorator(function stringifyScalar(name, value) {
    var valAsString = JSON.stringify(value);
    return name + " = " + valAsString + ";";
});
var stringifyArray = addIndentationDecorator(function (name, arr) {
    return JSON.stringify(arr).replace(/^\[(.*)]$/, name + "[] = {$1};");
});
var formatClass = addIndentationDecorator(function (name, contents) {
    return "class " + name + " {\n" + contents + "\n};\n";
});
//# sourceMappingURL=unitLoadoutToGradLoadout.js.map