"use strict";
exports.__esModule = true;
var message = 'Welcome back';
console.log(message);
var x = 10;
var y = 20;
x = 30;
// The basic types in Typescript are string, number, and boolean.
var total = 0;
var name = 'Jared';
var isBegineer = true;
// Template literals
var sentence = "My name is " + name + "\nI am a beginner in Typescript";
// The first nice thing about Typescript is getting type errors while typing
// If I try to set name to true, I'll get an error immediately
// name = true // Type 'true' is not assignable to type 'string' 
// The second nice thing about Typescript is having intellisense in your text editor
// Start typing `total` and you will get all of the Number methods, since `total` is a number
// There are two more types in Typescript: null and undefined
// You can set variables to be null or undefined in Typescript
var isNew = null;
var myName = undefined;
// Arrays: two different syntaxes
var list1 = [1, 2, 3];
var list2 = [1, 2, 3];
// Tuples: when an array contains multiple types
var person1 = ['Chris', 22];
// Errors:
// let personError: [string, number] = ['Chris', 23, 35]
// let anotherError: [string, number] = [22, 'Chris']
// Enums
var Color;
(function (Color) {
    Color[Color["Red"] = 0] = "Red";
    Color[Color["Green"] = 1] = "Green";
    Color[Color["Blue"] = 2] = "Blue";
})(Color || (Color = {}));
var c = Color.Green;
// Unless the enum value is specified, it refers to the index in the enum
console.log(c); // => 1 
var MoreColors;
(function (MoreColors) {
    MoreColors[MoreColors["Red"] = 5] = "Red";
    MoreColors[MoreColors["Green"] = 3] = "Green";
    MoreColors[MoreColors["Blue"] = 2] = "Blue";
})(MoreColors || (MoreColors = {}));
var col = MoreColors.Green;
console.log(col); // => 3
// Any type: encompasses values of any possible type
var randomValue = 10;
randomValue = true;
randomValue = 'Hello';
randomValue();
randomValue.toUpperCase();
// Unknown Types
// When using 'any', Typescript will not throw an error on any of the above statements.
// To prevent this issue, Typescript has the 'unknown' type in 3.0
