import Foundation


/**
 `4 Weak References` PART 3 OF 3
 `NOTE` OLIVIER : This part may be deprecated code . Instead , have a look at :
 👉 https://useyourloaf.com/blog/class-only-protocols-in-swift-4/
 */
/**
 Now , if I were to define a Struct ...
 */

struct Address {}

/**
 ... and modify `Residence` to define a `weak` property
 to reference an `Address` instance :
 */

protocol Residence {
    
    // weak var address: Address { get set } // DEPRECIATED , ERROR : 'weak' cannot be applied to a property declaration in a protocol
    var address: Address { get set }
}

/**
 Before we even get to the `Apartment` section ,
 let's remove its `Residence` conformance . . .
 */

//class Apartment: Residence {
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
 ... and go back to the protocol :
 
 `protocol Residence {`
 
 `DEPRECATED CODE !`
 `weak var address: Address { get set }`
 `// ERROR : 'weak' cannot be applied to a property declaration in a protocol`
 `}`
 
 You will see that this fails
 because we cannot hold a reference
 — as we are indicating with the `weak` keyword —
 to a value type , ...
 
 `struct Address {}`

 ... because it isn't memory managed .
    _But what about a protocol-based type ?_
 We know that since protocols are fully fledged types ,
 we can specify them as the type for a property requirement .
 So let me get rid of everything I just did ,
 I'll undo it , ...
 
 
 
 
 `protocol Residence {`
 
    `// weak var address: Address { get set }`
    `weak var address: Address { get set }`
 `}`
 
 
 
 `class Apartment: Residence {`
 `// class Apartment {`
 
    `let unit: String`
    `var tenant: Person?`
    `// weak var tenant: Person?`
 
 
    `init(unit: String) {`
 
        `self.unit = unit`
 
        `print("Apartment \(unit) is being initialised . Memory allocated .")`
    `}`
 
 
    `deinit {`
        `print("Apartment \(unit) is being deinitialised . Memory deallocated .")`
    `}`
 `}`
 
 ... and we will get rid of the struct :
 
 `// struct Address {}`
 */


/**
 We want to indicate that a protocol based type
 might need to be a `weak` property .
 So , let’s define a new set of protocols .
 We'll say we are a financial institution ,
 and we want to model our loans :
 */

// protocol Loan {}

/**
 Let's say that we also have a `Loan` object
 that models a `Customer` .
 — The details of these types don't matter ,
 the only thing we care about is
 that a bank customer may have a loan — :
 */

/*
class BankCustomer: Loan {
    
    weak var loan: Loan? // ERROR : 'weak' must not be applied to non-class-bound 'Loan'; consider adding a protocol conformance that has a class bound .
}
 */

/**
 This
 
 `weak var loan: Loan?`
 
 is an optional variable property
 where that type `Loan` is a protocol type .
 In our `Loan` protocol ,
 we are also going to encapsulate some information .
 We'll say that any object that wants to be a `Loan`
 — wants to model `Loan` and conform to this protocol —
 has to have a `Customer` associated with it :
 */

/*
 protocol Loan {
 
    var payee: BankCustomer { get set }
 }
 */

/**
 You'll see here that this isn't an optional property .
 We have a problem now
 because we have a potential reference cycle .
 We need to indicate
 that the customer's reference to this `Loan` is `weak`
 because the `Loan` also contains a reference to a potential `BankCustomer` .
 And if we add the `weak` keyword here , ...
 
 `class BankCustomer: Loan {`
 
    `weak var loan: Loan? // ERROR : 'weak' must not be applied to non-class-bound 'Loan'; consider adding a protocol conformance that has a class bound .`
`}`
 
 ... you will see that you get an error . 
 This is because we have no way to guarantee at the moment
 that the instance assigned to this `loan` property will be a reference type .
 We could , for example ,
 declare a struct that conforms to `Loan`
 and assign it to this `loan` property .
 So , a `weak` relationship wouldn't work there ,
 because it is a value type .
 What we need , is ,
 a way to indicate
 that the instances we assign to this stored property

 `var loan: Loan?`
 
 . . . are always going to be types that conform to the `Loan` ,
 but are only reference types .
 So they both need to ( 1 ) conform to the `Loan` protocol
 and ( 2 ) they need to be a `class` .
 Essentially ,
 we should still be able to create various types
 that represent a `Loan` through `protocol conformance` ,
 but these types all need to be classes ,
 we don't want them to be structs .
 To do this ,
 we can restrict our protocol in such a way
 that only classes can conform to them .
 These are called `class bound protocols` .
 We do this
 by adding the `class` keyword after the protocol name ,
 */

protocol Loan: class {
    
    var payee: BankCustomer { get set }
}

/**
 and now , ...
 */

class BankCustomer: Loan {
    
    var payee: BankCustomer // Added by Olivier .
    weak var loan: Loan? // ERROR : 'weak' must not be applied to non-class-bound 'Loan'; consider adding a protocol conformance that has a class bound .`
    
    
    init(payee: BankCustomer) {
        
        self.payee = payee
    } // Added by Olivier .
}

/**
 ... our errors go away .
 Because the compiler can guarantee ,
 because we are binding this protocol
 
 `protocol Loan: class { ... }`
 
 and saying that only classes can conform to it ,
 we can guarantee
 that anything assigned to this stored property
 will be a reference type .
 Therefore , it can be a `weak` relationship :
 
 
 Keep this in mind ,
 you don't have to understand it completely just yet .
 But as we learn more about patterns in Swift
 — particularly `delegate pattern` —
 this will be crucial to understanding how it works .
 We have spent quite a bit of time on memory management .
 Let's cover one last topic , and wrap it up .
 On to the next video .
 */
