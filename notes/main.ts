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
randomValue.toUpperCase()

// Unknown Types
// When using 'any', Typescript will not throw an error on any of the above statements.
// To prevent this issue, Typescript has the 'unknown' type in 3.0



