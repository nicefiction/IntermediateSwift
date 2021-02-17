import Foundation


/**
 `2 Functions as Parameters`
 INTRO — Now that we know we can assign a function to a constant or variable ,
 let’s take a look at how we can write functions
 that accept other functions as parameters .
 */
/**
 In the last video , we looked at
 how we can assign functions to a variable or constant .
 In this video , let's take a look at
 how we can write functions that accept other functions as parameters .
 This sounds very confusing at first , but don't worry ,
 we are going to work through a few examples .
 As I mentioned in the last video ,
 swift functions are first-class citizens .
 Which means that we can use them
 in many of the same operations
 which we use native types in .
 We can assign Swift native types
 like an `Int` or `String` to a constant .
 And as we just saw , you can do that with functions too .
 We can also assign native types as the type for a function parameter or argument .
 Since functions themselves are first-class citizens ,
 this means that we can use one function as a parameter to another function .
 So , let’s take a look at this .
 The first thing we did earlier was to create the `printString()` function ,
 */

func printString(_ string: String) {
    
    print("Printing the string passed in as an argument : \(string)")
}

/**
 We assigned this function to a constant ,
 */

let stringPrinterFunction = printString

/**
 and then we called it
 using a constant ,
 */

stringPrinterFunction("hello world")

/**
 Instead of assigning it to a constant ,
 
 `let stringPrinterFunction = printString`
 
 let's see if we can assign it as a parameter to another function .
 So down here , I am going to create a new function :
 */

/*
func displayString(usingFunction function: (String) -> Void) {}
 */

/**
 The `displayString()` function has a single parameter .
 We name the parameter `function` ,
 and we give it an argument label of `usingFunction` .
 Think of this parameter function as a _constant_ . In reality , it really is just a constant .
 But like we have the `stringPrinterFunction` constant that we wrote earlier ,
 `function` is also a constant that we are simply assigning another function to .
 Function parameters require types specified , so here ,
 we need to specify the same type as the `printString()` function that we defined earlier
 
 `func printString(_ string: String) { ... }`
 
 because we'd like to pass this function — `printString` — in
 as an argument to the `displayString()` function .
 The type we want — that we inspected earlier — is `String to Void` ,
 
 `(String) -> Void`

 Remember the way we get the type or signature for a function , is ,
 we take all the parameters ,
 put them in parentheses
 — comma separated if there are multiple — ,
 and then we specify the return type as always .
 So here ,
 
 `func displayString(usingFunction function: (String) -> Void) {}`
 
 we want a `function` that accepts a `String` and returns `Void` .
 So remember
 the arguments that are accepted are enclosed in parentheses .
 Now , you can also write an empty set of parentheses ,
 but because there is more than one set of parentheses being used here ,
 
 `func displayString(usingFunction function: (String) -> ()) {}`
 
 it is a little bit confusing . So , I am actually using the word `Void` .
 So now we have a `function` here
 that takes another function as a parameter .
 Inside the `displayString()` function ,
 we are going to call the function that we are passing in as an argument ,
 which is represented by this constant — `function` .
 Remember ,
 this is just like when we assigned the function to a constant .
 So we can call it — call the one that is passed in as an argument —
 by using the name and just calling it :
 */

func displayString(usingFunction function: (String) -> Void) {
    
    function("I am a function inside a function .")
}

/**
 _So how do we call it ?_
 We write out the name of the constant — which is `function` here .
 And then we provide some value for its arguments .
 Since this is a `function` that accepts a `String` , we pass in a `String` .
 Now , nothing is going to happen yet , of course ,
 because we need to call `displayString()` ;
 */

displayString(usingFunction : printString)

/**
 So , when we call `displayString()`
 and then provide some argument for this parameter ,
 it is going to then pass this `string` into whatever function we provide
 and defer that work . So for example ,
 if I call `displayString()` — just like any other function — ,
 and for the argument I provide the `printString()` function we defined earlier .
 You see at the bottom that this `string` is now passed as an argument
 to whatever is assigned to `function`
 
 `func printString(_ string: String) { ... }`
 
 `func displayString(usingFunction function: (String) -> Void) { ... }`
 
 — which happens to be `printString` .
 And if you go up to the `printString()` function ,
 
 `func printString(_ string: String) {`
 
    `print("Printing the string passed in as an argument : \(string)")`
 `}`

 you'll see that whatever is passed in as an argument
 is printed in this `string` right here using `String Interpolation` .
 So , as expected , it says
 
 `" Printing the string passed in as an argument : I am a function inside a function . " ,`
 
 So just like before over here ,
 
 `displayString(usingFunction : printString)`
 
 we are calling the `printString` function again .
 But rather than assigning it to a constant
 and calling it ,
 we are assigning it as an argument to another function ,
 
 `displayString(usingFunction : printString)`
 
 and calling it inside the body of that function :
 
 `func displayString(usingFunction function: (String) -> Void) {`
 
    `function("I am a function inside a function .")`
 `}`
 
 
 
 I know this is a bit confusing , but stick with me .
 Let's take a short break here , and in the next video
 we'll explore another example that should reinforce this concept .
 */


print("Debug")
