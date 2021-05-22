import Foundation


/**
 `2 Rethrowing An Error` : PART 2 OF 2
 So ,
 instead of the `throws` keyword on the outer function ,
 we are going to change this to `rethrows` :
 */

extension Int {
    
    func apply(value: Int ,
               _ operation: (Int , Int) throws -> Int)
    rethrows -> Int {
        
        return try operation(self , value)
    }
}

/**
 And now ,
 everything magically works .
 */

// CLOSURE EXPRESSION Longform :
10.apply(value : 12) { (a: Int , b: Int) -> Int in
    
    return a + b
}

// CLOSURE EXPRESSION Shortform :
10.apply(value : 12) { $0 + $1 }

/**
 What just happened ?
 `rethrows` is a pretty special keyword
 that you can use
 in conjunction with closures that can `throw` errors .
 The `rethrows` keyword indicates to the compiler
 that the outer function
 — `apply()` in our case —
 becomes a throwing function
 only if the closure passed in
 throws an error that is propagated to the current scope .
 
 (`1`) In the first case ,
 
 `extension Int {`
 

     `func apply(value: Int ,`
                `_ operation: (Int , Int) throws -> Int)`
     `throws -> Int {`

         `return try operation(self , value)`
     `}`
 `}`
 
 since the `closure expression` does throw an error ,
 — which we have indicated with this line of code —
 
 `_ operation: (Int , Int) throws -> Int)`
 
 then `apply()`
 — in our case — the outer function
 becomes a throwing function .
 
 `func apply(value:) throws -> Int { ... }`
 
 The outer function propagates this error
 and becomes a throwing function itself .
 
 
 (`2`) But in the second case ,
 
 `extension Int {`
 
 
    `func apply(value: Int ,`
               `_ operation: (Int , Int) throws -> Int)`
    `rethrows -> Int {`
 
        `return try operation(self , value)`
    `}`
 `}`
 
 since no errors are thrown in the inner function ,
 the outer function —`apply()` — is not a throwing one .
 This way we only need to use `try` on our `apply()` function
 if the closure throws an error .
 Now ,
 this brings up an interesting point .
 If a function argument is marked as throwing ,
 _how come we can pass in a regular non throwing closure ?_
 For example ,
 `apply()` takes a closure that is a throwing closure .
 But here , ...
 
 `10.apply(value : 12) { $0 + $1 }`
 
 ... this is a non throwing closure .
 
 _How is that possible ?_
 
 Regular functions
 are subtypes
 of throwing functions
 with the same signature .
 That means
 that given these two functions :
 
 `func someFunction(a: Int) throws {}`
 
 `func anotherFunction(a: Int) {}`
 
 Over here ,
 you can use `anotherFunction()`
 wherever `someFunction()` is expected ,
 because `anotherFunction()` is a subtype of `someFunction()` .
 This means that the function signature is identical
 minus the `throws` bit .
 However ,
 you cannot use `someFunction()`
 where `anotherFunction()` is expected .
 
 
 
 Okay ,
 now that we know
 how to write our own closures
 that can throw errors ,
 let's talk about memory considerations with closures .
 */
/**
 `ASIDE` :
 Remember when we learned about `map()` and `flatMap()` ?
 I mentioned that our function signature wasn't how the Standard Library function was written .
 Well , if I just write out some code to get that `map()` function on screen :
 */

// CLOSURE EXPRESSION Longform :
let mapLongform = [1 , 2 , 4 , 8].map { (number: Int) in
    
    return number * 10
}

// CLOSURE EXPRESSION Shorthand :
let mapShortform = [1 , 2 , 4 , 8].map { $0 * 10 }


print("map Long form : \(mapLongform)")
print("map Short form : \(mapShortform)")

/**
 If I OPTION click on `map` in order to go to the function signature ,
 
 `func map<T>(_ transform: (Int) throws -> T) rethrows -> [T]`
 
 you see that it is marked in the same way .
 The inner transform function
 is a throwing function ,
 
 `transform: (Int) throws -> T`
 
 so we can throw an error and then `map()` `rethrows` .
 So , if our closure — `transform` — that we use as a transformation function
 throws an error ,
 then `map()` itself is a throwing function .
 Otherwise , it is not .
 */
