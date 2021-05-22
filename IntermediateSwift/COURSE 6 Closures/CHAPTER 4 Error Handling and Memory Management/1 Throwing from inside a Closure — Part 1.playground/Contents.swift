import Foundation


/**
 `CHAPTER 3`
 `Error Handling and Memory Management`
 Errors can occur anywhere in code
 and that includes closures .
 The ways in which you handle an error in a closure
 depends on the signature of the closure .
 Over the next few videos ,
 let's explore how we can throw
 and handle errors inside a closure .
 In addition ,
 we are going to spend some time talking about
 memory considerations with closures .
 */


/**
 `1 Throwing From Inside A Closure`: PART 1 OF 3
 INTRO — When we define a closure ,
 we can decide
 whether we want it to throw an error
 or handle it within .
 In this video ,
 let's explore
 how each approach
 depends on the signature of the function .
 */
/**
 We have spent a lot of time talking about closures
 but didn't touch on a very important subject .
 _How do we deal with errors that arise inside a closure or a closure expression ?_
 There are a couple different ways to deal with this
 and it mostly depends on ,
 who wrote that original function to begin with ?
 So , let’s start simple .
 I have a new playground page , and in here ,
 we are going to define
 a different version of our `apply()` function that we wrote earlier :
 */

/*
extension Int {
    
//    func apply(_ operation: (Int) -> Int)
//    -> Int {
//
//        return operation(self)
//    }
    
    func apply(value: Int ,
               _ operation: (Int , Int) -> Int)
    -> Int {
        
        return operation(self , value)
    }
}
 */

/**
 So , this is an `extension` on the `Int` type .
 In the body of the `apply()` function ,
 all we are going to do , is ,
 `return` the result of applying `operation`
 to `self` and the `value` passed in .
 So this time , compared to before ,
 `apply()` takes a `value` that we want to apply in some way
 to the actual integer value — `self`
 since this is an `extension` on the `Int` type .
 `operation` now takes a closure expression
 that takes two integer values
 and returns an `Int` .
 
 `operation: (Int , Int) -> Int)`
 
 So , `apply()`
 returns the result of
 applying the `operation` on
 `self` and this new `value` .
 
 `return operation(self , value)`
 
 Using this function ,
 we can now write simple math operations like this :
 */

/*
// CLOSURE EXPRESSION : Shortform
10.apply(value : 12) { $0 + $1 } // returns 22


// CLOSURE EXPRESSION : Longform
10.apply(value: 12) { (a: Int ,
                       b: Int) -> Int in
    
    return a + b
} // returns 22
 */

/**
 Since this is a `trailing closure` ,
 we say `$0 + $1` .
 This works .
 We get so happy with this function that we have written
 that we give it to our coworkers .
 Except you forgot that the first thing developers try to do , is ,
 break other people's code . So ,
 someone comes along and writes code like this :
 */

// 10.apply(value: 0) { $0 / $1 } // ERROR : Fatal error: Division by zero .

/**
 This is going to cause a `runtime error`
 and our program crashes ,
 
 `// ERROR : Fatal error: Division by zero .`
 
 Dividing by zero is impossible . And this is what we are doing here ,
 we are dividing `10`
 — `$0` —
 by `0`
 — `$1` ,
 
 `$0 / $1`
 
 To counter these kind of things of ever happening ,
 we'd like to allow the caller of the function to throw an error ,
 if they want .
 */
/**
👉 Continues in PART 2
*/
