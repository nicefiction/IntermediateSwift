import Foundation


/**
 `COURSE 1`
 `INTERMEDIATE SWIFT`
 INTRO — Now that we have a working knowledge of
 many parts of the Swift language , it is time
 to take a deeper dive and look under the hood .
 In this grab bag of a course ,
 we are going to look at many different topics
 including
 computed and stored properties ,
 designated and convenience initialisers ,
 extensions ,
 memory management ,
 and much more .
 By the time you are done with this course ,
 you will have a wider array of tools in your tool belt
 that will help you write more concise and flexible Swift .
 */
/**
 `PROPERTIES`
 INTRO CHAPTER 1 — We are familiar with
 stored properties in object instances from lessons past ,
 but it is time to take a look at some of the alternatives .
 In the next set of videos we look at
 typed properties ,
 computed properties ,
 lazy properties ,
 and more .
 */
/**
 `1 Type Properties`
 INTRO — Where instance properties are associated with an instance ,
 type properties are associated with a type itself . In this video ,
 let's take a look at how we can create and use type properties .
 */
/**
 When we learned about custom constructs
 — like structs and classes —
 we learned about storing values in properties .
 */
struct Account {
    
    let userName: String
    let password: String
}
/**
 Stored properties , as we learned , allowed us to store values as part of an instance .
 During initialisation , ...
 */
let someAccount = Account(userName : "dorothyGale" ,
                          password : "OZ123")
/**
 ... we assign different values to these stored properties ,
 or we can set them to nil if they are optional .
 Stored properties , by definition , are part of an instance ,
 and we access them using dot notation . So , to get to the username , we'd say :
 */
someAccount.userName
/**
 So far so good , right ?
 As it turns out ,
 stored properties
 aren't the only way to associate values with a Struct or a Class .
 We have quite a few options at our disposal that allow us to do different things .
 So let's start with type properties .
 In a recent course , you should have learned about type methods .
 Type methods , unlike instance methods , are associated with the type itself .
 Just like we can have type methods,
 we can also have type properties that are associated with the type itself .
 */
struct Point {
    
    let x: Int
    let y: Int
}
/**
 This is a simple Struct to represent a coordinate point in a two-dimensional space , like a map .
 Now to model this space , this map , let's define a Struct called Map :
 */
struct Map {
    
    static let origin: Point = Point(x : 0 ,
                                     y : 0)
}
/**
 Map will be used in different ways ,
 to keep track of players on it ,
 or to find the distance between players , things like that .
 But the Map's origin , at least in our case , is always the same . Zero , right ?
 It never changes based on the instance .
 So , let's associate this information with the type itself , because , again ,
 it is independent of the instance . To do that ,
 we can declare a type property using the `static` keyword .
 Just like we define a regular stored property ,
 the only difference this time is we start with the word `static` . And then , proceed as usual .
 So now we have a property that is associated with a type
 and does not need an instance to be accessed .
 So you can do something as easy as ...
 */
Map.origin
/**
 ... to get that value .
 
 The type property we just created is a constant ,
 `let origin`
 but if we created a variable property ,
 we can set it just like we set an instance property . 
 So , we'll change this to var , ...
 */
struct Map2 {
    
    static var origin: Point = Point(x : 0 ,
                                     y : 0)
}
/**
 ... except this time ,
 we set it on the type , rather than an instance ,
 and then we can set a new value :
 */
Map2.origin = Point(x : 1 ,
                    y : 1)
/**
 `NOTE` : Notice that we have not created an instance ( OLIVIER : of Map2 ) .
  
 Okay. Let's set it back to let ,
 */
// Map.origin = Point(x : 1 , y : 1)
/**
 and you'll see that it respects the same behaviours
 that we have come to expect
 from stored properties on an instance .
 All constructs
 — Classes , Structs , and Enumerations —
 can all contain type properties ,
 and they are all declared with the static keyword .
 
 What is the point of a type property , though ?
 Like type methods , the question to ask is :
 Does it make sense to associate this value with the type itself ?
 Does this property contain information that provides context ,
 without having to instantiate an instance ?
 This can be hard to determine ,
 but as we go through examples in future courses ,
 you'll get a better understanding of where type properties are useful .
 */



print("Resolves the bug in XCode")
