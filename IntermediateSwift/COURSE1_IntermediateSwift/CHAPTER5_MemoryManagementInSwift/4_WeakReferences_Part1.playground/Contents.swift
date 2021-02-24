import Foundation


/**
 `4 Weak References` PART 1 OF 3
 INTRO — Now that we have given ourself a memory issue ,
 namely a `retain cycle` ,
 let's see how we can resolve it .
 */
/**
 In the previous video ,
 we looked at
 how we ended up with a `strong reference cycle` .
 By default any references to an object are strong .
 To help combat the reference cycles that may arise ,
 `ARC` also allows for `weak references` .
 A `weak reference` is one
 that does not keep a strong hold
 on the instance it refers to .
 And doesn't stop `ARC` from disposing of it .
 _So how do we make a reference weak ?_
 Well it is simple , actually .
 We add the `weak` keyword to our `stored property declaration` .
 Let's go back to the `Apartment` class . And for the `tenant` property ,
 let's add the `weak` keyword before it :
 */

class Person {
    
    var name: String
    var apartment: Apartment?
    
    
    init(name: String) {
        
        self.name = name
        
        print("\(name) is being initialised . Memory allocated .")
    }
    
    
    deinit {
        print("\(name) is being deinitialised . Memory deallocated .")
    }
}



class Apartment {
    
    let unit: String
    // var tenant: Person?
    weak var tenant: Person?
    
    
    init(unit: String) {
        
        self.unit = unit
        
        print("Apartment \(unit) is being initialised . Memory allocated .")
    }
    
    
    deinit {
        print("Apartment \(unit) is being deinitialised . Memory deallocated .")
    }
}



var person: Person? = Person(name : "Dorothy")
var apartment: Apartment? = Apartment(unit: "D2A")

person?.apartment = apartment
apartment?.tenant = person

person = nil
apartment = nil

/**
 The moment you do this ,
 your console should now show deinitialisation statements for both instances ,
 as you can see right here :
 */

// CONSOLE :
// Dorothy is being initialised . Memory allocated .
// Apartment D2A is being initialised . Memory allocated .
// Dorothy is being deinitialised . Memory deallocated .
// Apartment D2A is being deinitialised . Memory deallocated .

/**
 _So what difference did the weak property make ?_
 Let's start at the beginning with our object ownership graph .
 We started off by creating two instances .
 
 `var person: Person? = Person(name : "Dorothy")`
 `var apartment: Apartment? = Apartment(unit: "D2A")`
 
 Again
 here we have two strong references
 from the variables to the instances .
 
 `var person    —————> Person`
 `var apartment —————> Apartment`
 
 Then
 we assign the instances to the stored properties of each other :
 
 `person?.apartment = apartment`
 `apartment?.tenant = person`
 
 Because the `apartment` property on the `Person` class is a regular stored property ,
 
 `class Person {`
 
    `var apartment: Apartment?`
 
    `...`
 `}`
 
 we have a strong reference going from the `Person` instance to the `Apartment` :
 
 `Person —————> Apartment`
 
 But ,
 because the `tenant` stored property on the `Apartment` class
 is marked as `weak` ,
 
 `class Apartment {`
 
    `weak var tenant: Person?`
 
    `...`
 `}`
 
 we have a `weak` reference going from `Apartment` to `Person` .
 
 `Apartment - - - -> Person`
 
 Remember
 that a `weak reference` tells `ARC`
 to basically ignore it .
 An instance can have three `weak` references and one `strong` reference .
 But for all intents and purposes , its `reference count` is `1` .
 When we set the `Person` instance to `nil`
 
 `person = nil`
 `// apartment = nil`
 
 this zeroes out any strong references pointing to it
 and the object can be safely deinitialised ,
 and memory deallocated .
 
 `// CONSOLE : `
 `// Dorothy is being initialised . Memory allocated .`
 `// Apartment D2A is being initialised . Memory allocated .`
 `// Dorothy is being deinitialised . Memory deallocated .`
 
 `ARC` only cares about `strong references` ,
 so it doesn't matter that there was a `weak reference`
 going from `Apartment` to `Person` :
 
 `var person             Person`
 `var apartment —————––> Apartment`
 `Person        —————––> Apartment`
 `Apartment     - - - -> Person`

 Finally ,
 when we set the `apartment` variable to nil ,
 
 `person = nil`
 `apartment = nil`
 
 this zeros out all strong references to the `apartment` instance
 and we can safely deinitialise it , and free up memory ,
 
 `// CONSOLE : `
 `// Dorothy is being initialised . Memory allocated .`
 `// Apartment D2A is being initialised . Memory allocated .`
 `// Dorothy is being deinitialised . Memory deallocated .`
 `// Apartment D2A is being deinitialised . Memory deallocated .`

 `NOTE` : If you are wondering
 why that `weak var` looks familiar ,
 it is because you have seen it many times before in iOS code :
 
 `@IBOutlet weak var funFactLabel: UILabel!`
 
 `IBOutlets`
 — or `Interface Builder Outlets` —
 are created as `weak stored properties` by default .
 This is because of ViewControllers maintain a reference to the outlet
 and the outlet maintains a reference to the ViewController .
 If they were both strong references ,
 we could never deallocate the Outlet or the ViewController .
 When we built our first app ,
 I told you I'd explain what the `weak` keyword meant .
 Well , there you go . Now you know .
 
 There are a couple things to keep in mind ,
 when the `person` instance was deallocated
 
 `person = nil`
 
 `CONSOLE`
 `Dorothy is being deinitialised . Memory deallocated .`
 
 in our example
 `ARC` automatically set the value of
 the tenant’s stored property on the apartment instance
 to `nil` :

 `class Apartment {`
 
    `weak var tenant: Person?`
 
    `...`
 `}`
 

 `apartment?.tenant` returns `nil`
 
 `NOTE` OLIVIER : This is not the case when you omit the `weak` keyword .
 
 This means
 that all properties with `weak` references
 (`1`) must be `optional types`
 and by definition (`2`) must be a `variable`
 so that they can be set to `nil` .
 Because a `weak` reference doesn't keep a strong hold to an instance ,
 it can get deallocated at any point .
 The use of an `optional` means
 we have to perform the same `nil` checks we usually do
 in order to get the same degree of safety .
 */
/**
 👉 Continue in PART 2
 */
