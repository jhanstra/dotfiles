// use export {} to make this file a module rather than a script
export {}
let message = 'Welcome back'
console.log(message)

let x = 10
const y = 20

x = 30

// The basic types in Typescript are string, number, and boolean.
let total: number = 0
let name: string = 'Jared'
let isBegineer: boolean = true

// Template literals
let sentence: string = `My name is ${name}
I am a beginner in Typescript`

// The first nice thing about Typescript is getting type errors while typing
// If I try to set name to true, I'll get an error immediately
// name = true // Type 'true' is not assignable to type 'string' 

// The second nice thing about Typescript is having intellisense in your text editor
// Start typing `total` and you will get all of the Number methods, since `total` is a number

// There are two more types in Typescript: null and undefined
// You can set variables to be null or undefined in Typescript
let isNew: boolean = null
let myName: string = undefined

// Arrays: two different syntaxes
let list1: number[] = [1, 2, 3]
let list2: Array<number> = [1, 2, 3]

// Tuples: when an array contains multiple types
let person1: [string, number] = ['Chris', 22]

// Errors:
// let personError: [string, number] = ['Chris', 23, 35]
// let anotherError: [string, number] = [22, 'Chris']

// Enums
enum Color { Red, Green, Blue}
let c: Color = Color.Green
// Unless the enum value is specified, it refers to the index in the enum
console.log(c) // => 1 

enum MoreColors { Red = 5, Green = 3, Blue = 2 }
let col: MoreColors = MoreColors.Green
console.log(col) // => 3

// Any type: encompasses values of any possible type
let randomValue: any = 10
randomValue = true
randomValue = 'Hello'
randomValue()
randomValue.toUpperCase();

// Unknown Types
// When using 'any', Typescript will not throw an error on any of the above statements.
// To prevent this issue, Typescript has the 'unknown' type in 3.0

let myVariable: unknown = 0; // note: you need the semi-colon here because the next line is a (
// console.log(myVariable.name) => error
// myVariable() => error
(myVariable as string).toUpperCase() // notice that parens used here

// no types used here so this is fine
let a
a = 10
a = true

// but when you initialy set a type on a variable, typescript will infer the type from it and 
// yell at you when you reassign
let b = 20
// b = true => error

// Unions
let multiType: number | boolean
multiType = 20 // no error
multiType = false // no error
// multiType = 'Jared' // error

// Unions still support intellisense

// Functions
function add(num1: number, num2: number) {
  return num1 + num2
}
add(5, '10')

