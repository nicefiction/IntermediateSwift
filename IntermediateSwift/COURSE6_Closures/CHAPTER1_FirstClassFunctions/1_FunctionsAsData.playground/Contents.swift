import Foundation


/**
 `CHAPTER 1`
 `First Class Functions`
 Before we talk about closures ,
 let’s take a look at functions in Swift .
 Functions are first class citizens ,
 which means
 they are treated
 in much the same way as Strings or Integers .
 Being able to pass functions around in our code
 is a crucial concept to learning how closures work
 and we’ll start from the ground up
 by building `higher order functions` .
 */



/**
 `1 Functions as Data`
 INTRO — The first step to understanding `higher order functions` , is ,
 the ability to pass functions around .
 In this video , we look at how we can achieve this .
 */
/**
 Closures are a powerful feature of Swift
 that allows you to pass functions around like data in your code .
 Closures are a relatively advanced topic ,
 and at this point
 I expect you to know the core concepts covered in the beginning Swift courses .
 Most courses on language basics start
 with a brief explanation
 of what that particular feature of the language does .
 Closures — unfortunately — mean very little to us right now .
 The common term used to describe closures is
 `anonymous functions` ,
 and that is kind of hard to understand .
 _So how are we going to learn about this ?_
 
 `CHAPTER 1 : Build a Closure from scratch`
 First , we'll jump right into a playground
 and build a closure from scratch before using it , so you know exactly what it means .
 `CHAPTER 2 : Closure expressions and shorthand syntax`:
 Next , we are going to understand
 the common terminology around closures
 and its shorthand syntax .
 So that we learn to read it in its various forms .
 `CHAPTER 3 : Build Standard Library functions`:
 Many of the core Standard Library methods accept closures as arguments .
 And for the next part . We’ll try building these methods on our own
 to fully understand them .
 `CHAPTER 4 : Closures in iOS`:
 Finally , we’ll see how closures are used in iOS to achieve many different tasks .
 
 Okay without any further ado . Let's get started .
 I have a new Playground open ,
 and we are going to start from scratch in here
 and build an understanding of
 how functions become what we have been calling closures .
 Functions are an important component in every programming language
 and by this point , you should be quite comfortable with functions in Swift .
 Let's look at some basics .
 Functions start with a keyword `func`
 followed by the name of the function ,
 any parameters ,
 and a return type .
 So , let’s create a very simple function :
 */

func printString(_ string: String) {
    
    print("Printing the string passed in as an argument : \(string)")
}

/**
 All the `printString( )` function does , is
 print out the `string` that we passed in .
 We can call the function
 — this is something we have done many times :
 */

printString("Hello , Dorothy here 👋")

/**
 And the console prints
 
 `Printing the string passed in as an argument : Hello , Dorothy here 👋`
 
 In the past , all we have done with the function that we have created , is ,
 to call it ,
 pass in some arguments ,
 and then store or work with the result we get back .
    Now here is something new .
 Functions can be assigned to constants or variables
 like any other value — like an Integer , or a String , or an Array :
 */

let stringPrinterFunction = printString

/**
 I can create a constant ,
 and to this I can assign the function I just created — `printString` .
 The value of `stringPrinterFunction` is the `printString` function we just wrote .
 
 `NOTICE` that I haven't included any parentheses after the function name
 nor have I passed in any arguments .
 
 `stringPrinterFunction` is the `printString` function ,
 _not_ the result of it doing some work on a set of values that we have provided .
 What this means , is ,
 that in Swift , functions are treated as first class citizens or first class objects .
 The term `first class citizen` in the context of programming languages , means ,
 that Swift functions are entities
 that support all the operations generally available to other types — like `Int` or `String` .
 The first important feature of being a first class citizen , is ,
 
 (`1`) that Swift functions — as you see here — can be assigned to variables or constants .
 
 Now we can call the function
 using this constant that we have created instead of the function name ,
 and pass in an argument .
 So , instead of calling `printString` , I can say
 */

stringPrinterFunction("Hello again !")

/**
 Since this is the function , I'm going to open parentheses — just like we normally do — and pass in an argument .
 And you should see in the console that we get a string printed out :

 `Printing the string passed in as an argument : Hello again !`
 
 And if you look at the function declaration up at the top ,
 
 `func printString(_ string: String) {`
 
    `print("Printing the string passed in as an argument : \(string)")`  `// ( 2 times )`
 `}`
 
 you see that it is now been called twice :
 
 `( 2 times )`
 
 Once when we call the function directly ,
 
 `printString("Hello , Dorothy here 👋")`
 
 and the second time using the constant ,
 
 `stringPrinterFunction("Hello again !")`
 
 When we assign a value to a constant or a variable ,
 that constant or variable gets a type
 — `Int` , or `String` , or any custom type that we declare .
 _What about when we assign a function ?_
 Well , if you OPTION click on `stringPrinterFunction` ,
 
 `let stringPrinterFunction: (String) -> ()`
 
 you see that the type is `String` — in parentheses — ,
 a return arrow ,
 and an empty set of parentheses .
 And you can also see that here — in the Plaground :

 `let stringPrinterFunction = printString`              `(String) -> ()`
 
 We know that an empty set of parentheses ,
 specified as a return type
 is also known as `Void` .
 So we can read this type as `String to Void` .
 This type is also called _the function’s or method’s signature_ .
 It indicates that this function takes a `String` as an argument and returns `Void` .
 Since the type of `stringPrinterFunction` accepts a `String` .
 By placing a `String` inside parentheses after the function name ,
 
 `stringPrinterFunction("Hello again !")`
 
 we are passing that` String` to the constant .
 
 `let stringPrinterFunction` [OLIVIER]
 
 And since the constant contains a function ,
 the `String` is then used as an argument in the `printString( )` function ,
 
 `func printString(_ string: String) {`
 
    `print("Printing the string passed in as an argument : \(string)")`  `// ( 2 times )`
 `}`
 
 Since this might be a bit confusing at first let's look at another example .
 */
/**
 Let's write a simple function that computes the sum of two integers and returns a value :
 */

/*
func sum(_ a: Int ,
         _ b: Int)
-> Int {
    
    return a + b
}
 */

/**
 `NOTE` : Remember the convention is
 that if we can't meaningfully distinguish between arguments ,
 we just get rid of the external argument label .

 Now like before ,
 let's assign this function
 — ( ! ) not the result of calling the function , but the function itself —
 to a constant :
 */

let addTwoNumbers = sum

/**
 Again , `NOTICE` when I want to assign the function ,
 I just include the function name . There is no list of arguments .
 If you look at the results area
 
 `(Int, Int) -> Int`
 
 the method signature is a `tuple`
 containing two integer values with a return type of `Int` as well .
 
 `NOTE` PASAN : there is these multiple set of parentheses — `((Int , Int)) -> Int` ,
 [ OLIVIER : This is not the case in my Playground . ]
 — because the inner parentheses represents a tuple as a single type .
 And then the outer parentheses represents the fact that this is the argument list .
 Even when there is just one argument that we accept in our function
 it will always be wrapped in a set of parentheses to denote that it is an argument list .
 
 If we were to use this constant to call the function ,
 */

addTwoNumbers(1 , 2)

/**
 We provide the arguments — just like we did earlier .
 In this case , we have two arguments ,
 so we provide it in a comma separated list .
 `NOTICE` here that in both cases when we provided the arguments ,
 we are not actually including the argument labels .
 And that makes sense for these examples
 because we have omitted the external labels ...
 
 `func sum(_ a: Int ,`
 `_ b: Int)`
 `-> Int {`
 
    `return a + b`
 `}`
 
 ... so there is no reason for there to actually be one in this case .
 However ,
 if we were to go back to the definition of `sum`
 and actually include a label by removing the underscore ,
 */

func sum(a: Int ,
         b: Int)
-> Int {
    
    return a + b
}

/**
 you'll see that this doesn't make a difference to our code .
 
 `addTwoNumbers(1 , 2)`
 
 compiles and works just like before .
 While argument labels are an important part of functions that help with clarity and readability ,
 they are not part of a function signature .
 As you can see in the results area ,
 
 `(Int, Int) -> Int`
 
 the type for `addTwoNumbers` has no indication of labels `a` or `b` .
 This means that — essentially — a function boils down to
 ( 1 ) the arguments it accepts and ( 2 ) the values it returns .
 By providing these two numbers as arguments to `addTwoNumbers` ,
 
 `addTwoNumbers(1 , 2)`
 
 we have satisfied the requirements to get the function working .
 
 
 Let's take a break here .
 This concept might not seem like a big deal right now ,
 but we are going to build on this — as always — to do some really cool stuff .
 */
