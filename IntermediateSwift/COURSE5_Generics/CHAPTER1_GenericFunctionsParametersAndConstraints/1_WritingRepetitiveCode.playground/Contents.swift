import Foundation


/**
 `COURSE 5`
 `Generics in Swift`
 Swift is a powerful , flexible , and safe language
 and those characteristics are all embodied by Generics .
 Let's explore how you can use generics
 to make your code reusable , elegant , and clean .
 
 What you will leearn :
 • Generic types
 • Generic functions
 • Associated types
 */



/**
 `CHAPTER 1`
 `Generic Functions , Parameters , and Constraints`
 A problem we run into often when programming is
 how to avoid writing repetitive code
 without sacrificing safety .
 In the past we have solved this
 using concepts like
 functions and objects
 but they can only take us so far .
 Over the next few videos ,
 we are going to take a look at
 how generics can help augment our knowledge
 to elegantly solve these problems .
 */
/**
 1 Writing Repetitive Code
 INTRO — A common problem we are always trying to solve
 in programming , is ,
 how to avoid writing repetitive code .
 Previously we have solved this
 by using functions and objects ,
 but sometimes even those constructs can be repetitive .
 Before we look at a solution ,
 let's take a look at an example where our current knowledge doesn't suffice .
 */
/**
 Today we are going to explore one of Swift's more important language features , generics .
 We have always talked about Swift being a powerful language
 and one of the aspects of this power lies in being able to write generic code .
 Very often , when you code — especially as you climb the steep learning curve —
 many of the really gratifying moments come
 when you craft something to synch code that lets you solve a repetitive problem
 without writing repetitive code .
 The first time you learned about loops ,
 you probably found that to be an elegant construct .
 Even more so
 when you learned that the same protocol
 could be applied
 to a variety of structures .
 Generics offer that kind of catalytic power ,
 in that they can speed up your development time ,
 while at the same time keeping things neat and safe .
 At their root ,
 generics solve a really simple problem .
 Like the name suggests
 by using generics ,
 we can write code that achieves a certain task
 over a wide range of different kinds of inputs .
 Let’s start a new Playground page ,
 and we'll define a simple function to swap two values :
 */
func swapInts(_ a: Int ,
              _ b: Int) {
    
    // let tempA = a
    // a = b // ERROR : Cannot assign to value: 'a' is a 'let' constant .
    // b = tempA // ERROR : Cannot assign to value: 'b' is a 'let' constant .
}


var d = 10
var e = 12

swapInts(d , e)
/**
 For now we are swapping two integer values . So ,
 we call the method swapInts( ) and the method takes as arguments two Integer values .
 To be in line with our Swift API design guidelines
 we are going to omit both external argument names
 because we can't meaningfully distinguish between the two
 beyond calling them valueOne or valueTwo . So , we use an underscore .
 This function won't have a return type because all we are going to do , is ,
 assign the value stored in b to a , and vice versa .
 Inside the body of the function ,
 we assign the value in a to a temporary constant — let tempA —
 `let tempA = a`
 we assign to a the value in b ,
 and then we'll assign to b , the value that was in a — which is now inside tempA .
 Except this is not going to work .
 ` a = b // ERROR : Cannot assign to value: 'a' is a 'let' constant .`
 `b = tempA // ERROR : Cannot assign to value: 'b' is a 'let' constant .`
 The reason being that arguments passed to a function over here
 `swapInts(d , e)`
 — as we know — are assigned to constants with the name specified in the function :
 `func swapInts(_ a: Int , _ b: Int) { ... }`
 So ,
 `a` is a constant containing the value that was passed in as an argument .
 `a` and `b` here ,
 are not the actual variables used outside the function ,
 but simply , values .
 For example , if down here I would create two variables ,
 `var d = 10`
 `var e = 12`
 And if we were to now call `swapInts( )`
 and pass these two as arguments to the function :
 `swapInts(d , e)`
 All we are doing , is ,
 assigning `10` — `d` — to the constant `a` ,
 and then `12` — `e` — to the constant `b` .
 What we'd like to do , is ,
 actually pass in the variables `d` and `e` .
 And we can do that by adding a special keyword to the argument type .
 Back in the function definition
 the keyword we are going to add , is  ,` inout` :
 */
func swapInts2(_ a: inout Int ,
               _ b: inout Int) {
    
    let tempA = a
    a = b
    b = tempA
}

swapInts2(&d , &e)
/**
 `NOTE` : I add the `inout` keyword
 right before we specify the type of the arguments ,
 and we do that for both `a` and `b` .
 `func swapInts2(_ a: inout Int , _ b: inout Int) { ... }`
 When we use the `inout` keyword ,
 we are not passing the values assigned to our variables `d` and `e`  .
 Instead ,
 we are passing in the addresses in memory where those values are stored .
 The address of the variable itself .
 So , as you can see ,
 now the body of the function works .
 And that is because we are actually passing in the variable ,
 not the value ,
 the variable .
 When we do this assignment here .
 `let tempA = a`
 `a = b`
 `b = tempA`
 We are assigning the value stored
 at the memory address assigned to `a`
 and to the memory address assigned to `b` ,
 So , `tempA` has a value inside the memory address of `a` and so on .
 When we call the function ,
 let me get rid of this and call it again :
 `swapInts2(&d , &e)`
 You see now that there are ampersands preceding each argument .
 And again , this is to specify that we are passing in variables themselves and not the values .
 Essentially ,
 all we have done here , is ,
 pass by reference rather than value .
 Anyway , none of this is the point of the course . Although ,
 you now know about a new feature of functions .
 But finally ,
 after doing all this ,
 we can swap to integer values and you'll see now that over here
 `func swapInts2(_ a: inout Int ,`
                `_ b: inout Int) {`
 
    `let tempA = a`
    `a = b`
    `b = tempA`
 `}`
 
 `var d = 10`
 `var e = 12`
 
 `swapInts2(&d , &e)`
 if I were to call `d` here and then `e` ,
 */
d // 12
e // 10
/**
 you see that they are now 12 and 10 respectively .
 We have managed to swap the values .
 So these were integers .
 _What if we wanted to swap two Strings ?_
 Okay , let's try that with this function :
 */
var f = "Dorothy"
var g = "Gale"

// swapInts2(&f , &g) // ERROR : Cannot convert value of type 'String' to expected argument type 'Int' .
/**
 If I call `swapInts2( )` , and pass in `g` and `h` ,
 well obviously , it doesn't work because these are not integers .
 For that we need to define a new function .
 So let's try that real quick :
 */
func swapStrings(_ a: inout String ,
                 _ b: inout String) {

    let tempA = a
    a = b
    b = tempA
}
/**
 Inside the function
 we assign to a constant named `tempA`
 the value at the memory address of the variable `a` .
 Okay ,
 now that we have this function to swapStrings ,
 we can call it :
 */
swapStrings(&f , &g)
f // "Gale"
g // "Dorothy"
/**
 And now you'll see that this swap has happened .
 If we examine the bodies of both of our functions ,
 `func swapInts2(_ a: inout Int ,`
                `_ b: inout Int) {`
 
    `let tempA = a`
    `a = b`
    `b = tempA`
 `}`
 
 
 `func swapStrings(_ a: inout String ,`
                  `_ b: inout String) {`
 
    `let tempA = a`
    `a = b`
    `b = tempA`
 `}`
 you see that they are absolutely identical .
 We are doing the exact same work here .
 The only difference is
 that each function accepts a different type as an argument .
 So in both of these functions
 the only difference beyond the name here , is
 the type of the arguments .
 Everything else is the same .
  
 Creating many functions that do the exact same work ,
 is the opposite of good programming .
 We want to minimise the surface area over which we can make mistakes ,
 given a good implementation of swap
 it should work with integers , floats , doubles , strings , and so on .
 One way we could achieve this
 — with the knowledge we currently have at hand —
 is to use a higher type .
 So that we can pass in as arguments
 integers , floats , or strings .
 One of the higher types in Swift is `Any` .
 `Any` is a type that represents all types in Swift .
 So if we were to write a function :
 */
func swapAny(_ a: inout Any ,
             _ b: inout Any) {
    
    let tempA = a
    a = b
    b = tempA
}
/**
 The problem with this approach , is ,
 that we lose all the type safety that Swift provides .
 When I call this function ,
 there is nothing preventing me from passing through
 `d` — which contains an Integer —
 and `g` — which contains a String :
 */
// swapAny(&d , &g) // ERROR
/**
 Even without this glaring error
 the function wouldn't work
 because inside the function
 we'd have to cast to a specific type first
 before we can swap
 and we are back to square one .
 Hopefully this illustrates the problem at hand .
 We have a function that performs a common operation on different types .
 But we don't want to create a unique function for each type
 because that increases the chances of making an error
 and you just have to type the same code over and over again .
 In the next video ,
 let solve this problem using generics .
 */
