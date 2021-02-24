import Foundation


/**
 `3 Memory Leaks`
 INTRO — Just because `ARC` has saved the iOS
 from a host of memory related problems ,
 doesn't mean our memory is guaranteed to be free of issues .
 Memory leaks can still bring your app to a grinding halt .
 Let's find out what memory leaks are
 and how we can identify one of the most common types
 — `retain cycles` .
 */
/**
 In the previous example ,
 we wrote code where `ARC` was easily able to track
 the number of references to an object
 and thereby keep it in memory
 as long as it needed to be . However ,
 it is quite easy to write code
 where the number of references to an instance never gets to 0
 and `ARC` never deallocates the object .
 Let's look at another example .
 Here we have two classes , `Person` and `Apartment` .
 A person can live in an apartment ,
 so the `Person` class contains
 a stored property of type `optional Apartment` :
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

/**
 Similarly , an apartment can also contain a person ,
 so it has a stored property — `tenant` — of type `optional Person` :
 */

class Apartment {
    
    let unit: String
    var tenant: Person?
    
    
    init(unit: String) {
        
        self.unit = unit
        
        print("Apartment \(unit) is being initialised . Memory allocated .")
    }
    
    
    deinit {
        print("Apartment \(unit) is being deinitialised . Memory deallocated .")
    }
}

/**
 We have also included the `deinit()` method for both classes
 to indicate
 when the objects are deinitialised and memory deallocated .
 Now like before , let's create our instances :
 */

var person: Person? = Person(name : "Dorothy")
var apartment: Apartment? = Apartment(unit: "D2A")

/**
 `NOTE` :  The variable types are optional types of the respective classes
 because , again ,
 we want to set it to `nil`
 to zero out the references .
 
 Let's take a look at our object ownership graph .
 Here is what it currently looks like :
 
 `var person    —————> Person`
 `var apartment —————> Apartment`
 `Person               Apartment`
 `Apartment            Person`
 
 Each variable has a `strong reference` to the instance we assign to it .
 So far , so good , no issues .
 Well now ,
 let's say we want to move our dear friend , _Dorothy_ ,
 into apartment _D2A_
 I'll assign the `apartment` instance
 to the person's stored property ,
 */

person?.apartment = apartment

/**
 And now similarly ,
 a `person` occupies the `apartment` ,
 so we need to assign the instance to its tenant property :
 */

apartment?.tenant = person

/**
 This seems like something logical we would do , _right_ ?
 Well , let's take a look at the object ownership graph again :
 
 `var person    —————> Person`
 `var apartment —————> Apartment`
 `Person        —————> Apartment`
 `Apartment     —————> Person`
 
 In addition to the variables holding strong references to each instance ,
 
 `var person    —————> Person`
 `var apartment —————> Apartment`
 
 both instances hold a strong reference to each other .
 
 `Person        —————> Apartment`
 `Apartment     —————> Person`
 
 Because we have assigned them to stored properties .
 
 `var person: Person? = Person(name : "Dorothy")`
 `var apartment: Apartment? = Apartment(unit: "D2A")`
 
 This creates a `strong reference cycle` between them ,
 
 `Person        —————> Apartment`
 `Apartment     —————> Person`
 
 which is a bad thing .
 Earlier
 by sending both variables we created to `nil` ,
 we indicated to the compiler
 that we were done using the instances ,
 and `ARC` could safely deallocate the memory .
 Let's try that here :
 */

person = nil
apartment = nil

/**
 Now
 despite doing this ,
 if you look at the console ,
 we still don't get
 the log statement from the `deinit()` method
 of either class .
 This is
 because we have gotten rid of the reference
 from the variable to the instance
 for both the `person` and the `apartment` :
 
 `person = nil`
 `apartment = nil`
 
 `var person           Person`
 `var apartment        Apartment`
 `Person        —————> Apartment`
 `Apartment     —————> Person`
 
 But both of those instances now hold a reference to each other :
 
 `person?.apartment = apartment`
 `apartment?.tenant = person`
 
 Therefore ,
 the `reference count` can never go below `0` .
 These objects will never get deallocated by `ARC` ,
 and because we don't have any reference to them
 to delete them in any way ,
 they are just going to exist in memory .
 

 
 In the next video ,
 let's take a look at
 how we can solve this problem
 so we are not causing memory leaks .
 */

 
