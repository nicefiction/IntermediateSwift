import Foundation


/**
 `3 Initialiser Delegation`
 INTRO — We have only written a single `init()` method
 per Class or Struct that we have created so far .
 In this video ,
 let's take a look at
 how _delegate initialisation_ work
 and how we can use multiple initialisers .
 */
/**
 During the initialisation process ,
 at times
 we may need to call on other initialisers
 in a process known as `initialiser delegation` .
 We have sort of seen what this looks like ,
 because when initialising subclasses ,
 we have called `super.init()` to delegate initialisation of a `base class` .
 `Initialiser delegation` is a bit more extensive than that , and differs
 based on whether using a `value type` or a `reference type` .
 Let's try and cover all our bases , and we'll start on the simple end
 by looking at value types using a Struct .
 */

struct Point {
    
    var x: Int = 0
    var y: Int = 0
}


struct Size {
    
    var width: Int = 0
    var height: Int = 0
}

/*
struct Rectangle {
    
    let origin: Point = Point()
    let size: Size = Size()
}
 */

/**
 Since `origin` and `size` here in the `Rectangle` have default values ,
 we can easily create an instance of `Rectangle`
 without needing to assign values by just doing that :
 */

// Rectangle()

/**
 Because `Rectangle` is a Struct ,
 we also have a `memberwise initialiser` that we can use ,
 as you can see right here ,
 
 `Rectangle(origin: Point ,`
           `size: Size)`
 
 to assign different values .
 Let's go ahead
 and instead of relying on the automatic initialiser ,
 let's write out the `memberwise initialiser` :
 */

/*
struct Rectangle {
    
    var origin: Point = Point()
    var size: Size = Size()
    
    
    init(origin: Point ,
         size: Size) {
        
        self.origin = origin
        self.size   = size
    }
}
 */

/**
 Inside the `init()` method ,
 we assign those values over to the stored properties .
 This initialiser is useful ,
 but the arguments that we are passing in here ,
 
 `init(origin: Point , size: Size) { ... }`
 
 are custom types ,
 `Point` and `Size` ,
 _which means they need to be constructed outside of the initialiser _.
 We have alluded to this in the past ,
 but both value and reference types can contain more than one initialiser .
 We have never written a second `init()` method before because , well , we didn't really need to .
 But here I'd like to write one that simply takes the values we need to construct `origin` and `size` ,
 and then does the work inside the `init()` method .
 So right below this initialiser ,
 we'll say `init()` with an `x` and a `y` value for the `Point` ,
 and then a `height` and a `width` value for the `Size` :
 */

/*
struct Rectangle {
    
    var origin: Point = Point()
    var size: Size = Size()
    
    
    init(origin: Point ,
         size: Size) {
        
        self.origin = origin // 🔴
        self.size   = size // 🔶
    }
    
    
    init(x: Int ,
         y: Int ,
         width: Int ,
         height: Int) {
        
        let origin = Point(x : x , y : y)
        let size = Size(width : width , height : height)
        
        self.origin = origin // 🔴
        self.size   = size // 🔶
    }
}
 */

/**
 Inside we can use these values — the parameters from the `init()` method —
 to construct an instance of `Point` and `Size` inside the initialiser
 and hide the work .
 So we'll say
 
 `let origin = Point(x : x , y : y)`
 
 We use the `memberwise initialiser` here .
 And we'll do the same for size ,
 
 `let size = Size(width : width , height : height)`
 
 we'll use the `memberwise initializer` on the `Size` Struct
 and we'll pass through the `width` and the `height` .
 From here ,
 now that we have these two values
 — `let origin` and `let size` ,
 we can assign these values to our `stored properties`
 — `var origin` and `var size` . We'll say
 
 `self.origin = origin`
 `self.size   = size`
 
 Do you see something interesting going on here though ?
 Down here ...
 */

// 🔴 🔶

/**
 ...  we are repeating the code ,
 the exact same lines of code that we just wrote in our memberwise initialiser .
 Instead of writing the same code again , instead of rewriting those lines ,
 how about we delegate initialisation from _this_ `init()` method ...

 `init(x: Int ,`
      `y: Int ,`
      `width: Int ,`
      `height: Int) {`
 
    `let origin = Point(x : x , y : y)`
    `let size = Size(width : width , height : height)`
 
    `self.origin = origin // 🔴`
    `self.size   = size // 🔶`
 `}`
 
 ... to this one ? :

 `init(origin: Point ,`
      `size: Size) {`
 
    `self.origin = origin // 🔴`
    `self.size   = size // 🔶`
 `}`

 So again ,
 rather than writing out those same lines of code ,
 we'll get rid of this and we'll say :
 */

/*
struct Rectangle {
 
    var origin: Point
    var size: Size
    
    init(origin: Point ,
         size: Size) {
        
        self.origin = origin
        self.size   = size
    }
    
 
    init(x: Int ,
         y: Int ,
         height: Int ,
         width: Int) {
        
        let origin = Point(x : x , y : y)
        let size = Size(width : width , height : height)
        
        self.init(origin : origin ,
                  size : size)
    }
}
 */

/**
 We use the initialiser we defined earlier ,

 `init(origin: Point ,`
      `size: Size) {`
 
    `self.origin = origin`
    `self.size   = size`
 `}`

 By calling `self.init` ,
 
 `self.init(origin : origin , size : size)`
 
 we are instructing another initialiser in the same type
 to finish up the initialisation process .
 In this way ,
 we can create many initialisers that serve custom needs ,
 different ways to construct the same class .
 But rather than all duplicating the work ,
 we can allow all of the object creation
 to pass through a single point .
 So for example ,

 `init(origin: Point ,`
      `size: Size) {`
 
    `self.origin = origin`
    `self.size   = size`
 `}`

 this is the single point that we are going to pass the object creation work through .
 So this init( ) method
 
 `self.init(origin : origin , size : size)`
 
 just delegates it to the first one :

`init(origin: Point ,`
     `size: Size) {`
    
    `self.origin = origin`
    `self.size   = size`
 `}`

 Here is another initialiser , for example :
 Instead of `origin` ,
 let's say we knew the center of the rectangle that we wanted to define , and the size ,
 and we want to create an instance using just that information :
 */

struct Rectangle {
    
    var origin: Point
    var size: Size
    
    
    init(origin: Point ,
         size: Size) {
        
        self.origin = origin
        self.size   = size
    }
    
    
    init(x: Int ,
         y: Int ,
         height: Int ,
         width: Int) {
        
        let origin = Point(x : x , y : y)
        let size = Size(width : width , height : height)
        
        self.init(origin : origin ,
                  size : size)
    }
    
    
    init(center: Point ,
         size: Size) {
        
        let centerX = center.x - size.width/2
        let centerY = center.y - size.height/2
        
        let origin = Point(x : centerX , y : centerY)
        
        // self.origin = origin
        // self.size = size
        self.init(origin : origin , size : size)
    }
}

/**
 So we'll create an init( ) method that takes
 a center of type Point rather than an origin ,
 and a size of type Size .
 And then inside the init( ) method ,
 we can use those values
 to figure out
 where the origin's x value will be ,
 which is
 
 `let centerX = center.x - size.width/2`
 
 And same thing for the origin's y value ,
 but this time we use the center's y value :
 
 `let centerY = center.y - size.height/2`
 
 Using these two values we just calculated ,
 we can define an origin :
 
 `let origin = Point(x : originX , y : originY)`
 
 And then again ,
 rather than writing out the same lines of code ,
 we'll delegate the work to that first initializer :
 
 `self.init(origin : origin , size : size)`
 
 By delegating ,
 we can use an initialiser that already provides the functionality we need .
 We avoid repeating code .
 Pretty simple , right ?
 Well , that is for value types .
 Reference types , on the other hand ,
 are a completely different beast .
 Let's check it out in the next video .
 */



/* * * * * * * * * *
 EPILOGUE OLIVIER */

// INITIALIZER 1 :
let rectangleDefault = Rectangle(origin : Point(x : 1 , y : 2) ,
                                 size : Size(width : 3 , height : 4))
/**
 OLIVIER : `rectangleDefault` corresponds to this initializer :
 
 `init(origin: Point ,`
      `size: Size) {`
 
    `self.origin = origin`
    `self.size   = size`
 `}`
 */



// INITIALIZER 2 :
let rectangle = Rectangle(x : 1 ,
                          y : 2 ,
                          height : 3 ,
                          width : 4)
/**
 OLIVIER : `rectangle` corresponds to this initializer :
 
 `init(x: Int ,`
      `y: Int ,`
      `height: Int ,`
      `width: Int) {`
 
    `let origin = Point(x : x , y : y)`
    `let size = Size(width : width , height : height)`
 
    `self.init(origin : origin , size : size)`
 `}`
 */



// INITIALIZER 3 A :
let rectangleCenter = Rectangle(center : Point(x : 1 , y : 2) ,
                                size : Size(width : 3 , height : 4))
/**
 OLIVIER : `rectangleCenter` corresponds to this initializer :
 
 `init(center: Point ,`
 `size: Size) {`
 
 `let centerX = center.x - size.width/2`
 `let centerY = center.y - size.height/2`
 
 `let origin = Point(x : centerX , y : centerY)`
 
 `// self.origin = origin`
 `// self.size = size`
 `self.init(origin : origin , size : size)`
 `}`
 */



// INITIALIZER 3 B :
let rectangleDefaultCenterSize = Rectangle(center : Point() , size : Size())

/**
 OLIVIER : `rectangleDefaultCenterSize`is making use of the default values from the seperate structs :
 
 `struct Point {`
 
    `var x: Int = 0`
    `var y: Int = 0`
 `}`
 
 
 `struct Size {`
 
    `var width: Int = 0`
    `var height: Int = 0`
 `}`
 */
