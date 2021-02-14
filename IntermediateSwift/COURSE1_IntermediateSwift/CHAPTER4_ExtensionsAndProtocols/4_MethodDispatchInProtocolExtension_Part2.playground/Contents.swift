import Foundation


/**
 `4 Method Dispatch in a Protocol Extension` PART 2 of 2
 */
/**
 (`2`) The second rule is ,
 if the inferred type is a protocol — which down here , in `people`
 
 `let people = [`
    `dorothy , glinda , ozma , jack`
 `]`
 
 every instance is now inferred as a protocol type — `Person` —
 but the method is not defined in the original protocol
 and is defined in a protocol `extension` :
 
 `protocol Person {`
 
    `var firstName: String { get }`
    `var lastName: String { get }`
    `var fullName: String { get }`
 `}`
 
 
 `extension Person {`
 
    `var fullName: String {`
 
        `return "\(firstName) \(lastName)"`
    `}`
 
 
    `func greeting()`
    `-> String {`
 
        `return "hello \(firstName)"`
    `}`
 `}`
 
 Then the default implementation
 provided in the `extension`
 is always called . So here ,
 
 `for person in people {`
 
    `print(person.greeting())`
 `}`
 
 `person` , again , is of type `Person`, right ?
 So this — `people` — is an array of type `Person` :
 
 `let people = [`
    `dorothy , glinda , ozma , jack`
 `]`
 
 So each instance here
 is of the `Person` protocol type .
 When we call `greeting()` ,
 because `greeting()` is defined only in the `extension`
 and not in the original `Person` protocol declaration .
 We are always going to get
 that default implementation
 provided by the protocol
 because these ...
 
 `for person in people {`
 
    `print(person.greeting())`
 `}`
 
 ... are protocol types .
 We can see this again
 with the iteration of our for loop , ...
 */

// CONSOLE :

/*
 hello Dorothy
 hello Glinda
 hello Ozma
 hello Jack
 */

/**
 ... since the type is inferred as the protocol .
 It doesn't matter that both types provide an implementation for `greeting()`
 it is going to use the default one .
 If however ,
 `greeting()` was defined in the original protocol ,
 that wouldn't be the case .
 So let's go back up to the `Person` protocol all the way up here .
 And in the original protocol, let's add that `greeting()` requirement :
 */

protocol Person {
    
    var firstName: String { get }
    var lastName: String { get }
    var fullName: String { get }
    
    func greeting() -> String
}



extension Person {
    
    var fullName: String {
        
        return "\(firstName) \(lastName)"
    }
    
    
    func greeting()
    -> String {
        
        return "hello \(firstName)"
    }
}



struct Human: Person {
    
    var firstName: String
    var lastName: String
    
    
    var fullName: String {
        
        return "\(firstName) 🌈 \(lastName)"
    }
    
    
    func greeting()
    -> String {
        
        return "Welcome home \(firstName) 🏵"
    }
}



struct Friend: Person {
    
    let firstName: String
    let middleName: String?
    let lastName: String
    
    
    var fullName: String {
        
        guard
            let _middleName = middleName
        else { return "\(firstName) \(lastName)" }
        
        return "\(firstName) \(_middleName) \(lastName)"
    }
    
    
    func greeting()
    -> String {
        
        return "Hola \(fullName) 🙌"
    }
}



let dorothy = Human(firstName : "Dorothy" ,
                    lastName : "Gale")

let glinda = Human(firstName : "Glinda" ,
                   lastName : "of Oz")

let ozma: Person = Human(firstName : "Ozma" ,
                         lastName : "of Oz")

let jack = Friend(firstName : "Jack" ,
                  middleName : "Pumpkinhead" ,
                  lastName : "of Oz")

let people = [
    dorothy , glinda , ozma , jack
]


for person in people {
    
    print(person.greeting())
}

/**
 When the playground executes ,
 you will now see that we get different implementations at the bottom for a for loop :
 */

// CONSOLE :

/*
 Welcome home Dorothy 🏵
 Welcome home Glinda 🏵
 Welcome home Ozma 🏵
 Hola Jack Pumpkinhead of Oz 🙌
 */

/**
 You have different versions printed out depending on the type .
 This matches up with our first case again ,
 where the implementation provided by the type
 is used
 even if the instance is a protocol type ,
 because the requirement is defined in the original protocol .
 So here the distinction is :
 ( 1 ) Is this a protocol type ? ,
 or ( 2 ) Is it a concrete type ?
 — like , is this instance represented as a more concrete type ,
 or is that the protocol ?
 ( 1 ) If it is a protocol ,
 then you need to worry about :
 Is that method defined in the original protocol
 or is it only in an extension ?
 That is where we start to differ .
 ( 2 ) And the last case , again , is ,
 if the inferred type is the type itself
 and not the protocol .
 In that case , the type’s implementation is always called .
 If you look at `dorothy` ,
 
 `let dorothy = Human(firstName : "Dorothy" ,`
                     `lastName : "Gale")`
 */

dorothy.fullName // returns "Dorothy 🌈 Gale"



/**
 where the inferred type is `Human` ,
 when we call `greeting()`
 
 dorothy.greeting() // "Welcome home Dorothy 🏵"
 
 we get the implementation provided by the type , and not the protocol .
 
 `struct Human: Person {`
 
    `var firstName: String`
    `var lastName: String`
 
 
    `var fullName: String {`
 
        `return "\(firstName) 🌈 \(lastName)"`
    `}`
 
 
    `func greeting()`
    `-> String {`
 
        `return "Welcome home \(firstName) 🏵"`
    `}`
 `}`
 
 So the case where you should worry about in all of this , is
 if your objects are considered protocol types or conforming types .
 If it is the latter — if it is a conforming or a concrete type —
 the type is actually `Human`
 — and not seen by the compiler as `Person` —
 then you can guarantee the implementation provided by `Human`
 will be called the one you intended default .
 Default implementation in an extension or not .
 */


 /**
 So I know this is a bit confusing ,
 and this is not stuff you need to internalise immediately ,
 but as we go on in the future ,
 you’ll see that there may be times when in our conforming types
 implementations stay the same .
 So we think , okay , it might be a good reason
 to move that up into an extension
 and provide a default that all types can use .
 The only thing we have to worry about that though , is ,
 depending on how the type is seen by the compiler
 — different versions of the method can be called .
  
 So remember these rules , play around with it , and get familiar with them .
 It certainly might help you avoid creating a tricky bug for yourself .
 */
