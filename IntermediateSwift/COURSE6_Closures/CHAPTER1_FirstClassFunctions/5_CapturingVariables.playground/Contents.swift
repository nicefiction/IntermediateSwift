import Foundation


/**
 `5 Capturing Variables`
 INTRO — Closures are powerful
 primarily because
 they capture constants and variables
 from the surrounding context .
 In this video ,
 we take a look at what that means
 and how we can write simple functions to capture variables .
 */
/**
 Let's go back to the `gameCounter()` function for just a second ,
 and add a local variable in here :
 */

/*
typealias IntegerFunction = (Int) -> Void

 
 
func gameCounter()
-> IntegerFunction {
    
    var localCounter: Int = 0
    
    
    func increment(_ i: Int) {
        
        print("The value of the local counter is : \(localCounter)")
    }
    
    
    return increment
}
 
 let counter = gameCounter()
 counter(1)
*/

/**
 Back when we first learned about functions , objects , and the like ,
 we talked about scope :
 A variable declared inside of a function exists only inside that function .
 It goes out of scope when the function finishes execution .
 Given that information ,
 we know that the `localCounter` variable we just declared
 — being a local variable —
 will go out of scope
 after the call to `gameCounter()` is made and finished .
 Okay , tuck that knowledge away .
 Now inside of the `increment()` function ,
 let's increment the `localCounter`
 by the amount of the value passed in — `i` —
 as an argument to `increment` :
 */

typealias IntegerFunction = (Int) -> Void



func gameCounter()
-> IntegerFunction {
    
    var localCounter: Int = 0
    
    
    func increment(_ i: Int) {
        
        localCounter += i
        
        print("The value of the local counter is : \(localCounter)")
    }
    
    
    return increment
}


let counter = gameCounter()
counter(1)

/**
 If we take a look at the function that we have written ,
 this is how we would expect it to work :
 We call the `gameCounter()` method  
 
 `let counter = gameCounter()`
 
 The `gameCounter()` function creates a local variable — `localCounter` —
 with a value initialised to `0` .
 
 `var localCounter: Int = 0`
 
 The `localCounter` variable is used inside the `increment()` function ,
 and a `String` is logged :
 
 `func increment(_ i: Int) {`
 
    `localCounter += i`
 
    `print("The value of the local counter is : \(localCounter)"))`
 `}`
 
 Since the body of both
 — the `increment()` function and the `gameCounter()` function —
 are now complete at the end of this , we `return increment` .
 And based on what we know ,
 the local variable `localCounter` must go out of scope , correct ?
 Well , let’s see if this is true .
 The value of `counter` down here ...
 
 `let counter = gameCounter()`
 
 ... is the result of executing the `gameCounter()` function .
 This means that once this is done ,
 the `localCounter` has been created , set to `0` ,
 and has been logged ,
 and gone out of scope since this is finish execution .
 So , next ,
 down here , `gameCounter()`
 returns `increment` , we know that so far .
 And in the next line of code ,

 `counter(1)`
 
 we provide an argument to `counter` — the integer value of `1` .
 Now even though we expect `localCounter` to have gone out of scope ,
 clearly , we see in the console down here ...
 */

// CONSOLE : The value of the local counter is : 1

/**
 ... that the value of the `counter` is now `1` .
 So here` localCounter` is `0` ,
 
 `func gameCounter()`
 `-> IntegerFunction {`
 
    `var localCounter: Int = 0`
 
    `...`
 `}`
 
 the `gameCounter( )` function finishes executing ,
 but somehow ,
 we managed to increase it inside the `increment()` function over here ,
 
 `func increment(_ i: Int) {`

     `localCounter += i`

     `print("The value of the local counter is : \(localCounter)")`
 `}`
 
 How ?
 How is this happening ?
 Well in this case , the inner function `increment()` is able
 to capture the state of `localCounter` , even though it is declared in the outer scope .
 
 `func gameCounter()`
 `-> IntegerFunction {`
 
    `var localCounter: Int = 0`
 
 
    `func increment(_ i: Int) {`
 
        `localCounter += i`
 
        `print("The value of the local counter is : \(localCounter)")`
    `}`
 
 
    `return increment`
 `}`
 
 Think of this in much the same way as
 how an instance method inside a class or a struct
 is able to use properties that are defined outside of it .
 The method — or function in this case —
 can use the variable `localCounter` defined outside of its scope .
 Now here is the interesting part though ,
 not only can the `increment()` function use `localCounter` ,
 but it can also capture its state .
 And by capture ,
 I mean that it maintains the state of the variable .
 So here ,
 
 `func gameCounter()`
 `-> IntegerFunction {`
 
    `var localCounter: Int = 0`
 
    `...`
 `}`
 
 it is `0` , and then we go ahead and `return increment` .
 
 `func gameCounter()`
 `-> IntegerFunction {`
 
    `...`
 
    `return increment`
 `}`
 
 And even though this — `localcounter` — ...
 
 `func gameCounter()`
 `-> IntegerFunction {`
 
    `var localCounter: Int = 0`
 
    `...`
 `}`
 
 ... doesn't exist anymore ,
 we have captured the fact that it is `0` ,
 and that way ,
 when we increment it by the argument — which is `1` —
 
 `counter(1)`

 the value is `1` .
 
 Now that we execute the `increment()` function down here ,
 
 `func increment(_ i: Int) {`

     `localCounter += i`

     `print("The value of the local counter is : \(localCounter)")`
 `}`
 
 you would think that , again ,
 because now that we have actually called the `increment()` function
 and `localCounter` is in here , we have called it ,
 we have provided an argument .
 Everything is done that is in the body of that function ,
 so everything should go out of scope , right ?
 Well , except that is , again , not what happens .
 Now , what do you think the result will be if I call counter again
 — `counter` , the constant containing the `increment()` function —
 */

counter(1) // CONSOLE : The value of the local counter is : 2

/**
 If I do that ,
 you’ll see that it logs the `localCounter` value as `2` :
 
 `// CONSOLE : The value of the local counter is : 2`
 
 Not only have we used the variable that was defined outside of the function scope here ,
 but we have captured the context — or the state — of that variable too .
 
 Because the function we are executing — `increment()` — is assigned to a constant .
 
 `let counter = gameCounter()`
 
 The state of this function
 and the value of what `localCounter` is inside this function
 is captured and maintained in this constant , it is kept alive in this constant .
 */
/**
 Think of it this way ,
 
 `gameCounter()`
 
 `var counter`
 
 `increment()`
 
 we start off with the `gameCounter()` function with an inner function ,
 the inner function captures the `localCounter` variable that is defined in the outer scope .
 
 `typealias IntegerFunction = (Int) -> Void`
 
 
 `func gameCounter()`
 `-> IntegerFunction {`
 
    `var localCounter: Int = 0`
 
 
    `func increment(_ i: Int) {`
 
        `localCounter += i`
 
        `print("The value of the local counter is : \(localCounter)")`
    `}`
 
 
    `return increment`
 `}`
 
 When we call `gameCounter` — since that function returns a function —
 
 `typealias IntegerFunction = (Int) -> Void`
 
 we assign the inner function that it returns — the `increment()` function —
 
 `func increment(_ i: Int) {`

     `localCounter += i`

     `print("The value of the local counter is : \(localCounter)")`
 `}`
 
 to the constant `counter` :
 
 `let aCounter = var counter`
 
 Since `increment()` itself captured `localCounter` ,
 the state of `localCounter` is maintained inside the `counter` constant .
 Every time we execute the function ,
 we call the very same function that is assigned to `counter` .
 Not just a version of that function , but that very same function ,
 and this is why the state of `localCounter`
 — which is inside the `increment()` function —
 is maintained .
 And we increment that same `localCounter` with every call .
 So ,
 it is not like how when we usually call a function
 — we are just providing an argument , and it does something .
 Here ,
 
 `let counter = gameCounter()`
 
 because that function is assigned to a constant ,
 it is the very same function we are using every time .
 And this combination of
 a function
 in captured variables
 from the surrounding context
 is what is called a `closure` .
 Over here ,
 
 `typealias IntegerFunction = (Int) -> Void`
 
 
 `func gameCounter()`
 `-> IntegerFunction {`
 
    `var localCounter: Int = 0`
 
 
    `func increment(_ i: Int) {`
 
        `localCounter += i`
 
        `print("The value of the local counter is : \(localCounter)")`
    `}`
 
 
    `return increment`
 `}`
 
 
 `let counter = gameCounter()`
 
 `counter(1)`
 `counter(1)`
 
 `increment()` is not the closure , but `counter` is .
 By assigning this function
 along with the variable we have captured to a constant ,
 we create a `closure` .
 A closure maintains the state of variables captured outside of its scope ,
 and this allows for some very powerful functionality .
 So , I can call `counter` again ,
 */

counter(45)

/**
 and you'll see that it'll increment by the value that I provide .
 So now it should be `47` — which it is , ...
 */

// CONSOLE :
/*
 The value of the local counter is : 1
 The value of the local counter is : 2
 The value of the local counter is : 47
 */

/**
 ... that state is still maintained from the previous call .
 To create a new closure , we can create a new constant ,
 */

let anotherCounter = gameCounter()

/**
 So now if I call `anotherCounter` and say `1` , ...
 */

anotherCounter(1)

// CONSOLE :
// The value of the local counter is : 1

/**
 ... you'll see that now the `localCounter` is back to `1` .
 
 `NOTE` : `localCounter` is just back to `1` for the closure that is assigned to `anotherCounter` .
 Because if I make a call to `counter` again
 and say `5` , ...
 */

counter(5)

// CONSOLE
/*
 The value of the local counter is : 1
 The value of the local counter is : 2
 The value of the local counter is : 47
 The value of the local counter is : 1
 The value of the local counter is : 52
 */

/**
 ... now we have some value in the 50s , as you see here .,
 
 `The value of the local counter is : 52`
 
 This new closure
 
 `let anotherCounter = gameCounter()`
 
 captured the local variable — `localCounter`— again ,
 
 `func gameCounter()`
 `-> IntegerFunction {`
 
    `var localCounter: Int = 0`
 
 
    `func increment(_ i: Int) {`
 
        `localCounter += i`
 
        `print("The value of the local counter is : \(localCounter)")`
    `}`
 
 
    `return increment`
 `}`
 
 which has an initial value of `0` ,
 and maintains the state
 separate
 from the state maintained inside `counter` .
 
 `let counter = gameCounter()`
 
 So you can increment , for example , `anotherCounter` a couple of times ,
 */

anotherCounter(10)
anotherCounter(60)

/**
 And you'll see now
 that each counter inside each constant has its own state ,
 */

// CONSOLE :
/*
 The value of the local counter is : 1
 The value of the local counter is : 2
 The value of the local counter is : 47
 The value of the local counter is : 1
 The value of the local counter is : 52
 The value of the local counter is : 11
 The value of the local counter is : 71
 */

/**
 So , the final value of `anotherCounter` is `71` .
 Each constant maintains its own version
 — essentially — of `localCounter` and its own state .
 Closures can do this because they are reference types .
 Up to this point , we have only known one reference type , classes .
 So , now you can add closures to that list .
 By capturing variables defined outside of the function's context ,
 the closure can maintain a reference to that constant , and keep it alive .
 This is some pretty heavy stuff , so let's take a break here .
 In the next set of videos ,
 let's see if we can build up a set of useful higher order functions
 using the concepts that we have just learned .
 */
/**
 `QUIZ`
 `Q1`: `(Int , String) -> [String]`
 `Q2`
 Functions in Swift are first class citizens because :
 1. They can be assigned to constants and variables .
 2. They can be assigned as parameters to functions .
 3. They can be returned from functions .
 `Q4`
 A combination of a function and an environment of captured variables is called a `closure` .
 `Q5`
 */






print("Debug")
