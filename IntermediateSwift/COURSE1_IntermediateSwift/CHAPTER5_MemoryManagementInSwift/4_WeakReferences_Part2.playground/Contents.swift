import Foundation


/**
 `4 Weak References` PART 2 OF 3
 */
/**
 Before we conclude our discussion on memory management ,
 let's dip our toes back into protocols .
 As we have just seen ,
 some properties need to be declared as `weak`
 to prevent reference cycles in our code .
 We also learned
 that we can use a protocol
 to _enforce design_ in our concrete types .
 _Now what if those two goals collide ?_
 */

protocol Residence {
    
    var tenant: Person? { get set }
    // weak var tenant: Person? { get set } // ERROR : 'weak' cannot be applied to a property declaration in a protocol .
}

/**
 And now ,
 the `Apartment` class needs to conform to the `Residence` protocol .
 If we add conformance now , ...
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



class Apartment: Residence {
    
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

/**
 ... you'll see that we don't have to make any changes , ....
 
 `protocol Residence {`
     
     var tenant: Person? { get set }
    `...`
 `}`
 
 
 
 `class Apartment: Residence {`
 
    `weak var tenant: Person?`
    `...`
 `}`

 ... because we already have a variable optional `person` property .
 But if I were to get rid of the `weak` keyword , ...
 
 `class Apartment: Residence {`
 
    `// weak var tenant: Person?`
    `weak var tenant: Person?`
    `...`
 `}`
 */

var person: Person? = Person(name : "Dorothy")
var apartment: Apartment? = Apartment(unit: "D2A")

person?.apartment = apartment
apartment?.tenant = person

person = nil
apartment = nil

/**
 ... we don't have any errors either ,
 and therein lies the problem .
 I want to be able to enforce that
 because when someone creates a new type
 that conforms to `Residence` ,
 the `tenant` property must be `weak` .
 `DEPRECATED` :
 Fortunately we can do that back in the `Residence` protocol .
 We can simply add the `weak` keyword in the property declaration :
 */

/* DEPRECATED CODE
 
 protocol Residence {
     
     weak var tenant: Person? { get set } // ERROR : 'weak' cannot be applied to a property declaration in a protocol .
 }
 */

/**
 Now this only works
 if the type of the property is a reference type .
 So here `Person` is a reference type :
 
 `class Person { ... }`
 
 This makes sense ,
 because you can only hold a weak reference to a reference type .
 */

