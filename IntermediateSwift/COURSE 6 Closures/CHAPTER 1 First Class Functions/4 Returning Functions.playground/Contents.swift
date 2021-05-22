import Foundation


/**
 `4 Returning Functions`
 INTRO — In addition to accepting a function as an input ,
 functions can also return other functions as output .
 Let's see how we can define a function as the return type for another function .
 */
/**
 We have learned a lot of new concepts so far
 about _functions being first class citizens_ :
 (`1`) We now know that functions can be assigned to variables , or constants .
 (`2`) We know that we can accept functions as inputs to other functions
 — just like integers , strings , and so on .
 And finally , (`3`) we can use these two concepts to build `higher order functions` .
 There is one more concept we need to learn ,
 and that is (`4`) capturing variables .
 In the last video ,
 you have seen how functions can accept functions as arguments .
 Similarly , a function can also return another function .
 Let's define a new function ,
 */

/*
func gameCounter()
-> (Int) -> Void {}
*/

/**
 The `gameCounter()` function is not going to take any parameters ,
 but it is going to return another function .
 Just like we indicate a function as a parameter type ,
 we indicate a function as a return type by writing out the function signature .
 So here we want to return a function that takes an `Int` as a parameter and returns `Void` .
 So , that function that we are returning has a signature of `Int to Void` .
 So , that function goes from `Int to Void` .
 
 `NOTICE` that this function can be a little hard to read
 because we have one function
 that returns another function .
 So , think of this as one entity rather then — you know —
 it is confusing because there are two arrows here .
 
 `func gameCounter()`
 `-> (Int) -> Void { ... }`
 
 One way you can make this easier to read if you find it confusing , is ,
 by defining a `typealias` :
 */

typealias IntegerFunction = (Int) -> Void

/*
func gameCounter()
-> IntegerFunction { ... }
*/

/**
 Inside `gameCounter()` ,
 let’s define an `increment()` function
 that matches our return type :
 */

func gameCounter()
-> IntegerFunction {
    
    func increment(_ i: Int) {
        
        print("Integer passed in : \(i)")
    }
    
    
    return increment
}

/**
 Remember
 we need to accept an integer ,
 and it needs to return `Void` .
 So , no return this time ,
 
 `func increment(_ i: Int) {`
 
    `print("Integer passed in : \(i)")`
 `}`
 
 and that is it .
 At the bottom of this — outside of the `increment()` function definition ,
 but still inside the `gameCounter()` function —
 we need to return something as part of the contract — or the signature — of `gameCounter` .
 So , we can return the `increment()` function .
 
 `return increment`
 
 If we move out of the `gameCounter()` function ,
 and declare a new constant ,
 */

// let counter = gameCounter // results area : () -> (Int) -> ()

/**
 if we assign `gameCounter`
 — which is the function we just defined —
 to the constant ,
 you will notice in the results area
 that the type of the constant `counter` is
 a function that doesn't take any arguments
 and — on its own — returns another function ,
 
 `() -> (Int) -> ()`
 
 It is a bit confusing .
 Okay . So now ,
 let’s say I wanted to print out an integer value
 using the `print()` statement that is
 inside the `increment()` function
 inside the `gameCounter()` function ,
 
 `func gameCounter()`
 `-> IntegerFunction {`
 
    `func increment(_ i: Int) {`
 
        `print("Integer passed in : \(i)")`
    `}`
 
 
    `return increment`
 `}`

 If I tried to call `counter` and pass `1` — like we have been doing all along — , ...
 */

// counter1(1) // ERROR : Argument passed to call that takes no arguments .

/**
 ... this won't work .
 And this is because `counter` now is a function
 — as you can see here ( OLIVIER : in the results area of the Playgound ) —
 
 `let counter = gameCounter // results area : () -> (Int) -> ()`
 
 that doesn't accept any parameters ,
 but it does return a function that accepts one .
 So instead of assigning `gameCounter` to `counter` ,
 let's assign to `counter`
 the result of calling `gameCounter()`
 */

let counter = gameCounter() // results area : (Int) -> ()

/**
 and when we do that ,
 you see that the function is a bit simpler :
 
 `// results area : (Int) -> ()`

 `counter` is now a function that takes an integer ,
 and does something with it ,
 but doesn't return any value .
 
 _I promise you there is a point to all this ._
 
 Because `counter` now accepts an integer ,
 our next line of code ...
 */

counter(1)

/**
 ... compiles just fine  ,
 and in our console
 you have a print statement :
 
 `Integer passed in : 1`
 
 So , we call `gameCounter()` here ,
 
 `let counter = gameCounter()`
 
 `gameCounter()` returns `increment` ,
 
 `func gameCounter()`
 `-> IntegerFunction {`
 
    `func increment(_ i: Int) {`
 
        `print("Integer passed in : \(i)")`
    `}`
 
 
    `return increment`
 `}`
 
 so `increment` is now assigned to `counter2`
 
 `let counter = gameCounter()`
 
 and then if we call `counter` and pass in `1`
 
`counter(1)`
 
 that `1` goes to this argument
 
 `func increment(_ i: Int) { ... }`
 
 and it is printed out in this statement
 
 `func increment(_ i: Int) {`
 
    `print("Integer passed in : \(i)")`
 `}`
 
 — which you can see here .
 
 `Integer passed in : 1`
 
 
 
 Now that you know t
 hat we can return a function from another function ,
 let's see how this is used to capture variables in the next video .
 */
