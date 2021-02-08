import Foundation


/**
 I am going to undo all the changes here .
 And go back up where we were :
 */

protocol AnimalFood {}


protocol Animal {
    
    associatedtype Food
    func eat(_ food: Food)
}


struct Kibble: AnimalFood {}
struct DogFood: AnimalFood {}


class Cat: Animal {
    
    func eat(_ food: Kibble) {}
}


class Dog: Animal {
    
    func eat(_ food: DogFood) {}
}


class Wolf<FoodType>: Animal {
    
    func eat(_ food: FoodType) {}
}

/**
 On the other hand , when we use the `associatedtype` ,
 this meant that when we declared the class ,
 we needed to specify as an argument [ OLIVIER : to the eat( ) method ],
 a class or a struct that conformed to `AnimalFood` :
 
 `struct Kibble: AnimalFood {}`
 
 
 `class Cat: Animal {`
 
    `func eat(_ food: Kibble) {}`
 `}`
 
 But whatever we specified ,
 that concrete type was then the only type that would be expected .
 So , using the `associatedtype` ,
 we are still guaranteeing that the `Cat` eats food that conforms to `AnimalFood` ,
 but it is only the type that we say is acceptable for cats to eat .
 We get more control in how we restrict our types ,
 but at the same time ,
 allowing different types to implement the same method differently .
 `NOTE` :This works the same way if `AnimalFood` were a base class rather than a protocol .
 `NOTE` : It is important to note
 that the constraints you can add to associated types
 — as we have done here —
 
 `protocol Animal {`
 
    `associatedtype Food`
    `func eat(_ food: Food)`
 `}`
 
 are not as flexible as with the constraints we can add to generics .
 But that is only a problem for right now . Right now , I am using Swift 3 .
 Expected for the implementation in Swift 4
 is the ability to add a `where` clause to an `associatedtype` .
 This introduces far more power and capability ,
 but we'll tackle that probably as an additional video
 once that feature is out in Swift 4 — which is probably late 2017 .
 
 
 Okay , let's take another break .
 We still have some more digging to do regarding associated types ,
 and we'll do that in the next video .
 */
