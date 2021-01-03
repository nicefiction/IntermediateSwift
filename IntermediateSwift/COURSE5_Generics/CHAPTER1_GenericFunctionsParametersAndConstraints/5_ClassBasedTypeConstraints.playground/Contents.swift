import Foundation

/**
 `5 Class Based Type Constraints`
 INTRO — Just like we can introduce
 protocol based constraints
 on generic type parameters
 we can also add class based constraints .
 */
/**
 Unlike protocol-based constraints
 — which we'll tend to run into quite often when we write generic code —
 standalone class-based constraints are somewhat rare .
 We are going to look at a trivial example here that won't really settle the matter right now ,
 but we'll come back around to it .
 So let's say we have a class called `Shape` :
 */
class Shape {}
/**
 We'll keep this class empty .
 All that we care about right now , is ,
 that it is a class .
 Next ,
 we'll write a generic function called `center`
 whose goal is
 to find the centre of a given shape :
 */
func center<T>(of shape: T) {
    
    print("Called")
}
/**
 This won't make much sense yet ,
 but for now ,
 we have added a single type parameter T .
 For the argument list
 we accept a `shape` of type `T` .
 If we were writing proper code
 this would just be either a computed property or a method on the Shape instance .
 But for now , in the body of the function ,
 we won't do anything other than just print a statement .
 Now , of course , there are no constraints on T ,
 so we are not really guaranteeing that a Shape will be passed in .
 And in fact , you can pass in an Integer over here .
 So , let’s add a class-based constraint :
 */
func center2<T: Shape>(of shape: T) {
    
    print("Called2")
}
/**
 When we do this ,
 what we are saying , is ,
 that `T` needs to be either an instance of `Shape` , or a subclass of `Shape` .
 To verify this , right after the function
 we can create an instance of Shape ,
 and we can pass it into the center( ) function :
 */
let testShape = Shape()
center2(of : testShape)
/**
 And you see that the print statement inside the center( ) function
 has been called .
 This works as expected
 because `testShape` is an instance of `Shape` .
 Similarly , we can create a subclass of Shape . So ,
 we’ll say class Square , which inherits from Shape :
 */
class Square: Shape {}

let testSquare = Square()
center2(of : testSquare)
/**
 We can create an instance of Square .
 And we can use it as an argument in the center of function ,
 and this works as well .
 Finally ,
 we can also verify that classes that are not of type Shape ,
 or that are not subclasses of Shape ,
 do not satisfy the constraints of our generic function .
 So , if I had a random class named `View` ,
 */
class View {}
/**
 I'll create an instance of View
 and I'll pass it as an argument to the center of function ,
 */
let testView = View()
// center2(of: testView) // ERROR : Global function 'center2(of:)' requires that 'View' inherit from 'Shape' .
/**
 And you see that this doesn't work , as expected , it fails .
 Now , let me comment it out .
 So , even though this code that we have written here ...
 `let testShape = Shape()`
 `center2(of : testShape)`
 `let square = Square()`
 `center2(of : square)`
 ... satisfies the constraints of our generic function .
 The reason that this isn't a compelling argument for generics , is ,
 because we can simply write something like this :
 */
func centerOf(_ shape: Shape) {
    
    print("Center")
}
/**
 `NOTE` : Just to differentiate this function with the previous one I have written ,
 I’ll put `Of` outside of the argument list — or in the base method name .
 I also print `"Center"` — just to differentiate it again
 with the print statement from the `center( )` function .
 
 And now , I can call the `centerOf( )` function
 and pass in the `testShape` or the `testSquare` instance ,
 */
centerOf(testShape)
centerOf(testSquare)
/**
 and this works as well .
 It works in the exact same way
 and it doesn't complicate our code
 by making it a generic one with generic types and constraints .
 The `centerOf( )` function — if you were to test it out —
 */
// centerOf(testView) // ERROR : Cannot convert value of type 'View' to expected argument type 'Shape' .
/**
 So , why would we even use class constraints ?
 Well , for that ,
 we need to take our understanding of type constraints a bit further .
 But let's not get ahead of ourselves .
 Now that we know how to write class-based constraints ,
 let's take a break and look at generic types .
 */
