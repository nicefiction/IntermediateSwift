import Foundation


/**
 `2 Computed Properties`
 INTRO — Our next variation on an instance's properties is a computed property .
 A computed property does not actually store a value ,
 but computes it
 based on the values of other stored properties in our class .
 */
/**
 In the last video , we have seen our first variation on a property .
 But it wasn't all that different . So , what's next ?
 Well , let's go back to instance properties for a second and define a new type .
 Let's say we have a struct called Rectangle that represents a rectangle .
 Rectangles are defined by their lengths and widths , so
 let's add that in as stored properties :
 */
struct Rectangle2 {
    let length: Int
    let height: Int
}
/**
 Now, let's say we wanted the area of this rectangle .
 One way we could do it — the way we have been doing it so far — is
 to write an instance method to calculate it based on the length and width .
 But there is a nicer way to do this .
 Let's add a property called area :
 */
struct Rectangle {
    let length: Int
    let height: Int
    
    var area: Int {
        return length * height
    }
}
/**
 Instead of assigning a value to the area property ,
 we are going to use a set of braces like we would when we start the body of a function .
 Inside the body of the property , we treat it much like a function . So here ,
 it will return the value of multiplying length by width using the other stored properties .
 Now if we were to create an instance of rectangle and assign some values :
 */
let rectangle = Rectangle(length : 10 ,
                          height : 12)
print(rectangle.area)
/**
 we can access the area just like a normal stored property , pretty cool .
 We get the value back .
 What we just did , is , create a computed property .
 Unlike a stored property , a computed property doesn't actually store a value .
 It computes the value based on the values of other stored properties in our class . In earlier courses,
 there were many instances where a computed property would have sufficed .
 But we wrote a function because that was our only option .
 Now you can use computed properties .
 It is important to note that this computed property ,
 `var area: Int { return length * height }`
 just like these stored properties ,
 `let length: Int`
 `let height: Int`
 are instance properties .
 They need an instance to be created before we can use it , just like you see here :
 `let rectangle = Rectangle(length : 10 , height : 12)`
 `print(rectangle.area)`
 
 `NOTE` that computed properties
 use other stored properties at the same level of scoping . So ,
 because this is an instance computed property , ...
 `var area: Int { return length * height }`
 ... it can use the stored properties that we have defined here ,
 `let length: Int`
 `let height: Int`
 We can also create computed properties that are set on the type , rather than an instance ,
 just like before
 by using the static method .
 If we were to go back , for example ,
 and say define a static property x that returns an integer , ...
 */
struct Point {
    let x: Int
    let y: Int
}


struct Map {
    static var origin: Point = Point(x : 0 ,
                                     y : 0)
    
    static var x: Int {
        return origin.x
    }
}
/**
 ... we can use the origin property because it is at the same level ,
 it is scoped to the type . So we can say
 `return origin.x`
 and we get the same behaviour.
 But that is not all there is to a computed property .
 With stored properties ,
 we can both read and write values .
 Can we do that with a computed property ?
 Yes ,
 sort of .
 What we just created here — area — is a read only computed property ,
 `var area: Int { return length * height }`
 So , let’s get rid of the code that we just wrote here ,
 and create a new version of Rectangle ,
 */
struct Point2 {
    var x: Int = 0
    var y: Int = 0
}
/**
 So we have a struct Point up here ,
 and I am going to assign it some default value ,
 And then down back over here ,
 we'll define a new struct called Size ,
 */
struct Size {
    var width: Int = 0
    var height: Int = 0
}
/**
 Now we can define a Rectangle that has an origin :
 */
struct Rectangle3 {
    var origin: Point2 = Point2()
    var size: Size = Size()
}
/**
 `NOTE` : Because these — Point and Size — have default values ,
 the Rectangle's origin is 0 , 0 ,
 and its size is also 0 ,0
 — so basically it is just a dot .
 Using this information in Rectangle ,
 we would like to add a computed property for the centre of the rectangle .
 So we have an origin ,
 `var origin: Point2 = Point2()`
 and we have a size ,
 `var size: Size = Size()`
 So ,
 ( 1 ) we want to know where the centre [ OLIVIER : of the Rectangle ] lies . And
 ( 2 ) , we also want to be able to assign a value to centre , which will
 ( 2.1 ) then change the values for origin and size and
 ( 2.2 ) be able to read the centre value based off of the values and other properties .
 So we can use a computed property to do that , again ,
 we are going to start with the keyword var .
 Because computed properties cannot be constants
 because we are not assigning a value permanently .
 Once we are always computing anything , it needs to be a variable ,
 we'll give this property a name , centre .
 */
struct Rectangle4 {
    var origin: Point2 = Point2()
    var size: Size = Size()
    
    var center: Point2 {
        get {
            let centerX = origin.x / 2
            let centerY = origin.y / 2
            
            return Point2(x : centerX ,
                          y : centerY)
        }
        
        set (centerValue) {
            origin.x = centerValue.x + ( size.width / 2 )
            origin.y = centerValue.y + ( size.height / 2 )
        }
    }
}
/**
 Unlike stored properties ,
 where you can assign a value ,
 and the compiler determines a type ,
 computed properties always require a type annotation ,
 since the value is only computed when we need it .
 You can think of a computed property as syntactic sugar for a method .
 It takes no parameters ,
 and it has a return type they can never be void .
 So in this case ,
 the return type will be Point .
 There are two aspects to a property ,
 ( 1 ) reading — or getting a value — and ( 2 ) writing — or setting a value :
 
 ( 1 ) Let’s start with how we want the computed property to behave
 when we get the value — when we read it . So first ,
 we'll start with the keyword get ,
 since a point or return type contains an x and a y value ,
 let's calculate the centre of this rectangle
 and determine each of those values . So we'll say
 
 Now here ,
 we need to make these variables ,
 `struct Point2 { var x: Int = 0 , var y: Int = 0 }`
 so that we can always assign different values to it .
 So that is a getter done .
 Every time we call centre ,
 we are going to get a computed property that calculates the centre dynamically and returns it to us .
 But in this challenge of ours ,
 we also want to assign a centre to a Rectangle instance
 and have it change either the size or the origin to match the new centre .
 So to do that ,
 
 ( 2 ) we’ll start with the keyword set , which is the opposite of get .
 Like we started with the get keyword for the getter ,
 the set keyword encapsulates the code that is run
 after a value is assigned to the centre property .
 And we can bind this new value that we assigned
 to a local constant , centreValue .
 Because a computed property cannot store a value ,
 we need to use this value — centreValue — in some way .
 Given a rectangle of a fixed size — we are going to assume it is going to be fixed —
 a new centreValue means , we need to shift the origin — which is exactly what we will do .
 origin is a stored property , so it can store a value . So we'll say ,
 `origin.x = centerValue.x + ( size.width / 2 )`
 origin.x is the new centre we are assigning .
 We do the same thing for the origin's y value ,
 `origin.y = centerValue.y + ( size.height / 2 )`
 And there you go ,
 now we can use this much like a regular property ,
 in that it seemingly behaves like a stored property .
 So we can create an instance of the Rectangle ,
 and we can print the rectangle's centre . So , we'll say ,
 */
var rectangle2 = Rectangle4()
print("Original size : \(rectangle2.center)")
/**
 You'll see ,
 initially ,
 because a rectangle has an origin of 0 , 0 and the size of 0 , 0 ,
 we get a point back for the center saying 0 , 0 .
 Now , we are going to assign a new center .
 */
rectangle2.size = Size(width : 20 ,
                       height : 15)

print("New size : \(rectangle2.center)")

rectangle2.origin = Point2(x : 10 ,
                           y : 15)
/**
 And now if we print out the rect.centre ,
 */
print("After changing the origin , the new center is \(rectangle2.center)")
/**
 even though it is calculated dynamically , it feels like we assigned it .
 It feels like a stored property , but you'll also notice
 that the rectangle's origin is no longer 0 , 0 .
 
 `NOTE` There is a minor improvement we can make to our code .
 We don't necessarily need to bind this new value to a local constant — `centreValue` .
 Because Swift automatically binds this to a constant named `newValue` .
 So you can simply use newValue here . But I feel like centreValue reads better .
 */
