import Foundation


/**
 `3 Closure Expression Shorthand`
 INTRO — In this video ,
 we’ll continue our exploration of closure shorthand syntax .
 We’ll start with a full form inline closure expression
 and see where we end up when we apply all of the shorthand rules .
 */
/**
 There are a couple more ways
 that we can make our closure expression syntax more concise .
 I want you all to be aware though
 that writing your code like this
 isn't necessarily always a good thing .
 Sure , you might save a few keystrokes when typing ,
 but you will pay the price of readability .
 It is always a tradeoff .
 The reason we are learning this though , is ,
 because you need to know how to read other people's code ,
 and there is a pretty big chance that you will run into this kind of code ,
 particularly when you look at blog posts or other people's code online .
 Okay , so let's move to Rule #4 ,

 `RULE #4` :
 Rule number 4 states
 that we can use `shorthand argument names` .
 This is probably the most confusing shorthand syntax to master ,
 only because it is kind of weird . But it really isn't hard .
 Swift automatically provides shorthand argument names to inline closures
 — only to inline closures —
 which can then be used
 to refer to values of the closure’s arguments by certain names .
 Now here is the weird part . These names are `$0` , `$1` , `$2` , and so on ,
 depending on the number of arguments you have . For example ,
 if you have one argument , you will use `$0` to refer to that .
 If you have two arguments , it is `$0` and `$1` .
 It is kind of like indexes in an array ,
 we start with zero
 and then the numbers increase for the number of arguments that we are accepting into the closure .
 So let's rewrite our `map()` function again ...
 */

let numbers: [Int] = [
    1 , 3 , 5 , 7 , 9
]


let tripledNumbers3 = numbers.map({ number in

   number * 3
})

/**
 ... using shorthand argument names :
 */

let tripledNumbers4 = numbers.map({
    
    $0 * 3
})

/**
 This time ,
 we are going to get rid of `number in number` ,
 and just state `$0` . If you check the value history again in the results area ,
 
 `[ 3 , 9 , 15 , 21 , 27 ]`
 
 you see that this is the same .
 This is quite a change from our original closure expression :

 `let tripledNumbers = numbers.map({ (number: Int) -> Int in`
 
    `return number * 3`
 `})`
 
 We had this when we started out .
 And now , all we have , is
 
 `let tripledNumbers4 = numbers.map({`
 
    `$0 * 3`
 `})`
 
 We only have a single argument being passed into this closure.
 So we can refer to it as `$0` ,
 and then go ahead and multiply it by `3` .
 Again , because this is a `single expression closure`
 the `return` is implicit .
 Swift automatically gave the value being passed into the closure a name — `$0` —
 since it is just one argument , and we can use that name
 instead of creating and assigning to a local constant — that value that is passed in .
 Now , if this were a different function — and not `map()` — and it was pulling
 lets say ,
 the `key` and `value` out of a `Dictionary` ,
 and passing that into a closure ,
 then we would use `$0` and `$1` to represent two arguments .
 When we use shorthand arguments in closure expressions ,
 we can omit the closure’s argument list from the definition
 — which is that bit right here , `number in number` ,
 The number and type of shorthand arguments will be inferred
 from the expected function type .
 So , really , it depends on this `map()` function right here ,
 
 `let tripledNumbers4 = numbers.map({`
 
    `$0 * 3`
 `})`
 
 what is being called on , the array ,
 
 `let numbers: [Int] = [`
    `1 , 3 , 5 , 7 , 9`
 `]`
 
 or whatever we are calling it on in different use cases .
 So , `map()` expects a function with a single input ,
 and so when we put `$0` ,
 it knows to refer to that single input with `$0` .
 The keyword `in` can also be omitted when using shorthand ,
 as you just saw :
 
 `let tripledNumbers4 = numbers.map({`
 
    `$0 * 3`
 `})`
 
 When you learn more about Swift ,
 and you come across blog posts on the web particularly,
 it will be fairly common to see the shorthand argument names ,
 you'll get used to it .
 While you may not want to use this syntax for the sake of readability ,
 it is good to be familiar with it .
 And in this case , I typically tend to use `$0` ,
 
 `let tripledNumbers4 = numbers.map({`
 
    `$0 * 3`
 `})`
 
 There is just one argument . It is pretty obvious
 — especially if you know what the `map()` function is doing —
 it is pretty obvious what this `$0` refers to .
 But sometimes closures have three to four arguments ,
 and then just using `$0` ,` $1` , `$2` , or `$3`
 is not going to make much sense .
 Okay ,
 on to Rule #5 .
 Now , these last two rules are pretty important
 because you will see this everywhere in code
 — including all our lessons moving forward .
 */


/**
 `RULE #5` :
 If the closure expression is the `last argument to a function` ,
 you can move the expression outside the parentheses of the function call
 and write it as a `trailing closure` instead . To be more specific ,
 a trailing closure is a closure expression
 that is written outside
 and after
 the parentheses of the function call that it supports :
 */

let tripledNumbers5 = numbers.map() {
    
    $0 * 3
}

/**
 Since the closure expression here
 is the last argument in the function ,
 we can actually write it outside
 and after the parentheses of the function .
 And again , this is essentially the same .
 Now , you might be wondering ,
 this doesn't seem to offer much convenience .
 All we have done , is ,
 taking the closure inside of the parentheses and placing it right after it .
 _So , why would we do this ?_
 Well , trailing closures are most useful
 when the closure is too long to be written on a single line
 it degrades readability .
 With a trailing closure , if you look carefully ,
 it just looks like a normal function body :

 `let tripledNumbers5 = numbers.map() {`
 
    `$0 * 3`
 `}`
 
 Typically a function has
 a name ,
 then a set of arguments inside parentheses .
 And then after that
 we use a set of braces to open and close the body , which is what it looks like here .
 With a trailing closure ,
 we can treat it like a normal function
 and perform all the logic we want within .
 So let's see how that would work .
 I am going to write a function that is quite meaningless
 but will show you
 how a trailing closure
 allows you to write
 all the logic you want
 in how you would typically write a normal function :
 */

// numbers.map() { (number: Int) -> Int in
numbers.map() { number -> Int in
    
    return number % 2 == 0 ? number / 2 : number
}

/**
 Remember that `map()` does take an argument ,
 but because it is the last argument — the closure is the last argument .
 This is the only time it matters , right ?
 You can only add it outside of the parentheses
 if the closure is the last argument in the list ,
 So , in this closure ,
 
 `numbers.map() { number -> Int in`
 
    `return number % 2 == 0 ? number / 2 : number`
 `}`
 
 we are assigning to a local variable `number` — the value passed in —
 and we are specifying a `return` type of `Int` .
 Then we check to see if the `number` is even .
 If it is , we return it divided by two , otherwise divided by three .
 Don't worry about the actual implementation .
 Just focus on the fact
 that a trailing closure pretty much lets you pass in
 a complex function to the `map()` function to do whatever you want .
 
 
 Okay , on to the final rule .
 */


/**
 I am going to comment this out
 
 `// numbers.map() { number -> Int in`
 
 `// return number % 2 == 0 ? number / 2 : number`
 `// }`
 
 so it doesn't really interfere with the flow of the rest of our code .
 
 `RULE #6` :
 Rule number 6 is pretty simple .
 If the closure expression is the only argument to the function ,
 then you can get rid of the function's parentheses altogether :
 */
// RULE #6 • Ignoring Parentheses :

let tripledNumbers6 = numbers.map {
    
    $0 * 3
}

/**
 You see that `map()` doesn't have any argument other than the closure .
 And since the closure expression is the only argument ,
 then we can get rid of the function's parentheses altogether .

 
 And there you have it :
 `CLOSURE EXPRESSION SYNTAX :`
 
 `RULE #1 • Define the Closure inline :`
 
 `numbers.map({ (value: Int) -> Int in return value * 3 })`
 
 
 `RULE #2 • inferring type from context :`
 
 `numbers.map({ value in return value * 3 })`
 
 
 `RULE #3 • Implicit Returns from Single-Expression Closures :`
 
 `numbers.map({ value in value * 3 })`
 
 
 `RULE #4 • Shorthand Argument Names :`
 
 `numbers.map({ $0 * 3 })`
 
 
 `RULE #5 • Trailing Closures :`
 
 `numbers.map() { $0 * 3 }`
 
 
 `RULE #6 • Ignoring Parentheses :`
 
 `numbers.map { $0 * 3 }`
 
 
 It all does the exact same thing .
 Each of the rules I just went over
 is a section in the closures chapter of Apple's official Swift book .
 So if things are unclear , take the time to read it .
    Now that we know how to write
 a `closure` ,
 a `closure expression` ,
 and how we can express that in `shorthand syntax` .
 For the entire time — for this entire example —
 we have been using this `map()` function .
 `map()` — if you think about —
 looks similar to the `apply()` function we defined earlier .
 But there is a bit more to it . In fact ,
 Swift contains a lot of useful functions that take closures .
 Over the next few videos ,
 let's build up a few of these functions on our own
 from the ground up ,
 so we understand how it works .
 */



/**
 * `NOTE` , OLIVIER :
 * You can mix different elements of the `shorthand syntax` with each other .
 * Over here I have applied `RULE #6` with `RULE #1` :
 */

let tripleNumbers7 =
    
    numbers.map { (value: Int) -> Int in
        
        return value * 3
    }
