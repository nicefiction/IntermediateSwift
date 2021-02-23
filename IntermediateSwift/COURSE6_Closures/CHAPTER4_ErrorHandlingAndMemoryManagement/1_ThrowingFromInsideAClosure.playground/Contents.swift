import Foundation


/**
 `CHAPTER 3`
 `Error Handling and Memory Management`
 Errors can occur anywhere in code
 and that includes closures .
 The ways in which you handle an error in a closure
 depends on
 the signature of the closure .
 Over the next few videos ,
 let's explore how we can throw and handle errors inside a closure .
 In addition ,
 we are going to spend some time talking about
 memory considerations with closures .
 */


/**
 `1 Throwing From Inside A Closure`
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
 we are dividing `10` — `$0` —
 by `0` — `$1` ,
 
 `$0 / $1`
 
 To counter these kind of things of ever happening ,
 we'd like to allow the caller of the function to throw an error ,
 if they want .
 Just like we can mark any function as _throwing_
 we can mark a `closure expression` as _throwing_ as well .
 And we do that by adding the `throws` keywords :
 */

/*
extension Int {
    
    func apply(value: Int ,
               _ operation: (Int , Int) throws -> Int)
    -> Int {
        
        return operation(self , value) // ERROR : Call can throw, but it is not marked with 'try' and the error is not handled .
    }
}
 */

/**
 This is our closure .
 
 `operation: (Int , Int) throws -> Int`
 
 So again , before the return type I say , `throws` .
 But now , the compiler is going to complain
 
 `// ERROR : Call can throw, but it is not marked with 'try' and the error is not handled .`
 
 because we are not using `try` over here ...
 
 `return operation(self , value)`
 
 ... to evaluate our expression ,
 We have two options here .
 (`1`) One is to handle the error inside the `apply()` function itself .
 We would do that unlike we normally handle errors .
 So , we would get rid of this and we would use a `do try catch statement` :
 */

/*
extension Int {
    
    func apply(value: Int ,
               _ operation: (Int , Int) throws -> Int)
    -> Int {
        
        // return operation(self , value)
        
        do {
            return try operation(self , value)
        } catch _ {
            // Empty catch block . ⚠️
        } // B
        
        return 1 ⚠️ // A
    }
}
 */

/**
 So , apply the `operation` to `self` and `value`
 and then , we'd catch the error . As always ,
 just for the purpose of this example ,
 we are going to have an empty catch block .
 `NOTE` : Do not do this in actual code !
 
 Okay ,
 so now inside the `apply()` function ,
 we are handling the error , _right_ ?
 Well , this is not working
 because we need to `return` this `return try operation` .
 So , we are somewhat handling the error , but not really .
 There are two problems here . Again , as I mentioned ,
 (`A`) The `apply()` function is unhappy
 because it expects us to `return` an integer value .
 And as always , simply returning a random value is poor programming .
 (`B`) The second problem here is that ,
 we are handling the error inside of the `apply()` function itself .
 Since the `operation` method is determined when the `apply()` function is called
 — by handling the error inside my function —
 my only option is to have an `empty catch block`
 because I don't know what kind of error we are going to end up with .
 I can't conceive of all the different errors that may occur here ,
 so my only option would be
 to crash the app with a `fatalError()` statement in the `catch` statement .
 All of this is just poor choices all around .
    One way I can improve my code , is ,
 by seeing that the `apply()` function is a throwing function as well .
 Now , I can change all this to :
 */

enum MathError: Error {
    
    case dividebByZero
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
 to `throw` an error from within the closure .
 So , we’ll define an error ,
 
 `enum MathError: Error {`
 
    `case dividebByZero`
 `}`
 
 We can use this now in a closure .
 We can say ,
 */

//do {
//    try 10.apply(value: 0) {
//        if $1 == 0 {
//            throw MathError.dividebByZero(message : "hello")
//        } else {
//            $0 / $1
//        }
//    } catch {
//        MathError.dividebByZero(message : "You cannot divide by 0 .")
//    }
//}


do {
    try 10.apply(value: 0) {
        if $1 == 0 {
            throw MathError.dividebByZero
        } else {
            return $0 / $1
        }
    }
} catch {
    MathError.dividebByZero
    print("You cannot divide by zero .")
}

/**
 We use a `trailing closure` here .
 
 `{`
     `if $1 == 0 {`
         `throw MathError.dividebByZero(message: "Undivisable by zero .")`
     `} else {`
         `return $0 / $1`
     `}`
 `}`
 
 Below , at the end of the `do statement` , we include our `catch` statement .
 And we catch on that specific error we defined earlier . And we just print an error message .
 As you can see now ,
 */

// CONSOLE :
// You cannot divide by zero .

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
