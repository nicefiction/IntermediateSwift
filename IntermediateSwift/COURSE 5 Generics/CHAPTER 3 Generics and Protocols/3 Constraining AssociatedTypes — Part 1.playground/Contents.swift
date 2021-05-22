import Foundation


/**
 `3 Constraining Associated Types` PART 1 of 4
 INTRO — In addition to constraining generic type parameters ,
 constraining associated types is a pretty common use case .
 In this video , let's figure out how we can do that .
 */
/**
 Before we start this topic ,
 I do want to stress
 that the next few videos
 are quite a bit more complicated conceptually
 than what we have learned so far .
 We are going to take a look at
 the intersection of generics and associated types
 and their respective characteristics — so fair warning .
 However , it is also important to know that
 you won't necessarily run into code like this anytime soon ,
 and certainly not in our lessons .
 But since we are learning about these concepts ,
 it only makes sense to cover our bases .
 Let's go back to associated types in protocols for just a second .
 
 Just like generic classes in structs
 are different from
 regular classes in structs
 in how they behave .
 A protocol with an associatedtype
 has different characteristics compared to a normal protocol .
 
 I am going to paste some code in here ,
 so I can quickly highlight this example :
 */
protocol Animal {

    associatedtype Food
    func eat(_ food: Food)
}


struct Kibble {}
struct DogFood {}


class Cat: Animal {
    
    typealias Food = Kibble
    func eat(_ food: Kibble) {}
}


class Dog: Animal {
    
    typealias Food = DogFood
    func eat(_ food: DogFood) {}
}


let cat = Cat()
let dog = Dog()
/**
 Here , we have a protocol , `Animal` — up at the top —
 that contains an `associatedtype Food`
 and a function `eat( )` that defines what an `Animal` eats .
 Since this is an `associatedtype` ,
 we defer the actual type that we accept in as an argument to `eat( )`
 to the point of conformance .
 Below this , we have defined two kinds of food :
 We have `Kibble` and `DogFood` ,
 `struct Kibble {}`
 `struct DogFood {}`
 And we have created two classes — `Cat` and `Dog` —
 that conform to `Animal`
 and substitute in the correct `Food` for the `eat( )` method .
 So Cats eat `Kibble` , Dogs eat `DogFood` , so far , so good .
 We have also created an instance of each class — down here at the bottom —
 and you'll see that all this code so far
 more or less works like any protocol code that we have written in the past .
 
 But we have talked before
 about how types
 that conform to a protocol
 can be represented to the compiler as the protocol type itself .
 For example ,
 we can say that this instance of `Cat` down here is actually of type `Animal` .
 But if we try and do that in this case , ...
 */

/*
 let cat: Animal = Cat() // ERROR : Protocol 'Animal' can only be used as a generic constraint because it has Self or associated type requirements .
 */

/**
 ... you see that we get an error .
 With protocols that have associated types ,
 we can't use them as variable types or as parameter types in functions .
 This means that if we wanted to group various objects together
 that have a common protocol . For example ,
 if we wanted to create an Array with this instance of `Cat` and `Dog` together .
 And set that array type as an Array of `Animal` , we won't be able to do that .
 */

// let animals = [ cat , dog ] // ERROR : heterogeneous collection literal could only be inferred to '[Any]'; add explicit type annotation if this is intentional .

/**
 The only way we could achieve this , is ,
 to cast each type to an Array of `Any` .
 */
let animals: Any = [ cat , dog ]
/**
 And in doing so ,
 we lose all information about each specific type .
 Even though we learned about generics and associated types in the same context ,
 there is actually a subtle difference in what they mean
 while both allow you to defer specifying a type .
 ( A ) A generic class , or struct , or enum
 defers that type specification
 to the point of instantiation :
 Until you actually create an instance of the class ,
 you don't have to specify the type .
 ( B ) On the other hand ,
 with protocols and associated types ,
 you defer it
 to the point of protocol conformance
 — which is when you define the body of the class .
 So here in the `Cat` class , ...
 
 `protocol Animal {`
 
    `associatedtype Food`
    `func eat(_ food: Food)`
 `}`
 
 
 `struct Kibble {}`
 
 
 `class Cat: Animal {`
 
    `typealias Food : Kibble`
    `func eat(_ food: Kibble) {}`
 `}`
 
 ... once `Cat` specifies that `Kibble` is the `Food` that it eats
 — and that this is the type we are substituting for the `Food associatedtype` .
 This is always going to be a fixed type for every `Cat` instance .
 You can’t change the `Food` that this `Cat` eats
 depending on the instance you create .
 When we try to annotate `cat` down here , to specify the type as `Animal` ,
 
 `let cat: Animal = Cat() // ERROR : Protocol 'Animal' can only be used as a generic constraint because it has Self or associated type requirements .`
 
 What does this error mean ? Well ,
 ( A ) with `generic types` , type parameters are part of the public interface .
 You specify them when you create an instance .
 ( B ) With `associated types` , this information is hidden in the class internals .
 And the reason you can't group them as a `protocol type` , is ,
 because different classes that conform to the protocol
 have different implementations .
 If we had an `Array` of `Cat` and `Dog` here ,
 
 `let animals: Any = [ cat , dog ]`
 
 we can't iterate through that Array and call the `eat( )` method ,
 because that function accepts a different argument depending on the instance ,
 and its implementation differs . So the main takeaway , is ,
 that if you start using protocols with associated types in your code ,
 you need to be aware of this .
 What if you did want to achieve something along these lines, however ? 
 Let's say we had a `feed( )` function , and as an argument ,
 we wanted to accept an instance of an `Animal` to `feed( )` them . Well ,
 we know now that we can't do this directly
 because we can't use a protocol that has an associated type as a variable or a parameter type ,
 */

/*
func feed(_ animal: Animal) {} // ERROR : Protocol 'Animal' can only be used as a generic constraint because it has Self or associated type requirements .
*/

/**
 I can’t specify the type as `Animal` . This is not going to work .
 What we can do , however , is ,
 combine our knowledge of generics along with associated types :
 */

// func feed<Animal>(_ animal: Animal) {}
func feed<T: Animal>(_ animal: T) {}

/**
 So here , I make the `feed( )` function a generic function ,
 by introducing a single type parameter that we call `T` .
 We say that `T` must conform to the `Animal` protocol .
 And now we can accept an instance of `T` rather than `Animal` .
 And what we are really doing , is ,
 accepting an instance of an object conforming to `Animal` ,
 as an argument for a function .
 This is the only way we can use a protocol with an associated type as an argument ,
 as a generic one . In fact ,
 we can use it this way in classes , or as structs too , or even enums .
 For example , with `Cat` and `Dog` ,
 we couldn't defer the choice of what they ate to when we created an instance .
 A `Cat` is always going to eat `Kibble` . A `Dog` is always going to eat `DogFood` ,
 but if we combine associated types of generics , we can do that
 — [ OLIVIER : deferring the choice of what they ate ] .
 
 Let's declare a new class ,
 */

class Wolf<Foodtype>: Animal {
    
    func eat(_ food: Foodtype) {}
}

/**
 We give the `Wolf` class a single type parameter — `FoodType` .
 `Wolf` is also going to conform to the `Animal` protocol .
 In the implementation of Animal’s requirements — which is the `eat( )` method .
 We can specify that the food that we accept is the generic type , `FoodType`. This way ,
 when we go ahead and create an instance of `Wolf` ,
 we can specify a type for the type parameter ,
 thereby varying the foods different instances of a wolf eats :
 */

let wolf = Wolf<Kibble>()
let anotherWolf = Wolf<DogFood>()

/**
 The first `wolf` can eat some `Kibble` ,
 and then `anotherWolf` can come along , and eat some `DogFood` .
 But if you have been following along carefully , you'll notice a problem here .
 If you haven’t ,
 let me create another instance of wolf — `thirdWolf` :
 */

let thirdWolf = Wolf<Int>()

/**
 And guess what ? We are going to feed this Wolf integers .
 How amazing , this `Wolf` can eat numbers !
 Obviously , the issue here , is ,
 that our generic parameter isn't constrained ,
 so we can pass anything in ,
 and this satisfies the requirements .
 */
/**
 👉 Continues in PART 2
 */
