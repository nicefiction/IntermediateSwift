import Foundation



/**
 `3 Protocol Extensions`
 INTRO — If you haven't been amazed by extensions yet , you definitely will be .
 In this video ,
 we look at
 how we can extend protocols themselves
 to provide default implementations .
 */
/**
 We just learned
 how to extend any type to conform to a Protocol .
 Just like we can extend a Class , Struct , or a number .
 But things get a little interesting when you do that .
 Unlike other types where — when we extend it — we can add functionality .
 When you extend a Protocol ,
 you can provide implementations to
 any method or property requirements
 that you have defined .
 Wait , what ?
  
 When we learned about protocols
 we said that the purpose of a protocol is
 to just define requirements
 and not worry about the implementation , right ?
 That was the job of the conforming type .
 And that still holds true .
 However
 there are certain cases
 where regardless of the conforming type ,
 the implementation remains the same .
 Let's look at this simple example first .
 Now in the past we have defined a protocol
 called `RandomNumberGenerator` .
 The only requirement was
 that conforming types
 needed to provide a function
 that returned a random number .
 So we'll add that in here :
 */

protocol RandomNumberGenerator {
    
    func random() -> Int
}

/**
 Now let's assume that
 for every type that conforms to this protocol ,
 the implementation will always be the same.
 We are going to use the `arc4random()` function to generate a random number .
 In such cases ,
 where we will have a common implementation and an occasional variation .
 We can provide that common implementation as part of the protocol itself
 via an extension .
 Let's create an `extension` to the protocol itself
 and inside this extension
 we are going to provide
 an implementation of this function
 that we have defined as a requirement in the original protocol :
 */

extension RandomNumberGenerator {
    
    func random()
    -> Int {
        
        return Int(arc4random())
    }
}

/**
 So , we say `func random( )` ,
 and we are providing an implementation ,
 which means just writing out a normal function .
 If I were to declare a new type ,
 let’s say a class called `Generator`
 and then conform to the `RandomNumberGenerator `protocol :
 */

class Generator: RandomNumberGenerator {}

/**
 You'll see that I can add conformance to this type
 without actually doing anything .
 The class `Generator` now conforms to `RandomNumberGenerator` ,
 but I don't have to provide a `random()` function .
 This is because a default implementation has been provided in the Protocol ,
 and the conforming type — `Generator` — can use that . For instance , if I say
 */

let generator = Generator()

/**
 I can call `random( )` on `generator` , and it should work .
 */

generator.random()

/**
 So , here
 the `Generator` type is relying on that default implementation
 provided by the protocol itself . Again ,
 which we can do through an extension of the protocol . If , however ,
 we decide that we don't want this default implementation that the protocol provides
 and we want the type to provide its own specific implementation . Well ,
 that looks just like before — like we have been conforming to a protocol —
 we can provide our own implementation :
 */

class Generator1: RandomNumberGenerator {
    
    func random() -> Int {
        
        let randomNumber = Int(arc4random())
        print(randomNumber)
        
        return randomNumber * 2
    }
}

let generator1 = Generator1()
generator1.random()

/**
 Interesting , right ? Okay , well ,
 let's look at another example .
 This one requires a bit of a deeper understanding of protocols .
 Let's define a new protocol , `Person` :
 */

protocol Person {
    
    var firstName: String { get }
    var lastName: String { get }
    var fullName: String { get }
}

/**
 The requirements here are pretty simple .
 Conforming types need to provide a first , last and a full name
 but we know that a full name is always going to be the first name and the last name .
 So let's provide a default implementation for that property :
 */

extension Person {
    
    var fullName: String {
        
        return "\(firstName) \(lastName)"
    }
}

/**
 Wait , what do we do here ?
 We can't anticipate everyone's full name , so what kind of `String` do we return ?
 Can we anticipate all the possible names ? Well , we don't need to .
 Since we are in an `extension` of the `Person` type ,
 we know all the information that is available to the `Person` type .
 Which means we know about the `firstName` and the `lastName` stored properties .
 What do I mean by _know_ about it ?
 The `Person` protocol has requirements
 stating that conforming types must provide a value for `firstName` and `lastName` .
 The types for these properties are non optional Strings . Meaning , they cannot be `nil` .
 Therefore we can guarantee — or the compiler can — that conforming types
 will have values for the first- and lastName .
 And since the conforming types are the ones
 that are going to be calling this `fullName` property as well ,
 we can use the values encapsulated by these properties in the eventual conforming type .
 So right now , they don't have any values , but we can use them :
 
 `var fullName: String { return "\(firstName) \(lastName)" }`
 
 And this should work because , eventually ,
 when a conforming type conforms to the `Person` protocol
 they will provide values for `firstName` and `lastName` .
 Let's see if this works by defining a new type :
 */

struct Human: Person {
    
    var firstName: String
    var lastName: String
}

/**
 `NOTICE` that I am only providing the implementations
 in the form of stored properties for the `firstName` and `lastName` ,
 but we don't have any errors
 and that is because , again ,
 a default implementation for `fullName` has been provided .
 So if we were to create an instance of `Human` ,
 */

let dorothy = Human(firstName : "Dorothy" ,
                    lastName : "Gale")

/**
 I can now call `fullName` on `dorothy`
 */

dorothy.fullName

/**
 and the correct String is returned .
 Despite `Human` not having an implementation .
 When we call the method ,
 we use the implementation in the `protocol extension`
 where it relies on the values provided by `Human`
 for some of the other requirements specified in the protocol .
 There is a hidden aspect to this though .
 Let's take a break and talk about method dispatch in the next video .
 */


print("Debug")
