import {unitLoadoutToGradLoadout} from './unitLoadoutToGradLoadout';
declare function require(module: string): any;
declare var process: any;

var readline = require('readline');
// var unitLoadoutToGradLoadout = require('unitLoadoutToGradLoadout').unitLoadoutToGradLoadout;
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

    let out = unitLoadoutToGradLoadout(inputArray);
    
    process.stdout.write(out + "\n");
});