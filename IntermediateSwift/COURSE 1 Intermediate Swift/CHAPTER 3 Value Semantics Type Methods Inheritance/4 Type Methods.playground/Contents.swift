import Foundation


/**
 `4 Type Methods`
 INTRO — Earlier we learned about type properties ,
 but let's switch gears here , and learn about type methods .
 */
/**
 Value and reference semantics are a bit of a mind boggling topic .
 So let's switch to something more straightforward for now .
 We started this course by looking at a simple concept , type properties .
 Just like we can add properties to the type itself ,
 we can also add type methods . But you knew this ,
 because we have already written a type method in the past .
 When we did that we use the keyword `static` , but we jumped ahead a bit .
 So let's dial it back and work our way through
 some of the different options
 and what they mean .
 Let's create a struct again , one that we have seen earlier :
 */
struct Point {
    
    var x: Double
    var y: Double
}


struct Map {
    
    static let origin: Point = Point(x : 0.00 ,
                                     y : 0.00)
}
/**
 Given an arbitrary point ,
 we want to calculate the distance of that point from the origin .
 We could make this an instance method
 but the computation does not depend on any values being assigned to stored properties .
 The only information we need , given a point , is
 the location of the origin
 which is a static property . And this could be a free function ,
 but since it deals with an aspect of the Map , we are going to add it to our type .
 To create a type method ,
 we are going to start with a keyword `static` .
 After that , we write the method out just like we would any instance method .
 This method takes a point and computes the distance from the origin .
 And this involves a bit of math , so I'll just do the work for you :
 */
struct Map2 {
    
    static let origin: Point = Point(x : 0.00 ,
                                     y : 0.00)
    
    
    static func calculateDistanceFromOrigin(to point: Point)
    -> Double {
        
        let horizontalDistance = origin.x - point.x
        // let horizontalDistance = Map2.origin.x - point.x
        let verticalDistance = origin.y - point.y
        
        
        // GOOD PRACTICE :
        func square(_ value: Double)
        -> Double {
            
            return value * value
        }
        
        
        let horizontalDistanceSquared: Double = square(horizontalDistance)
        let verticalDistanceSquared: Double = square(verticalDistance)
        
        return sqrt(horizontalDistanceSquared + verticalDistanceSquared)
    }
}
/**
 First we calculate the horizontal distance ,
 that is the distance between the origin's X coordinate and the point's X coordinate .
 `let horizontalDistance = origin.x - point.x`
 `NOTE` : You'll see here that because this method , the type method
 is scoped , or is at same level as the property , `static let origin` .
 They — `static let origin`
 and `static fun calculateDistanceFromOrigin(to point: Point)` —
 are both on the type
 we can access it here without having to say `Map.origin.x`
 because both are at the Map level and not the instance level .

 Similarly we'll need the vertical distance
 and we'll use the respective coordinates :
 `let verticalDistance = origin.y - point.y`

 Now to get the distance using these values ,
 again we'll do a bit of math . And the way we do this , is ,
 first we are going to square both of these values
 then we are going to get this sum of the two
 and return the square root of that resulting value .
 To square the values we can simply multiply horizontal value by itself
 but makes our code look ugly .
 We could write a helper method _square_
 that takes a value
 and returns the value multiplied by itself .
 But if we try that and add it as an instance method ,
 you'll notice that you won't be able to use it inside a static method
 because you first need to create an instance .
 `GOOD PRACTICE` : Now we could add it as a second type method
 but unlike instance methods ,
 helper type methods aren't really a thing .
 You only want methods strictly associated with the types functionality ,
 swift however , lets you do a cool thing , and that is ,
 nesting functions inside other functions .
 So inside the static distance( ) method
 I can write a small helper function to use :
 `func square(_ value: Double) -> Double { ... }`
 And now we can use the square( ) function ,
 because it is available inside the static distance( ) method , we’ll say :
 `let horizontalDistanceSquared: Double = square(horizontalDistance)`
 `let verticalDistanceSquared: Double = square(verticalDistance)`
 Okay , for the last bit of logic ,
 we need to return the square root of the sum of these values ,
 because again , math .
 And there is a square root function defined in the `Foundation` framework .
 We'll `import Foundation`
 and then , at the bottom , we'll return the value :
 `return sqrt(horizontalDistanceSquared + verticalDistanceSquared)`
 
 
 
 `Notice` , in this example we are using a value type .
 With value types ,
 we always declare
 both type methods and type properties
 with the `static` keyword .
 `static` here refers to two things :
 ( 1 ) That this method is associated at the type level rather than an instance .
 ( 2 ) That the method is statically dispatched .
 A simple way to think about `static dispatch` , is
 that the compiler knows which method you intend to call at compile time .
 Now hold onto that definition for a second .
 By comparing it to `dynamic dispatch` in the next video
 we should be able to get a better understanding of both .
 */
