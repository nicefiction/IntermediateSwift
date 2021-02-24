import Foundation


/**
 `2 Automatic Reference Counting`
 INTRO — `Automatic Reference Counting` (`ARC`)
 is a huge boon for developers .
 Let's explore how `ARC` does its job ,
 so we can keep watch of our memory footprint
 — even when `ARC` does most of the heavy lifting for us .
 */
/**
 Under `ARC` ,
 the burden of `memory management`
 is moved
 from the programmer
 to the `compiler` .
 As you obviously know from writing code so far ,
 memory management is handled for you
 and you don't need to worry about retaining and releasing objects .
 As nice as that is ,
 it is also worth taking a look at how `ARC` handles things for us .
 
 `NOTE` : By the way — in case it wasn't obvious —
 since `ARC` stands for `Automatic Reference Counting`
 all this memory management stuff
 only applies to `reference types` .
 Structs and the like , are value types .
 They aren't passed around by reference .
 Keeping track of the same object and its ownership
 doesn't matter with Structs .
 
 When you create an instance of a class ,
 `ARC` allocates space in memory for your class .
 This chunk of memory holds information about
 ( 1 ) the type of instance
 and ( 2 ) the values of its stored properties .
 As long as we use the instance of that class in some way ,
 the memory remains allocated .
 But the second we are done with it ,
 `ARC` frees it up
 to be used for other purposes .
 This ensures that we can create
 as many instances as we want
 without worrying about memory consumption .
 If we were using an object
 — either by accessing properties or calling its instance methods —
 but `ARC` had deallocated the memory ,
 our app would crash .
 To prevent this from happening ,
 `ARC` keeps track of how many properties , constants , and variables
 are holding on to
 an instance of the class .
 For example ,
 if we create an instance of a `SomeClass` and assign it to `someVariable` ,
 
 `let someVariable = SomeClass()`
 
 `ARC` keeps track of this reference .
 As long as there is
 at least one active reference
 `ARC` will not deallocate the memory used .
 This type of reference
 when a class is assigned to a property constant or variable
 is known as a `Strong Reference` .
 We call it a Strong Reference
 because as long as the reference exists
 the memory occupied by the instance isn't deallocated .
 Let's take a look at an example :
 */

class Food {
    
    var name: String
    
    
    init(name: String) {
        
        self.name = name
        
        print("Memory allocated to \(name) .")
    }
    
    
    deinit {
        
        print("\(name) is being deinitialised . Memory deallocated .")
    }
}

/**
 When a class is initialised ,
 memory is allocated .
 So inside the `init()` method
 we simply log a statement to show us that this is happening .
 Just like an `init()` method sets up a class
 there is another special method that is called when a class is broken down
 and it is called the `deinit()` method .
 We have never talked about the `deinit()` method before
 and that is
 because we have never created a class so complex
 that we needed to manually break it down .
 Let's use the `deinit()` method here ,
 for a really simple purpose .
 To indicate when the class is actually deallocated :
 
 `deinit {`
 
    `print("\(name) is being deinitialised . Memory deallocated .")`
 `}`
 
 Now let's give this a try .
 Let's create an instance of the `Food` class
 and assign it to a variable
 thereby creating our first reference :
 */

var appleReference1: Food? = Food(name : "apple")

/**
 `NOTE` : We are setting the type of this variable to `optional Food`
 because we want to zero out the reference by setting it to `nil` in just a second .
 
 Okay ,
 so now we have one strong reference
 and if you look at the console ...
 */

// CONSOLE :
// Memory allocated to apple .

/**
 ... you see the `print()` statement .
 Remember that a reference is created
 every time an instance is assigned to a variable constant , or stored property .
 So if I were to reassign this instance to a second variable ,
 */

var appleReference2 = appleReference1

/**
 Now we have two strong references to it .
 And remember that `ARC` won't deallocate the memory
 as long as there is one ,
 at least one strong reference .
 If I were to set `appleReference1` to `nil` ,
 */

appleReference1 = nil

/**
 you aill notice that the `deinit()` method ,
 the body of the `deinit()` method ,
 our log statement hasn't been called ,
 because the instance is still alive and well in `appleReference2` .
 We still have a `strong reference` to that instance .
 By finally setting the second and only reference remaining to `nil` ,
 */

appleReference2 = nil

/**
 `ARC` now knows
 that we are done using this object .
 And look at that ,
 */

// CONSOLE :
// apple is being deinitialised . Memory deallocated .

/**
 in the console
 we see that the object has been deinitialised
 and the memory has been deallocated .
 So that was a quick primer on how `ARC` does its job .
 _Why does this matter though ?_
 On to the next video .
 */
