import Foundation


/**
 `CHAPTER 2`
 `Generic Types`
 In addition to generic functions ,
 we can also define generic types in Swift .
 Generic types provide the backbone
 on which many of Swift's foundational types are built .
 Over the next few videos
 we are going to
 look at
 how the Standard Library
 uses
 generic types
 to create data structures
 and attempt to build one ourselves as well .
 */



/**
 `1 Generic Types in the Standard Library`
 INTRO — Before we define our own generic types ,
 let's take a look at what the Standard Library has to offer .
 */
/**
 In addition to creating functions with generic parameters and generic return types ,
 we can also create — what are known as — Generic Types .
 You have already encountered Generic Types in your usage of Swift
 with the Standard Library .
 But you just didn't know it .
 It is worth taking a second to look deeper into those types
 because — hopefully — in doing so
 you'll understand better the power that this feature offers .
 As a side note ,
 if you came to Treehouse to learn how to code and you are still here with me ,
 you should be proud of yourself .
 We are going to look at a feature that we touched upon in one of our first courses
 and here you are about to learn the magic under the hood . Okay ,
 so the first type we will look at is Array .
 Let's create an array of integers .
 We have done this many times :
 */
var numbers: [Int] = []
/**
 We start out with an empty Array .
 This is code we have written plenty of times
 but this is just one way of creating an array of integers .
 Another way that helps highlight the underlying type structure , is , like this :
 */
var numbers2 = Array<Int>()
/**
 So , I create an instance .
 This code does the exact same thing
 but we have got a bit of that angle bracket goodness in here .
 An Array is a generic type ,
 it is a data structure that can hold an ordered list of values
 whose type isn't determined until we create the Array .
 If you COMMAND click on Array
 to go to the header file and inspect the interface ,
 `@frozen public struct Array<Element> { ... }`
 You see that Array is defined with a type parameter
 that again doesn't say what type it is ,
 but allow us to define it when we create an instance .
 `NOTE` : Unlike the functions we defined earlier ,
 here we can establish a meaningful name for the type parameter
 and for `Array` , the type parameter is named `Element` .
 We won't really get into how an Array works as a type .
 It is decently complicated and brings together a lot of different protocols . Instead ,
 let's jump into another type . Let's create a few variables
 to store bits of information about a person's address :
 */
let city = "Oz"
let streetName = Optional.some("123 SomeStreet")
/**
 At minimum , we want to know the city a person lives in ,
 so for that we want a non optional String . Beyond that though ,
 let's assume the people may not want to give us more information . So ,
 we define the street name as an optional String .
 In the past when we have defined optional values ,
 we annotated the variable with the type ,
 and then added a question mark to denote that it was optional .
 As I have mentioned before
 the question mark that we use to mark something is an optional , is , syntactic sugar .
 What this does under the hood , is ,
 create an instance of the optional type :
 `let streetName = Optional.some("123 SomeStreet")`
 `streetName` is an Optional of type `some`
 — or with a `some` value — and our `streetName` is `123 SomeStreet`  .
 Here , we have declared an optional String rather than going the syntactic sugar route ,
 we are using the underlying type — `Optional` — which happens to be an enum .
 If you COMMAND click on Optional , ...
 `@frozen public enum Optional<Wrapped> : ExpressibleByNilLiteral { ... }`
 ... you see that it is a generic enum with a single type parameter . Again ,
 with a more meaningful name than T , `Wrapped` in this case . 
 The Optional enum has two cases , `none` and `some` .
 `case some(Wrapped)`
 `some` has an associated value of the generic type ,
 which means that whenever we use an optional ,
 whatever type we denote as optional ,
 is substituted in for `Wrapped` .
 In the case of the `streetName` we just defined ,
 `let streetName = Optional.some("123 SomeStreet")`
 the `some` case has an associated value of type String .
 
 Many of the fundamental Swift types we use all the time
 are generic types
 created with tremendous flexibility in mind .
 
 Let's look at one more example ,
 say we had a Dictionary of error codes
 where an integer value could be used as a key
 to look up a description of the error .
 Typically , we declare a variable ,
 give it an explicit type of Int to String
 to indicate what Dictionary we are creating .
 A Dictionary is also a generic type ,
 and rather than using type annotation
 to help the compiler understand what kind of Dictionary we want to create .
 We can instantiate it as a generic type . So we can say
 */
var errorCodes = Dictionary<Int , String>()
/**
 var `errorCodes` is a `Dictionary` that has keys of type `Int` and values of type `String` .
 And then , creates an instance .
 So , the first type parameter here represents a key and the second one , a value .
 And you can confirm this — and see what those type parameters are named — by COMMAND clicking on Dictionary ,
 `@frozen public struct Dictionary<Key, Value> where Key : Hashable { ... }`
 So here , we have `Key` and `Value` .
 
 
 
 While this quick look shows you how the Standard Library uses generics ,
 it doesn't really help you understand how to make your own .
 So let's go ahead and do just that .
 
 Generic types are used all the time ,
 and are typically used
 to create custom data structures for a wide variety of purposes .
 Let's take a quick break here . And in the next video ,
 let's define a simple data structure , a linked list .
 */
