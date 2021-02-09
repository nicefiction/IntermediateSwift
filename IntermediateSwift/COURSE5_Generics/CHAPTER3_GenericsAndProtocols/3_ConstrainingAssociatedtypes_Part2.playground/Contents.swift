import Foundation


/**
 `3 Constraining Associated Types` PART 2 of 4
 */
/**
 One way we can go about this , is ,
 to maybe create a base class for `Food` , or another protocol .
 Let's go the protocol route .
 So up at the top — above the `Animal` protocol —
 let's create a new protocol , `AnimalFood` :
 */

protocol AnimalFood {}

/**
 And for the sake of this example ,
 we'll just assume that the protocol encode some information ,
 and we'll keep it empty .
 Just like we can add type constraints to a type parameter ,
 we can add constraints to an associated type as well :
 */

protocol Animal {
    
    associatedtype Food: AnimalFood
    func eat(_ food: Food)
}

/**
 Inside the `Animal` protocol , we constrain the `associatedtype Food`
 to say that whatever we substitute
 must conform to `AnimalFood` .
 When we do that , we are going to get a bunch of errors :
 */

/*
 struct Kibble {}
 struct DogFood {}
 
 
 class Cat: Animal { // ERROR : Type 'Cat' does not conform to protocol 'Animal' .
 
 typealias Food = Kibble
 
 func eat(_ food: Kibble) {}
 }
 
 
 class Dog: Animal { // ERROR : Type 'Dog' does not conform to protocol 'Animal' .
 
 typealias Food = DogFood
 
 func eat(_ food: DogFood) {}
 }
 
 
 class Wolf<FoodType>: Animal { // ERROR : Type 'Wolf<FoodType>' does not conform to protocol 'Animal' .
 
 func eat(_ food: FoodType) {}
 }
 */

/**
 And to satisfy this , first ,
 we need to make sure that each of our foods conform to `AnimalFood` :
 */

struct Kibble: AnimalFood {}
struct DogFood: AnimalFood {}


class Cat: Animal {
    
    typealias Food = Kibble
    
    func eat(_ food: Kibble) {}
}


class Dog: Animal {
    
    typealias Food = DogFood
    
    func eat(_ food: DogFood) {}
}

/*
 class Wolf<FoodType>: Animal { // ERROR : Type 'Wolf<FoodType>' does not conform to protocol 'Animal' .
 
    func eat(_ food: FoodType) {}
 }
 */

/**
 This way , it ensures that we only pass in foods .
 So now , all this code should be resolved ,
 because `Kibble` ,
 
 `struct Kibble: AnimalFood {}`
 
 in fact , is a type
 that we are substituting for `Food`
 
 `class Cat: Animal {`
     
     `typealias Food = Kibble`
     
     `func eat(_ food: Kibble) {}`
 `}`
 
 that conforms to `AnimalFood` ,
 
 `protocol Animal {`
 
    `associatedtype Food: AnimalFood`
    `func eat(_ food: Food)`
 `}`
 
 and the same goes for DogFood .
 Now , this cleared up some errors , but not all .
 Our generic type , `Wolf` , still has an error .
 And that is because our generic type parameter
 that we have defined here
 
 `class Wolf<FoodType>: Animal { // ERROR : Type 'Wolf<FoodType>' does not conform to protocol 'Animal' . `
 
    `func eat(_ food: FoodType) {}`
 `}`
 
 that eventually will be substituted for `Food`
 violates the contract imposed by the `Animal` protocol .
 `FoodType` — the generic type parameter — has no constraints .
 And we are not ensuring that the argument to `eat()` — here , `Foodtype` — ...
 
 `func eat(_ food: Foodtype) {}`
 
 ... will conform to `AnimalFood` .
 
 `protocol AnimalFood {}`
 
 So — of course — over here ,
 we need to introduce a type constraint as well :
 */

class Wolf<FoodType: AnimalFood>: Animal {
    
    func eat(_ food: FoodType) {}
}

/**
 We say that `FoodType` needs to conform to `AnimalFood` .
 Doing this ,
 raises an error in the line of code
 where we try to specify an Integer as a FoodType
 — which is exactly what we want ,
 */

// let thirdWolf = Wolf<Int>() // ERROR : Type 'Int' does not conform to protocol 'AnimalFood' .

/**
 👉 Continue in PART 3
 */
