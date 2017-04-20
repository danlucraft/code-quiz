require("./roman.js")
var readline = require('readline');

var rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout,
    terminal: false
});

rl.on('line', function(line) {
    var md = line.match(/^(\d+)/)
    var thing = line
    if (md) {
        thing = parseInt(md[0])
    }
    console.log(convertRoman(thing))
});