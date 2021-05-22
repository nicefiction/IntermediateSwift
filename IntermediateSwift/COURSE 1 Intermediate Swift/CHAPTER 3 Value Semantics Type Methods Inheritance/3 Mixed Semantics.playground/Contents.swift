import Foundation


/**
 `3 Mixed Semantics`
 INTRO — We know how both value and reference types work ,
 but what happens when you mix the two together in a single type .
 You won't believe what happens next !
 */
/**
 In previous videos we looked at
 certain aspects of value types that might be tricky
 and concepts regarding reference types that might have eluded us .
 What happens when we mix those two types together however ?
 Let's paste in some code :
 */

struct Point {
    
    var x: Double
    var y: Double
    
    
    mutating func moveLeft(steps: Double) {
        
        x -= steps
    }
}


struct Size {
    
    let width: Double
    let height: Double
}


struct Rect {
    
    let origin: Point
    let size: Size
}


struct Color {
    
    let red: Double
    let green: Double
    let blue: Double
    let alpha: Double
    
    
    static var blue: Color {
        
        return Color(red : 0 ,
                     green : 0 ,
                     blue : 1)
    }
    
    
    static var red: Color {
        
        return Color(red : 1.0 ,
                     green : 0 ,
                     blue : 0)
    }
    
    
    static var white: Color {
        
        return Color(red : 0 ,
                     green : 0 ,
                     blue : 0)
    }
    
    
    init(red: Double ,
         green: Double ,
         blue: Double ,
         alpha: Double = 1.0) {
        
        self.red   = red/255.0
        self.green = green/255.0
        self.blue  = blue/255.0
        self.alpha = alpha
    }
}


class View {
    
    var frame: Rect
    var backgroundColor: Color = .white
    
    
    init(frame: Rect) {
        
        self.frame = frame
    }
}

/**
 So let's say we are working on an app .
 The app is a drawing app ,
 and we want a way to represent shapes .
 But it is really important that once a shape is created ,
 we don’t want the original to be modified in any way .
 So we think we want a value type ,
 because if we change the shape we'll get a new copy , right .
 We'll leave that original shape unchanged . It is immutable .
 Okay so let's represent this shape as a struct , good old value types :
 */

struct Shape {
    
    let view: View
    
    
    init(x: Double ,
         y: Double ,
         width: Double ,
         height: Double ,
         color: Color) {
        
        let origin           = Point(x : x , y : y)
        let size             = Size(width : width , height : height)
        let rect             = Rect(origin : origin , size : size)
        self.view            = View(frame : rect)
        view.backgroundColor = color
    }
}

/**
 A shape needs to be drawn on screen
 and we'll assume that in our code base
 this is done by the View class .
 `class View { ... }`
 The View models our logic and how it is represented on a digital screen .
 
 `NOTE` : By the way ,
 I am oversimplifying this example quite a bit
 to show you some pitfalls ,
 so don't take this as a good way to model a shape .
 
 Okay
 so a shape needs to be drawn on screen ,
 and we'll use a View to do that .
 Now we can set up this shape’s View in an `init()` method
 with parameters
 like the origin — x and y —
 and the height and width :
 */

/*
 struct Shape {
     
     let view: View
     
     
     init(x: Double ,
          y: Double ,
          width: Double ,
          height: Double ,
          color: Color) {
         
         let origin           = Point(x : x , y : y)
         let size             = Size(width : width , height : height)
         let rect             = Rect(origin : origin , size : size)
         self.view            = View(frame : rect)
         view.backgroundColor = color
     }
 }
 */

/**
 Now we have a basic shape
 that is represented by a value type .
 The value type has a stored property —`let view: View` —
 that is a constant to ensure that it cannot be changed .
 Let's use this structure now to create an instance of a square :
 */

let square = Shape(x : 0 ,
                   y : 0 ,
                   width : 100 ,
                   height : 100 ,
                   color : .red)

/**
 `NOTE` : Notice here that I am not saying `color.red`
 because the compiler is smart enough to figure out that
 since this value has an argument type of `Color`
 `.red` refers to that computed property .
 We don't need to say `Color.red` .
 
 Now again
 to be sure that my `Shape` — my `square` — cannot be changed ,
 I am assigning it to a constant :
 
 `let square = Shape(x : 0 ,`
                    `y : 0 ,`
                    `width : 100 ,`
                    `height : 100 ,`
                    `color : .red)`
 
 so a shape that we have created has a `width` and a `height` of `100` , and it is red .
 Now imagine that someone comes along in my code ,
 and changes the colour of the shape .
 */

square.view.backgroundColor = .blue

/**
 Well of course you can't do this , right ?
 Sadly
 — as you can see from the lack of errors —
 you can ,
 ⚠️
 and herein lies the danger of creating value types
 that use reference types within .
 As we have explained before
 even though this instance of a struct
 
 `let square = Shape(x : 0 ,`
                    `y : 0 ,`
                    `width : 100 ,`
                    `height : 100 ,`
                    `color : .red)`
 
 is assigned to a constant `let square`
 and despite the property — the stored property — being a constant :
 
 `struct Shape {`
 
    `let view: View`
 
    `...`
 `}`
 
 nothing prevents us from modifying the underlying reference type .
 Remember ,
 `view` is a reference type :
 
 `square.view.backgroundColor = .blue`
 
 It is a class :
 
 `class View { ... }`
 
 And as long as we have a reference to it ,
 we can change the values and nothing goes wrong
 because what is constant
 is the _link_
 to the object in memory ,
 though reference and not the actual object .
    Structs containing value — OLIVIER : _reference_ ? — types
 can lead to unexpected behaviours .
 You can mutate things
 as much as you want
 on the reference types
 and they don't trigger that copy behaviour
 that we have come to expect in Structs .
 
 
 The point of these last few videos have not been
 to necessarily teach you anything new
 but to highlight spots where you may unwittingly write code
 you think behaves one way
 but in reality there is something totally different .
 ⚠️
 `Value types` that contain `reference types`
 aren't 100% the immutable sleeve types
 that you have come to expect them to be .
 So tread carefully if your model design includes code like this ,
 and code that you are relying on to not change .
 */

