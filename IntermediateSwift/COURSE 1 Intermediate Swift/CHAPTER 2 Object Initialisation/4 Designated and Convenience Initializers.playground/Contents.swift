import Foundation



/**
 `4 Designated and Convenience Initialisers`
 INTRO — The initialisers we have been writing so far
 are more formally called
 `designated initialisers`
 and serve as the main point of instantiation for an object .
 In this video
 let's take a look at the difference between
 convenience and designated initialisers .
 */
/**
 Unlike initialisation in value types ,
 where only the types properties have to be initialised .
 Initialisation in a reference type
 involves
 assigning initial values to both
 (`A`) the classes stored properties ,
 as well as (`B`) any properties inherited from its super or base class .
 This makes things a bit more complex .
 Classes in Swift have two different types of initialisers
 to help ensure that all stored properties have initial values
 (`1`) `designated initialisers`
 and (`2`) `convenience initialisers` .
 
 
 `1. DESIGNATED INITIALIZERS`
 
 `•` Central point of initialization .
 `•` Classes must have at least one .
 `•` Responsible for initializing stored properties .
 `•` Responsible for calling `super init` .
 
 A `designated initialiser` is the primary initialiser for the class
 and the one that is responsible for
 assigning values to its stored properties
 and then calling the appropriate `superclass initialiser`
 to continue initialisation up the chain .
 The initialisers we have been writing for our classes all along
 have been designated initialisers .
 `Designated initialisers` are the central point of initialisation .
 So typically classes only have one ,
 in fact they must have at least one .
 Classes cannot exist without a designated initialiser ,
 but you already knew this
 because we get an error if we don't define an `init()` method .
 We just weren't calling it a designated initialiser .
 Let's take a look at an example now :
 */

/*
class Vehicle {
    
    var name: String
    
    
    init(name: String) {
        
        self.name = name
    }
}
 */

/**
 We have created a `class` named `Vehicle` .
 `Vehicle` is going to be pretty bare bones ,
 and we'll just give it a stored property to keep track of a `name` .
 Now classes need `init()` methods ,
 in fact they must have at least one `designated initialiser` ,
 so we have added one ,
 
 `init(name: String) { self.name = name }`
 
 This is a `designated initialiser` ,
 and as you can see ,
 the syntax is just writing a normal `init()` method
 like we have been used to .
 
 
 `CONVENIENCE INITIALIZER`
 
 The second kind of initialiser we have , is , a `convenience initialiser` .
 Convenience initialisers are secondary ,
 supporting initialisers for a class
 — like we wrote an initialiser that delegates to the primary one in a value type
 namely the `struct` `Rectangle` in the last video —
 a `convenience initialiser` can call a `designated initialiser`
 from within the same `class`
 with some of the parameters set to a default value .
 Now , just to highlight that point ,
 a `convenience initialiser` can only call a `designated initialiser`
 that is defined
 in the same `class` .
 Let's write it in just a second ,
 but before that ,
 it is worth pointing out
 initialising our `class` ,
 currently always requires a `name` .
 Let's pretend that this `name` property is not the car's brand name ,
 but something we affectionately name our car .
 Now , not everyone does this ,
 so it can be cumbersome to call the `designated initialiser` every time
 and write in something like
 _unnamed_ .
 Instead we can write a `convenience init()` method to handle this .
 So we'll say :
 */

/*
class Vehicle {
    var name: String
    
    
    init(name: String) { self.name = name }
    
    
    convenience init() { self.init(name : "unnamed") }
}
 */

/**
 To mark an initialiser as a `convenience init()` ,
 we use the _convenience_ keyword
 and then write an `init()` method as usual .
 
 `NOTE` : Here we are not accepting any parameters
 because we are going to provide a default value for the _name_ parameter .
 
 `NOTE` : If we were to try and assign the String _unnamed_  ...
 */

/*
class Vehicle {
    var name: String
    
    
    init(name: String) {
        
        self.name = name
    }
    
    
    convenience init() {
        self.name = "unnamed" // ERROR : 'self' used before 'self.init' call or assignment to 'self' .
    }
}
*/

/**
 We get this error
 and that is because in a `convenience initialiser`
 you need to call your `designated initialiser` first
 before you can assign any values to stored properties .
 
 Basically in a `convenience init()`
 the `class` has to be set up first .
 So inside the `convenience init()`
 instead of doing this ...

 `class Vehicle {`
 
    `var name: String`
 
 
    `init(name: String) {`
 
        `self.name = name`
    `}`
 
 
    `convenience init() {`
 
        `self.name = "unnamed" // ERROR : 'self' used before 'self.init' call or assignment to 'self' .`
    `}`
 `}`

 ... we call on the `designated initialiser`
 to do the work
 and use _unnamed_
 as that default argument :
 */

class Vehicle {
    
    var name: String
    
    
    init(name: String) {
        
        self.name = name
    }
    
    
    convenience init() {
        
        self.init(name : "unnamed")
    }
}
/**
 When creating an instance of this `class` `Vehicle` ,
 
 `Vehicle()`
 
 we can use the `convenience initialiser` just like a normal initialiser
 and it recognises it .
 
 
 
 There we go ,
 as you can see the instance was created.
 `Convenience initialisers` aren't required , that sort of implied ,
 they are just initialisers that we can write for a convenience use cases .
 But that was a simple case ,
 where we only had to worry about a single class ,
 what happens if we have a superclass chain ?
 Let's find out.
 Onto the next video.
 */
