import Foundation


/**
 `2 Rethrowing An Error` : PART 1 OF 2
 INTRO — Throwing closures allow us to throw errors
 but we can't mark all of them as throwing .
 In this video ,
 let's look at a limitation we introduced in the code we just wrote
 and how we go about solving it .
 */
/**
 We seemingly solved the problem of building a function
 that accepts a closure
 that can throw an error .
 */

extension Int {

    func apply(value: Int ,
               _ operation: (Int , Int) throws -> Int)
    throws -> Int {

        return try operation(self , value)
    }
}


enum OperatorError: Error {
    
    case undivisableByZero(errorMessage: String)
}
    
    
do {
    // try 10.apply(value : 0) { (a: Int , b: Int) -> Int in
    try 10.apply(value : 0) {
        
        if $1 == 0 {
            throw OperatorError.undivisableByZero(errorMessage : "\($0) is not divisble by 0")
        } else {
            return $0 / $1
        }
    }
    
} catch OperatorError.undivisableByZero(let message) {
    print(message)
}

/**
 There is a hidden catch however .
 So , right after this code ,
 let's use our `apply()` function again :
 */

/*
10.apply(value : 12) { (a: Int , b: Int) throws -> Int in
    
    return a + b
} // ERROR : Call can throw but is not marked with 'try' .
 */

/**
 Here I am trying to add `10` to `12` .
 There is absolutely no way ,
 no possible way ,
 that this can go wrong .
 But the compiler wants us to use the` try` statement
 and handle potential errors .
 Because we have marked the outer function `apply()`
 as a throwing one ,

 `func apply(value: Int ,`
            `_ operation: (Int , Int) throws -> Int)`
 `throws -> Int { ... }`
 
 That means
 that even if there is no chance
 that there is going to be an error ,
 we need to go through `do` ,` try` , and `catch`
 because of the way we have written our code .
 And thankfully , that is not how it is done .
 */
/**
👉 Continues in PART 2
*/
