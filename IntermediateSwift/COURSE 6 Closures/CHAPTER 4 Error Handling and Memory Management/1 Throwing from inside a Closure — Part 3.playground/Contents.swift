import Foundation


/**
 `1 Throwing From Inside A Closure`: PART 3 OF 3
 One way I can improve my code , is ,
 by seeing that the `apply() function` is a `throwing function` as well .
 Now , I can change all this to :
 */

enum MathError: Error {
    
    case dividedByZero
}


extension Int {
    
    func apply(value: Int ,
               _ operation: (Int , Int) throws -> Int)
    throws -> Int {
        
        return try operation(self , value)
    }
}

/**
 I can change the body of the function
 to `return try operation` on `self` and `value` .
 This way , if the `operation` succeeds
 then we get a value back .
 Otherwise , we propagate the error to the call site .
 So , let's get rid of this code
 
 `// CLOSURE EXPRESSION : Shortform`
 `// 10.apply(value : 12) { $0 + $1 } // returns 22`


 `// CLOSURE EXPRESSION : Longform`
 `// 10.apply(value: 12) { (a: Int ,`
 `//                      b: Int) -> Int in`
     
 `//    return a + b`
 `// } // returns 22`
 
 and see how the addition of a second `throws` helped .
 Can we solve the problem of this coworker who is trying to break our code ?
 So now that we have the second `throws`
 instead of just failing ,
 we can use the typical error handling mechanisms at the call site
 to `throw` an error from within the `closure` .
 So , we’ll define an error ,
 
 `enum MathError: Error {`
 
    `case dividedByZero`
 `}`
 
 We can use this now in a closure .
 We can say ,
 */

do {
    try 10.apply(value: 0) {
        
        if $1 == 0 {
            throw MathError.dividedByZero
        } else {
            return $0 / $1
        }
    }

} catch MathError.dividedByZero {
    print("You cannot divide by zero .")
}

/**
 We use a `trailing closure` here .
 Below , at the end of the `do statement` ,
 we include our `catch` statement .
 And we catch on that specific error we defined earlier .
 And we just print an error message .
 As you can see now in the console ,
 */

// Prints You cannot divide by zero .

/**
 it prints the error message .
    Using the `try` keyword
 because our new version of `apply()` can `throw` ,
 
 `func apply(value: Int ,`
            `_ operation: (Int , Int) throws -> Int)`
 `throws -> Int { ... }`
 
 we can pass in a closure
 and from within the closure
 
 `operation: (Int , Int) throws -> Int`
 
 we can throw the error .
 Because the outer `apply()` function
 then simply propagates that error
 up one level
 — `operation: (Int , Int) throws -> Int`.
 We can catch that error
 outside of this `do block`
 and do something with it .
    Okay , so problem number one
 of how to write a closure
 that can throw
 seems somewhat solved .
 Now ,
 like with normal error handling ,
 we can put this inside the `do clause` as we have just done ,
 use a `catch` statement
 and catch on that specific error .
 This you should be familiar with .
 But there is a bit of a subtlety here
 and we'll check that out in the next video .
 */
