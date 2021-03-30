import Foundation


/**
 `CHAPTER 3`
 `Value Semantics , Type Methods , and Inheritance`
 We have worked with both value and reference types in Swift before ,
 but we haven't explored some of the quirks ,
 especially if you mix the two together .
 In the next set of videos ,
 let's take a look at what immutability means
 in the context of either type .
 We'll also look at adding methods to a type
 and how we can prevent classes from being subclassed .
 */



/**
 `1 Value Semantics`
 INTRO — We have worked with value types in Swift
 but we haven't examined how they behave when we try to mutate data .
 In this video we take a look at the deep copy behaviour
 across value types in Swift .
 */
/**
 In the next few videos ,
 we are going to learn about some of the tricks Swift can play on you
 if you aren't totally familiar with the underlying semantics of different types .
 First up, let's take a look at value types .
 Value types in Swift include
 `Struct` ,
 `Enum` ,
 `Array` ,
 and other native types .
 But we are going to use a `Struct` here as an example .
 The concepts apply to all other value types as well .
 */

struct Point {
    
    var x: Int
    var y: Int
}

/**
 This is an example we have seen many times now
 and let's use it to clarify a few things .
 In here we have declared the stored properties of the Struct
 using the keyword `var` making them variable stored properties .
 Now let's create two instances :
 */

var p1 = Point(x : 1 , y : 2)
var p2 = p1

p1.x = 4

/**
 Here we have an instance of Point assigned to p1 ,
 then we assign p1 to p2 .
 If we change the x value on p1 to some other value , like 4 .
 We can inspect p2
 and see what happens .
 You might already know this
 but let's talk about it anyway .
 */

print(p1)
// prints Point(x: 4, y: 2)
print(p2)
// prints Point(x: 1, y: 2)

/**
 With value types ,
 this modification to p1 to the x value on p1
 leaves the x value on p2 unchanged
 because a value type is copied on assignment .
 We are not assigning p1 to p2 directly ,
 we are copying the underlying value and assigning a separate copy to p2 .
 That is done automatically for us .
 Okay ,
 now let's create another instance of Point ,
 and assign it to a constant p3 :
 */

let p3 = Point(x : 2 , y : 4)

/**
 Looking at the declaration of Point , which is up here ,
 
 `struct Point {`
 
    `var x: Int`
    `var y: Int`
 `}`
 
 with properties declared as variables ,
 can we change the value of x for p3 ?
 No ,
 if you tried out the answers , of course no .
 When you assign a value type to a constant or a variable
 you create an immutable value that cannot be changed .
 Now this has nothing to do with the underlying properties
 even though they are variables .
 */

// p3.x = 3 // ERROR : Cannot assign to property: 'p3' is a 'let' constant .

/**
 Here p3
 the constant
 is immutable :
 
 `let p3 = Point(x : 2 , y : 4)`
 
 And once a value is assigned to that constant
 — using the box analogy — that constant is closed and locked off .
 You could still change the underlying properties ,
 but that means
 changing the value
 assigned to the constant ,
 which we cannot do .
 When it is a variable holding the value ,
 you can change the value ,
 provided it is a variable stored property .
 This should make intuitive sense based on what you know so far
 and might seem like old news ,
 but bare with me .
 To further prove this point ,
 let's declare another Struct :
 */

struct AnotherPoint {
    
    let x: Int
    let y: Int
}

var p4 = AnotherPoint(x : 1 , y : 2)

/**
 Again we have x and y stored properties ,
 but this time they are constants .
 We have assigned the instance of AnotherPoint to a variable , named p4 .
 In this case ,
 if we try to change the x value on p4 ,
 */

// p4.x = 2 // ERROR : Cannot assign to property: 'x' is a 'let' constant .

/**
 this doesn't work either .
 This is because the container that holds the value is a variable .
 So we can assign an entirely different value to it if we wanted to .
 But the properties of the underlying values on the AnotherPoint instance are immutable
 since they are constants :
 
 `struct AnotherPoint {`
 
    `let x: Int`
    `let y: Int`
`}`

 So what is variable here , is
 the link
 to the value ,
 and not
 the value itself :
 
`var p4 = AnotherPoint(x : 1 , y : 2)`
 
 All `var` means here , is ,
 that we can assign an entirely different instance of AnotherPoint to p4
 and it won't complain .
 So if I were to do
 */

p4 = AnotherPoint(x : 2 , y : 4)

/**
 This works , there is no problem .
 So in the first case ,
 
 `var p1 = Point(x : 1 , y : 2)`
 `p1.x = 4`
 `p1 = Point(x : 3 , y : 4)`
 
 both the link to the value
 and the value itself could be modified .
 So we could change the x value
 and we could change the point instance .
 But in this case ,
 
 `var p4 = AnotherPoint(x : 1 , y : 2)`
 `p4 = AnotherPoint(x : 2 , y : 4)`
 
 we can change the value that is assigned ,
 we can add another instance ,
 or we can assign another instance completely ,
 — a different one to p4 — and that is okay
 but because the underlying properties are constants
 
 `struct AnotherPoint {`
 
    `let x: Int`
    `let y: Int`
 `}`
 
 they cannot be changed .
 
 `p4.x = 2 // ERROR`
 
 So let's make sure we have all that down .
 In the first case ,
 we have a structure Point that has variable storage properties :
 
 `struct Point {`
 
    `var x: Int`
    `var y: Int`
 `}`
 
 We assign an instance to p1 .
 We assign p1 to p2 , ...
 
 `var p1 = Point(x : 1 , y : 2)`
 `var p2 = p1`
 
 ... and all that means , is ,
 we are creating a copy of p1 and assigning it to p2 .
 We can do that again because these —p1 and p2— are all variables
 so you can copy and reassign as much as you want .
 And because the underlying stored properties are variables
 
 `struct Point {`
 
    `var x: Int`
    `var y: Int`
 `}`
 
 we can also mutate those variables — those stored properties —
 and assign different values :
 
 `p1.x = 4`
 
 Now in this case in p3 ,
 
 `let p3 = Point(x : 2 , y : 4)`
 
 we are assigning an instance of Point to a constant , p3 .
 The constant part here is the reason that you cannot assign
 a completely different instance to p3 ,
 because once it has that initial value ,
 it is closed off , it is locked down .
 The reason we can't even change the underlying values ,
 
 `p3.x = 3 // ERROR`
 
 even though they are variables , is ,
 because with Swift that involves assigning a new copy .
 So changing the value of x , means ,
 creating a new copy
 and assigning that copy back to p3 .
 And we cannot do that because it is a constant .
 So this is why — even though it is a variable stored property —
 using a constant container — let p3 — ,
 you cannot change it .

 In the case of `AnotherPoint` ,
 
 `struct AnotherPoint {`
 
    `let x: Int`
    `let y: Int`
`}`
 
 we can again create an instance and assign it to a variable :
 
 `var p4 = AnotherPoint(x : 1 , y : 2)`
 
 The variable part here is , what instance is assigned :
 
 `AnotherPoint(x : 1 , y : 2)`
 
 So we can assign a totally different instance ,
 because p4 is variable :
 
 `p4 = AnotherPoint(x : 2 , y : 4)`
 
 But because the stored properties are constants ...
 
 `struct AnotherPoint {`
 
    `let x: Int`
    `let y: Int`
`}`
 
 ... we cannot change those , even on a variable .
 Okay , now , let’s go back to Point up at the top .
 I want to add an instance method here that says `moveLeft()`
 and then take a certain number of steps .
 So that should be simple :
 */

struct Point2 {
    
    var x: Int
    var y: Int
    
    
    func moveLeft(steps: Int) {
        // x -= steps // ERROR : Left side of mutating operator isn't mutable: 'self' is immutable .
    }
}

/**
 When we `moveLeft()` , all we are doing , is ,
 decreasing the value of x by the number of steps in our grid ,
 minor problem though ,
 this doesn't work . So why , why does this happen ?
 We should be able to change the value of x here
 because x is a variable :
 
 `var x: Int`
 
 When we change the value of x on the instance earlier using dot notation , ...
 
 `var p1 = Point(x : 1 , y : 2)`
 `p1.x = 4`
 
 ... I mentioned that there is some magic going on .
 Swift was performing some magic for us under the hood ,
 value types are always immutable by design .
 Meaning that we cannot mutate or change the value .
 What is happening when we seemingly change the value , is ,
 that Swift creates a copy of our Struct .
 So with p1
 it is creating a copy of this Point instance .
 
 `var p1 = Point(x : 1 , y : 2)`
 
 It is assigning a new value to the property x
 
 `Point(x : 4 , y : 2)`
 
 and then
 it assigns this brand new Struct
 back to the variable :
 
 `p1`
 
 So this is why
 when it is assigned to a constant
 
 `let p3 = Point(x : 2 , y : 4)`
 
 we cannot change the value of the stored property
 even if the property is declared as a variable :
 
 `struct Point {`
 
    `var x: Int`
    `var y: Int`
 `}`
 
 In this case if I were to do
 
 `p3.x = 3 // ERROR`
 
 again , remember ,
 mutating the value of x
 means
 that Swift attempts to create a copy of the instance
 and then assign that new value to x :
 
 `Point(x : 3 , y : 4)`
 
 All of which it can still do when it is assigned to a constant
 but because the link between the container
 
 `let p3`
 
 and the instance
 
 `Point(x : 3 , y : 4)`
 
 cannot be changed
 we cannot reassign that new copy back
 to the constant
 which is why this fails :
 
 `p3.x = 3 // ERROR`
 
 So in our method here ,
 
 `struct Point2 {`
 
    `var x: Int`
    `var y: Int`
 
    `func moveLeft(steps: Int) {`
        `// x -= steps // ERROR : Left side of mutating operator isn't mutable: 'self' is immutable .`
    `}`
 `}`
 
 _What is going on ?_
 We have a method that mutates a value of x .
 Even though we have declared the property x as a variable
 we can't mutate it just yet
 because we can't directly change the value of a value type .
 To do this ,
 we have to create a copy ,
 and assign the value we want to the new copy .
 Now this was done for us automatically
 when we changed stored property values
 and thankfully ,
 it is not that complicated if we want to do it with a method .
 All we need to do , is ,
 add the `mutating` keyword
 to the function signature or the function declaration ,
 */

struct Point3 {
    
    var x: Int
    var y : Int
    
    
    mutating func moveLeft(steps: Int) {
        x -= steps
    }
}

/**
 and now our errors go away .
 What this does , is ,
 it tells the compiler ,
 hey this is a value type ,
 but this method is trying to mutate it .
 So go ahead and do your copy magic under the hood .
 
 
 
 Okay , let's take a break here .
 As you can see ,
 value types do a bit of magic under the hood for us
 to keep things safe and immutable .
 In the next video ,
 we'll see what goes on with reference types .
 */
