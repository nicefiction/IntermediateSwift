import Foundation


/**
 `2 Closure Expression Syntax`
 INTRO — `Closures` are essentially the `higher order functions`
 that we have been writing so far .
 This syntax is cumbersome
 and indeed we can write closure expressions to simplify our code .
 */
/**
 When using `Closure Expression Syntax`
 we don't need to write a separate `double()` function ...
 */

func double(_ i: Int)
-> Int {
    
    return i * 2
}

/**
 ... and pass that as an argument ,
 */

let doubleFunction = double


let numbers: [Int] = [
    1 , 3 , 5 , 7 , 9
]

let doubledNumbers = numbers.map(doubleFunction)

/**
 So , let’s use `map()` again to return a new array ,
 but this time with the numbers tripled :
 */

let tripledNumbers = numbers.map({ (number: Int) -> Int in
    
    return number * 3
})

/**
 This time — instead of passing in a `triple()` function that we haven't defined —
 we are going to use a `closure expression` .
 To write a `closure expression` ,
 we first start with a set of braces .
 Inside the braces ,
 we start with the closure’s parameters in parentheses.
 So , we’ll say this will have a local name — a constant named `number` .
 Next is the return type ,
 which is going to return an integer .
 So far this looks like a signature of a regular function :
 
 `(number: Int) -> Int`
 
 We have the parameters it accepts inside parentheses
 — with a name for the constant , and a type —
 and then we have a return type .
 Followed after this — after the return type — is the keyword `in` ,
 and then the body of our expression .
 That is it .
 The result area indicates
 that the closure expression was evaluated `5` times .
 
 `NOTE` Pasan :
 It has been run 6 times , which is what we want . So ,
 this is once for each value — 1 , 3 , 5 , 7 , 9 —
 and then once to return the entire array .
 And that is why it says 6 times here .
 `NOTE` Olivier :
 In my Playground it says `5` , not 6 .
 
 While the `closure expression` allowed us
 to write out the entire expression in a single line
 without having to create a separate function
 and then assign it to a constant ,
 it is a bit hard to read :
 
 `let tripledNumbers = numbers.map({ (number: Int) -> Int in return number * 3 })`
 
 So at first it might be easier for you
 to understand how this is a closure
 or almost a regular function
 if you format it better . So for example ,
 
 `let tripledNumbers = numbers.map({ (number: Int) -> Int in`
 
    `return number * 3`
 `})`
 
 And this starts to look a bit more like a regular function .
 At the top , we have the function signature .
 
 `(number: Int) -> Int`
 
 All we are really missing here , are
 the `func` keyword and the name ,
 and this will look like a regular function .
 And because we are already inside a closure that starts with a set of braces ,
 it would be weird to open the body of the function with another set of braces .
 Instead , we use the keyword `in` to denote that .
 After that , we are starting the body — or the logic of the function :
 
 `return number * 3`
 
 We have a function body just like normal here ,
 and then a closing brace .
 In addition to doing it this way ,
 `closure expressions` offer a few more features though .
 Particularly some nice shorthand features of Swift
 to make our closures more concise and readable ,
 but only when we want it to be that way .
 The bits of code inside the `map()` function here ,
 
 `{(number: Int) -> Int in`
 
    `return number * 3`
 `}`
 
 so all of this
 are the `closure expression` .
 By following a set of rules
 we can introduce some shorthand syntax .
 We have already followed the first rule .
 So let me add that in as a comment :
 
 `// RULE 1 • Define the closure inline :`
 
 `let tripledNumbers = numbers.map({ (number: Int) -> Int in`
 
    `return number * 3`
 `})`
 
 `RULE #1` :
 If all you are doing is
 passing in your closure as an argument
 then you don't need to assign it to a local variable or constant .
 You can define the closure inline
 — you can pass it in directly .
 
 Next is Rule #2 .
 */



 /**
 `RULE #2` :
 When a closure is asked as an argument to a function , as we have done here ,
 
 `{(number: Int) -> Int in`
 
    `return number * 3`
 `}`
 
 
 `let tripledNumbers = numbers.map({ (number: Int) -> Int in`
 
    `return number * 3`
 `})`
 
 Swift can infer the types of the parameters
 and the type of the value that it returns — or the return type .
 */

// RULE #2 • Inferring type from context :

let tripledNumbers2 = numbers.map({ number in

   return number * 3
})

/**
 In our example here ,

 `let numbers: [Int] = [`
    `1 , 3 , 5 , 7 , 9`
 `]`
 
 
 `let tripledNumbers = numbers.map({ (number: Int) -> Int in`
 
    `return number * 3`
 `})`
 
 the `map()` function is called on an Array of integers
 — the numbers array .
 Since `map()` basically takes a value from the array ,
 and then passes it to the closure to work with ,
 because this is an array of integers ,
 Swift infers that the type of the `closure parameter` should be an integer .
 Next , based on the body of the function
 — where all we are doing is multiplying an integer by an integer —
 it can also infer that the return type is an integer as well .
 Now we can get rid of all the places where we are specifying a type : 
 
 `let tripledNumbers2 = numbers.map({ number in`
 
    `return number * 3`
 `})`
 
 So , get rid of the return type ,
 and the parameter type as well .
 And you can see here that these are the exact same values in the results area ,
 
 `[3, 9, 15, 21, 27]`
 
 so what we have here is the exact same closure expression .
 Here
 
 `let numbers: [Int] = [`
    `1 , 3 , 5 , 7 , 9`
 `]`
 
 
 `let tripledNumbers2 = numbers.map({ number in`
 
    `return number * 3`
 `})`
 
 we are allowing the compiler
 to infer that we are passing in an integer
 because — as we just discussed —
 given that the `numbers` array is an array of integers
 and `map()` plucks each of those values out
 and gives it to the closure ,
 the compiler knows this will be an integer .
 Now , `number` over here
 
 `({number in`
 
 — at the beginning of the closure expression —
 is simply a local constant
 that we are assigning the integer value to .
 It is essentially an argument label without the type specified ,
 because the type is inferred .
 `NOTE` that it is always possible to infer parameter types and return types
 when passing a closure to a function as an `inline closure expression` .
 As a result , you rarely need to write it in this full form ,
 
 `let tripledNumbers = numbers.map({ (number: Int) -> Int in`
 
    `return number * 3`
 `})`
 
 where you have to specify the types .
 But , and this is up to you ,
 you have to make a balanced choice between conciseness and readability of code .
 Especially when you are first starting out ,
 explicitly stating the parameter type and the return type here
 makes it a lot easier for both you and anyone else who is reading your code .
 But as you get used to writing closures
 you'll see that this

 `let tripledNumbers2 = numbers.map({ number in`
 
    `return number * 3`
 `})`
 
 starts to make a lot more sense .
 You know numbers is an array of integers . So you know that value is an integer .
  
 Okay , next step is Rule #3 .
 */



/**
 `RULE #3` : If we have a `single expression closure` — that is ,
 we are only evaluating a single expression as we are doing here ,
 
 `let tripledNumbers2 = numbers.map({ number in`
 
    `return number * 3`
 `})`
 
 This is just a single expression
 
 `return number * 3`
 
 then the return value is actually implicit ,
 */

// RULE #3 • Implicit Returns from Single-Expression Closures :

let tripledNumbers3 = numbers.map({ number in

   number * 3
})

/**
 we don't need to write the `return` keyword .
 This is a big change from how you have thought about functions in the past ,
 because in functions , if you don't have a `return` keyword
 nothing is returned .
 But with an inline closure expression
 — if it is a single expression —
 then the compiler simply infers that
 " yes , you do want to return that value " .
 And again , if we look at the results area ,
 
 `[3, 9, 15, 21, 27]`
 
 You see that is just like before .
 So here again , because it is a single expression
 the closure knows that we want to return that value .
 
 
 So far , the changes in the short hand that we have made ,
 the changes we have made to our closure
 have been nice and elegant .
 Let's take a break and in the next video
 we'll go over the last three shorthand syntax features .
 */


print("Debug")
