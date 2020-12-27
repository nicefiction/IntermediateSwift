import Foundation


/**
 `5 Initialising Superclasses`
 INTRO — Designated and convenience initialisers are fairly simple
 when we only have to deal with a single class .
 What happens if we have to worry about initialising superclasses ?
 */
/**
 Starting from where we left off in our first video with a Vehicle class ,
 let's create a new class , Car , that inherits from it :
 */
class Vehicle {
    
    var name: String
    
    
    init(name: String) {
        
        self.name = name
    }
    
    
    convenience init() {

        self.init(name : "Unnamed")
    }
}

/*
class Car: Vehicle {
    let numberOfDoors: Int
}
 */
/**
 The Car class inherits from Vehicle ,
 and adds a single stored property requirement , the numberOfDoors in the car .
 Now Xcode is going to complain because we don't have a designated initialiser . Remember a designated initialiser is responsible for
 ( 1 ) calling any initialisers in its superclass chain
 and ( 2 ) getting that entire chain ready for use .
 Since we need to initialise the name property that belongs to the Vehicle class as well , we'll create a parameter or argument for the name . So we'll say
 */
class Car: Vehicle {
    
    var numberOfDoors: Int
    
    
    init(numberOfDoors: Int ,
         name: String) {
        
        self.numberOfDoors = numberOfDoors
        
        super.init(name : name)
    }
}
/**
 So in here , we say
 `self.numberOfDoors = numberOfDoors`
 And then once that is done ,
 we are going to call the designated initialiser of the superclass
 `super.init(name : name)`
 
 ! This is important :
 You can only call a convenience initialiser ,
 that is written within the same class
 inside an init( ) method .
 So inside this init( ) method ,
 `init(numberOfDoors: Int , name: String) { ... }`
 we cannot call
 any of the convenience initialisers
 on the _Vehicle class_ .
 So instead ,
 we call `super.init( )` ,
 and pass in the _name_ :
 `super.init(name : name)`
 
 Okay ,
 our designated initialiser is done .
 Pretend that we go on using this class through our code .
 But we noticed that nine times out of ten ,
 the value for numberOfDoors during initialisation is always 4 .
 Let's write a convenience initialiser
 so that we don't have to repeat that work over and over ...
 */
class Car2: Vehicle {
    var numberOfDoors: Int
    
    
    init(numberOfDoors: Int ,
         name: String) {
        
        self.numberOfDoors = numberOfDoors
        
        super.init(name : name)
    }
    
    
    convenience override init(name: String) {

        self.init(numberOfDoors : 4 ,
                  name : name)
    }
}
/**
 Subclasses do not inherit the initialisers from the superclass by default .
 Instead ,
 if we want to use one of the same initialisers in a subclass
 that we have defined in the base class ,
 we need to `override` that init( ) method .
 So here , ...
 `convenience override init(name: String) { ... }`
 ... we are defining an init( ) method
 that has already been defined in the base class :
 `class Vehicle {`
    `init(name: String) { ... }`
 `}`
 So instead of just being able to define this as a convenience initialiser here
 because the base class already has it ,
 we need to go ahead and insert the `override` keyword to override it :
 `convenience override init(name: String) { ... }`
 Inside this body ,
 `convenience override init(name: String) {`
    `self.init(numberOfDoors : 4 , name : name)`
 `}`
 because this is a convenience init( ) for the Car class ,
 we can call the Car classes designated initialiser
 with a default argument for doors .
 `NOTE` how the convenience initialiser only takes an argument for _name_
 since _numberOfDoors defaults_ to — is always going to be — _4_ .
 
 Okay ,
 now just for fun ,
 let's write one more init( ) method .
 In this case I want the doors to always default to 4 ,
 and the name to always be unnamed .
 Basically , I want to create an instance of Car
 without having to worry about passing in any parameters .
 So let's create another convenience initialiser :
 */
class Car3: Vehicle {
    
    var numberOfDoors: Int
    
    
    init(numberOfDoors: Int ,
         name: String) {
        
        self.numberOfDoors = numberOfDoors
        
        super.init(name : name)
    }
    
    
    convenience override init(name: String) {

        self.init(numberOfDoors : 4 ,
                  name : name)
    }
    
    
    convenience init() {
        self.init(name : "Unnamed")
    }
}
/**
 Because this convenience initialiser
 does not override
 any of the superclasses designated init( ) methods ,
 we don't need to mark it with the keyword `override` .
 We had to do that here ...
 `convenience override init(name: String) { ... }`
 ... because init( ) with _name_ is the designated initialiser for the base class .
 Now ,
 inside the body of this convenience initialiser , ...
 `convenience init() {`
    `self.init(name : "Unnamed")`
 `}`
 ... instead of directly calling the designated init( ) ,
 we are instead calling another convenience initialiser method here ,
 `convenience override init(name: String) {`
    `self.init(numberOfDoors : 4 , name : name)`
 `}`
 I am calling from within this convenience initialiser ,
 `convenience init() {`
    `self.init(name : "Unnamed")`
 `}`
 I am calling this one right here that only takes a name ,
 `convenience override init(name: String) { ... }` .
 because the work of creating an instance with numberOfDoors defaulting to 4
 is already done by the other convenience initialiser ,
 `convenience override init(name: String) {`
    `self.init(numberOfDoors : 4 , name : name)`
 `}`
 We can use it to set up this init( ) method ,
 `convenience init() {`
    `self.init(name : "Unnamed")`
 `}`
 
 So there we go ,
 we now have one designated initialiser ,
 and two convenience initialisers
 that allow us to create instances in a flexible manner .
 */



/**
 There were a lot of specific rules involved here ,
 so let's summarise them :
 
 `Rule number 1` ,
 ( 1 ) every class must have a designated initialiser .
 If this class inherits from another ,
 the designated initialiser is ( 2 ) responsible for
 calling the designated initialiser of its immediate superclass .
 
 `Rule number 2` ,
 classes can have ( 1 ) any number of convenience initialisers .
 A convenience initialiser must
 ( 2 ) call another initialiser from the same class ,
 whether it is a designated initialiser ,
 or another convenience initialiser .
 
 `Rule number 3` ,
 convenience initialisers must eventually call a designated initialiser .
 Let's look at a quick example ,
 here we have a class with a single designated initialiser :
 `See image page 66 .`
 
 Next ,
 we create a subclass :
 `See image page 66 .`
 This subclass
 also contains a designated initialiser
 whose responsibility it is
 to call the designated initialiser of its parent .
 While it is typical to have mostly one designated initialiser ,
 you can have more than one ,
 so let's add another to our subclass :
 `See image page 67 .`
 
 Since this is
 a designated initialiser ,
 it also calls the initialiser of its parent .
 Let's add a new convenience init( ) method to the superclass now :
 `See image page 67 .`
 
 Remember
 that a convenience initialiser must ultimately call
 the classes designated initialiser .
 We can add another convenience initialiser
 which also calls the first convenience initialiser :
 `See image page 67 .`
  
 Since the first convenience initialiser ultimately calls a designated initialiser ,
 the second convenience initialiser ultimately does as well .
 And we can add a convenience initialiser to the subclass that calls
 either one of its designated initialisers :
 `See image page 68 .`
 
 By looking at this visual , a pattern should emerge .
 Designated initialisers always delegate instantiation up the chain .
 Convenience initialisers always delegate across the chain .
 
 Here's a quick look at a more complex example
 where we see a more complex inheritance chain :
 `See image page 68 .`
 Again ,
 we see that designated init's go up the chain and convenience init's go across the chain .
 This might seem complicated , but in practice , you quickly internalise things ,
 if you follow our three simple rules :
 `RULE #1` :
 • Every class must have a designated initialiser .
 • Responsible for calling superclass' designated initialiser .
 `RULE #2` :
 • Any number of convenience initialiser .
 • Can call other initialisers in the same class .
 `RULE #3` :
 • Convenience initialisers must call a designated initialiser eventually .
 
 After working with these for a little while ,
 it will become second nature ,
 and even if it doesn’t ,
 the compiler will warn you .
 */

print("Hello world")
