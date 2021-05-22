import Foundation


/**
 `1 Throwing From Inside A Closure`: PART 2 OF 3
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
 because we are not using `try` over here ...
 
 `return operation(self , value)`
 
 ... to evaluate our expression ,
 We have two options here .
 (`1`) One is to handle the error inside the `apply()` function itself .
 We would do that unlike we normally handle errors .
 So , we would get rid of this and we would use a `do try catch statement` :
 */

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
        
        return 1 // ⚠️ A
    }
}

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
 */
/**
👉 Continues in PART 3
*/
