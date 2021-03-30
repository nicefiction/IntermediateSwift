import Foundation


/**
 `4 Method Dispatch in a Protocol Extension` PART 1 of 2
 INTRO — While a protocol extension allows us
 to provide default implementations ,
 things can get tricky .
 In this video
 we look at
 how methods are dispatched
 when a default is provided in a protocol extension .
 */
/**
 In the previous video
 we have seen
 how we can provide a default implementation
 to a requirement
 specified in a protocol
 via an `extension` .
 In addition to providing default implementations
 we can also add
 entirely new methods
 to the protocol
 in an `extension` .
 Let's continue working with the `Person` protocol that we defined up here :
 */

protocol Person {
    
    var firstName: String { get }
    var lastName: String { get }
    var fullName: String { get }
}

/*
extension Person {
    
    var fullName: String {
        
        return "\(firstName) \(lastName)"
    }
}
*/

struct Human: Person {
    
    var firstName: String
    var lastName: String
}

/**
 In the previous video ,
 we have seen
 how we could provide
 a default implementation
 for a requirement defined in the protocol — `fullName` — through an `extension` .
 There is another interesting aspect to this however .
 In a protocol `extension`
 we can also add requirements
 that are not specified in the original protocol
 and provide a default implementation as well .
 So for example ,
 let’s say we wanted the `Person` protocol
 or anything that conforms to `Person`
 to implement a function that returned a greeting ,
 and we assume this is going to be the same for everyone ,
 so we'll do it in the protocol extension :
 */

extension Person {
    
    var fullName: String {
        
        return "\(firstName) \(lastName)"
    }
    
    
    func greeting()
    -> String {
        
        return "hello \(firstName)"
    }
}

/**
 In the extension
 I have added a method requirement named `greeting()`
 that returns an interpolated `String` where `fullName` here is
 again relying on the default provided by the extension .
 So here we have a method — `greeting()` —
 that is not defined in the original `Person` protocol
 but I added it in the `extension` .
 Now in the `Human` type , where `Human` conforms to `Person` ,

 `struct Human: Person {`
 
    `var firstName: String`
    `var lastName: String`
 `}`
 
 I should easily be able to provide a greeting by using the default :
 */

let dorothy = Human(firstName : "Dorothy" ,
                    lastName : "Gale")

dorothy.greeting()

/**
 There we go .
 Okay , so hopefully you have wrapped your head around what I just did .
 I have added a method
 along with an implementation
 to an `extension` of a protocol :
 
 `func greeting()`
 `-> String {`
     
     return "hello \(firstName)"
 `}`
 
 Let's say we wanted the `Human` type
 to provide a different implementation for a `greeting()` :
 */

struct Human2: Person {
    
    var firstName: String
    var lastName: String
    
    func greeting()
    -> String {
        
        return "hello again , \(firstName)"
    }
}

/**
 `NOTE` that I can provide the `greeting()` method implementation in `Human` ,
 or even an extension of `Human` .
 We will do the implementation inside the main declaration — struct `Human` .
 When I do that ...
 */

let glinda = Human2(firstName : "Glinda" ,
                    lastName : "of Oz")

glinda.greeting()

/**
 ... you see in the results area
 that my `greeting()` method
 now changes to the one implemented in `Human` , which makes sense
 because we said we didn't want to use the default .
 Let's go ahead and create another instance of `Human` ,
 but this time , I am going to do something a little bit different .
 I am going to explicitly annotate the type and instead of setting it to `Human`
 — which you'll see here ( when I OPTION click on `glinda` ) is what is automatically inferred —
 I am going to set it to the protocol type , `Person` :
 */

let ozma: Person = Human2(firstName : "Ozma" ,
                          lastName : "of Oz")

/**
 This works because `Human` conforms to `Person` ,
 so it can be represented by the `Person` protocol . Okay ,
 if we call `greeting()` on `ozma` ,
 */

ozma.greeting()

/**
 Surprise , surprise ,
 it is the implementation provided in the `Person` protocol `extension` .
 _What is going on ?_
 I thought we have overridden the method in `Human` ?
 And as seen here ,
 
 `let ozma: Person = Human2(firstName : "Ozma" ,`
                           `lastName : "of Oz")`
 
 this is an instance of `Human2` .
 Even though this is an instance of `Human2` ,
 because the type is specified as the protocol type — `Person` ,
 it defaults to the implementation provided in the extension ...

 `extension Person {`
 
    `var fullName: String {`
 
        `return "\(firstName) \(lastName)"`
    `}`
 
 
    `func greeting()`
    `-> String {`
 
        `return "hello \(firstName)"`
    `}`
 `}`
 
 ... and ignores the one in the `Human2` type :
 
 `struct Human2: Person {`
 
    `var firstName: String`
    `var lastName: String`
 
    `func greeting()`
    `-> String {`
 
        `return "hello again , \(firstName)"`
    `}`
 `}`
 
 _Why does this matter ?_
 When you learned about `typecasting`
 we looked at an example
 where in preserving the arrays homogeneity rule ,
 Swift casts different sub classes to the base class .
 Remember , if you had a base class `Employee`
 and then sub classes `HourlyEmployee` and `SalariedEmployee` .
 And if you put those two together in an `Array`
 because of Swift’s rule where an `Array` can only contain one type .
 Those are cast up to the base class
 so that they are all `Employee` types inside the `Array` .
 Well , the same thing happens with mixed types that have a common protocol .
 I am going to copy paste some code in :
 */

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


let jack = Friend(firstName : "Jack" ,
                  middleName : "Pumpkinhead" ,
                  lastName : "of Oz")

/**
 So in here
 I have created another struct , `Friend`
 that also conforms to `Person`
 and provides its own implementation for `fullName` and `greeting()` .
 We have then created an instance of `Friend` — `someFriend` —
 and then , using all the three instances that we have created ,
 
 `let dorothy = Human(firstName : "Dorothy" ,`
                     `lastName : "Gale")`
 
 `let glinda = Human2(firstName : "Glinda" ,`
                     `lastName : "of Oz")`
 
 `let ozma: Person = Human2(firstName : "Ozma" ,`
                           `lastName : "of Oz")`
 
 `let jack = Friend(firstName : "Jack" ,`
                   `middleName : "Pumpkinhead" ,`
                   `lastName : "of Oz")`
 
 We put these instances into an `Array` ,
 and assign it to a constant named `people` :
 */

let people = [
    dorothy , glinda , ozma , jack
]

/**
 Because these are three different types
 — `Human` , `Human2` ,  and `Friend` —
 Swift infers them as the common higher type which is the protocol `Person` . So ,
 this is an Array of Person types .
 Now if I wanted to do something like iterate for a `person` in `people` :
 */

for person in people {
    
    print(person.greeting())
}

/**
 You'll see in the console
 that it now uses the default implementation provided in the protocol extension
 rather than the one in the type itself .
 So even though `Human` , `Human2` , and `Friend`
 have their own implementation of `greeting()`
 we don't get that , right ?
 We get the default provided in the `extension` of the `Person` protocol :
 
 `extension Person {`
 
    `var fullName: String {`
 
        `return "\(firstName) \(lastName)"`
    `}`
 
 
    `func greeting()`
    `-> String {`
 
        `return "hello \(firstName)"`
    `}`
 `}`
 
 _So what is going on here ?_
 If the inferred type is a protocol
 and the method is defined in the original protocol
 then you will always use the implementation provided by the concrete type .

 Let me say that again .
 
 So here ,
 
 `for person in people {`
 
    `print(person.greeting())`
 `}`
 
 If you OPTION click on `person`
 `Person` is inferred as the protocol type .
 Now if the type is inferred as a protocol — as you have here —
 but the method is defined in the original protocol
 — and not just in an `extension` —
 then you will get the implementation provided by each concrete type .
 For example , if I go back to `dorothy` ,
 you'll see here that `dorothy` calls a `fullName` ,
 and you get a `fullName` value here :
 */

dorothy.fullName // returns "Dorothy Gale"

/**
 and that is
 because it is using the one in the default implementation , right ?
 
 `protocol Person {`
 
    `var firstName: String { get }`
    `var lastName: String { get }`
    `var fullName: String { get }`
 `}`
 
 So if we were to call ,
 */

glinda.fullName // returns "Glinda of Oz"

/**
 this gets the value returned by the implementation
 in the protocol extension , ...
 
 `extension Person {`
 
    `var fullName: String {`
 
        `return "\(firstName) \(lastName)"`
    `}`
 
 
    `func greeting()`
    `-> String {`
 
        `return "hello \(firstName)"`
    `}`
 `}`
 
 ... for both the `Human2` and the `Person` type .
 But now if I would override that in the `Human` struct ,
 and provide my own value for `fullName` ,
 */

struct Human3: Person {
    
    var firstName: String
    var lastName: String
    
    
    var fullName: String {
        
        return "\(lastName) ✋ \(firstName)"
    }
    
    
    func greeting()
    -> String {
        
        return "Hello \(fullName) 🖖"
    }
}


let dorothy3 = Human3(firstName : "Dorothy ⭐️" ,
                      lastName : "Gale")

let glinda3: Person = Human3(firstName : "Glinda ⭐️" ,
                             lastName : "of Oz")

/**
 And now , you will see here that both in `dorothy3` ,
 */

dorothy3.fullName // returns Gale ✋ Dorothy ⭐️

/**
 and `glinda3` — which is specified as a `Person` type —
 */

glinda3.fullName // returns of Oz ✋ Glinda ⭐️

/**
 you get the value — or the implementation — provided in the specific concrete type :
 
 `struct Human3: Person {`
     
     ...
     
     var fullName: String {
         
         return "\(lastName) ✋ \(firstName)"
     }
     
     ...
 `}`
 
 we have the `lastName` first , and then the `firstName` .
 This is
 because ,
 even if the inferred type is a protocol — `Person`
 — as is the case in `glinda3` —
 
 `let glinda3: Person = Human3(firstName : "Glinda ⭐️" ,`
                              `lastName : "of Oz")`
 
 and the method or property requirement is defined in the original protocol
 — which `fullName` is —
 
 `protocol Person {`
 
    `var firstName: String { get }`
    `var lastName: String { get }`
    `var fullName: String { get }`
 `}`
 
 then you always get the implementation provided by the underlying type ,
 so `Human3` :
 
 `struct Human3: Person {`
     
     ...
     
     var fullName: String {
         
         return "\(lastName) ✋ \(firstName)"
     }
     
     ...
 `}`
 */
/**
👉 Continues in PART 2
*/
