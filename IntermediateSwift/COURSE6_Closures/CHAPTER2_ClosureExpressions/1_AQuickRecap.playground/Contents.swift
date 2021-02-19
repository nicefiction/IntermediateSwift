import Foundation


/**
 `CHAPTER 2`
 `Closure Expressions`
 Now that we know how to write `higher order functions` ,
 let’s see how this relates to `closures` .
 We’ll look at
 how to write a standard closure ,
 as well as some of the closure expression syntax
 that makes using closures a lot easier .
 */


/**
 `1 A Quick Recap`
 INTRO — We covered a decent amount of new concepts in the last few videos ,
 so before we learn about closure expressions ,
 let's make sure we know our stuff .
 */
/**
 Welcome back , we went over a lot of new stuff in the last stage ,
 so let's recap for a bit :
 
 `RECAP`
 
 (`1`) Functions are first class citizens .
 (`2`) Assign functions to constants .
 (`3`) Functions as _inputs_ to other functions .
 (`4`) Functions as _return values_ from other functions .
 
 (`1`) We learned that functions are first class citizens .
 _What does this mean ?_
 Well , it means that functions can be treated
 much the same way as we treat integers , strings , or any other first class type .
 We learned (`2`) that we can assign a function to a constant , and pass it around ,
 you can then refer to the function using the constant name rather than the function itself .
 The next important thing was that (`3`) a function can accept another function as input
 much like it can accept an Integer or a String .
 Not only can functions accept strings as inputs ,
 (`4`) it can also return a function .
 
 We use these concepts to build `higher order functions` .
 
 Finally , (`5`) we learned how to write a nested function
 that can capture or close over variables ,
 or constants from the surrounding context .
 Doing this forms what is known as a `closure` .
 So , let’s solidify our definition ,
 a closure is
 a combination of
 a function
 and an environment of captured variables .
 Closures are equivalent to
 anonymous functions , lambdas , and blocks in other languages .
 
 Before we look at why closures are useful
 let's start with how we can write a closure .
 The first way
 — which happens to be the longer way —
 is what we covered in the last video :
 */

typealias IntegerFunction = (Int) -> (Void)



func gameCounter()
-> IntegerFunction {
    
    var localCounter: Int = 0
    
    
    func increment(_ i: Int) {
        
        localCounter += i
        
        print("The value of the loacal counter is \(localCounter) .")
    }
    
    
    return increment
}



let counter = gameCounter()
counter(1)
counter(3)
counter(5)


/**
 You start by writing a function
 that contains an environment of capture variables
 and then assign it to a constant .
 This is what you are familiar with ,
 we just went through how to do it .
 The second way is
 to write a `closure expression` .
 While closure and closure expressions are actually different implementations ,
 it is common to refer to both these styles with the term `closure` .
 I'll be specific for now , but in future courses — when I or anyone else says `closure` —
 we are going to use the term interchangeably with a `closure expression` .
 A `closure expression syntax` has the following general form :

 `{ (parameters) -> return type in`
    `statements`
 `}`
 
 We start with a set of braces to define the closure expression .
 Inside the braces ,
 first we include the parameters in a set of parentheses
 followed by an arrow and the return type .
 This defines the `type of the closure` .
 
 `(parameters) -> return type`
 
 To start the `body of the closure` ,
 we write the keyword `in` and then write our `statements` .
 A lot easier , right ?
 Let's look at an example .
 The Swift Standard Library contains a really useful function on arrays , named `map` .
 The `map()` function accepts a function and returns a new array
 after performing the methods of the function on each member of the array .
 As always , this is easier to understand with an example .
 We start by rewriting that `double()` function we wrote earlier ,
 */

func double(_ value: Int)
-> Int {
    
    return value * 2
}

/**
 We assign this to a constant ,
 */

let doubleFunction = double

/**
 We test if this works by passing in an argument to the `double()` function ,
 */

double(2) // returns 4

/**
 Okay now — given an array of integers —
 */

let numbers: [Int] = [
    1 , 2 , 3 , 4
]

/**
 I want a new array
 containing each of those values doubled .
 I can do this using the `map()` function ,
 and passing in the `double()` function as an argument .
 For now , all you need to know about `map()` , is ,
 that it takes each value out of the numbers array ,
 and allows us to work with each value . So , we can say
 */

let doubleNumbers = numbers.map(doubleFunction) // returns [2 , 4 , 6 , 8]

/**
 We now have a new array containing double the original values .
 If you are wondering how this is a `closure` ,
 keep in mind that the `map()` function forms the outer function .
 And the inner function , that is the `doubleFunction` ,
 captures the variables defined in the `map()` context .
 Other than what `map()` does
 — which we are going to ignore for just a small bit —
 there isn't anything really new going on here .
 `map()` takes a function
 while passing in the `doubleFunction` as argument .
 All of this was a bit cumbersome though :
 ( 1 ) we had to declare a function ,
 
 `func double(_ value: Int)`
 `-> Int {`
 
    `return value * 2`
 `}`
 
 ( 2 ) assign it to a constant ,
 
 `let doubleFunction = double`
 
 ( 3 ) pass that constant to another function as an argument.
 
 `let doubleNumbers = numbers.map(doubleFunction)`
 
 So in the next video ,
 let's take a look at
 how closure expressions makes this much nicer to deal with .
 */
