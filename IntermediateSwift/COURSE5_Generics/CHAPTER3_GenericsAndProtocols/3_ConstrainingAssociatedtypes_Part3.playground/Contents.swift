import Foundation


/**
 `3 Constraining Associated Types` PART 3 of 4
 */
/**
  You might be wondering why
  — if we introduced a protocol called AnimalFood —
  did we need to also have an associated type ? :
  
  `protocol AnimalFood {}`
  
  
  `protocol Animal {`
  
     `associatedtype Food: AnimalFood`
     `func eat(_ food: Food)`
  `}`
  
  For example ,
  if we comment this line of code out . And instead ,
  change the argument type of the `eat( )` method to be `AnimalFood` ,
  doesn't this solve our problem ? Well ,
 */

protocol AnimalFood {}

protocol Animal {
    
    // associatedtype Food: AnimalFood
    func eat(_ food: AnimalFood)
}
    

struct Kibble: AnimalFood {}
struct DogFood: AnimalFood {}


/*
 class Cat: Animal { // ERROR : Type 'Cat' does not conform to protocol 'Animal' .
 
    typealias Food = Kibble
 
    func eat(_ food: Kibble) {}
 }
 
 
 class Dog: Animal { // ERROR : Type 'Dog' does not conform to protocol 'Animal' .
 
    typealias Food = DogFood
 
    func eat(_ food: DogFood) {}
 }
*/

class Wolf<FoodType: AnimalFood>: Animal {
    
    func eat(_ food: AnimalFood) {}
}

/**
 when we do that, again , we are going to have a bunch of errors ,
 and that is because now
 we have these concrete types
 specified as the arguments to the `eat( )` method
 where the compiler is expecting a protocol type .
 If we go ahead and change those ,
 so I'll say ,
 */

class Cat: Animal {
    
    func eat(_ food: AnimalFood) {}
}


class Dog: Animal {
    
    func eat(_ food: AnimalFood) {}
}

/**
 Our code compiles , and you can see here , that I can say
 */

let cat = Cat()
let dog = Dog()

cat.eat(Kibble())
dog.eat(DogFood())

/**
 I can pass in an instance of `Kibble` ,
 and it works , which is the original goal , right ?
 So , what is the problem here ?
 The problem is actually quite subtle .
 The problem is that
 because the argument type now is the higher protocol type `AnimalFood` ,
 
 `class Cat: Animal {`
 
    `func eat(_ food: AnimalFood) {}`
`}`
 
 we can also feed our cat
 anything that conforms to `AnimalFood` , including `DogFood` :
 */

cat.eat(DogFood())

/**
 My cat actually eats dog food , so this wouldn't be an issue .
 But you can see that we have lost some specificity here .
 I could feed my cat , BirdFood , for example ,
 and the compiler wouldn't complain .
 So again , here , by specifying the protocol as the argument type ,
 we have restricted arguments to be instances conforming to `AnimalFood` ,
 but that is not specific enough .
 */
/**
 👉 Continue in PART 4
 */
