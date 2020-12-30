import Foundation


/**
 `5 Final Classes`
 INTRO — We learned earlier that
 one of the advantages of classes is inheritance .
 There are instances though ,
 where we want to use a class ,
 but we don't want anyone to be able to create a subclass .
 In this video ,
 let's take a look at what a final class is .
 */
/**
 Type methods in value types are pretty easy ,
 you just use the static keyword .
 In fact , most things are easier with value types .
 With reference types on the other hand ,
 inheritance adds a few additional requirements .
 Just like an instance method in a class ,
 we may want our type methods
 to also be inherited in some classes .
 Let's create a new type :
 */
class Calculator0 {}
/**
 We are going to use this example to highlight how type methods differ . Mind you ,
 this example is a bit contrived and quite mathy ,
 but it illustrates the point pretty well .
 Our calculator class will have many type methods
 that allow us to quickly use certain math functions .
 To create a type method on a class ,
 we are going to start with the class keyword :
 */
class Calculator {
    
    class func squareRoot(_ value: Double)
    -> Double {
        
        return sqrt(value)
    }
}
/**
 We can use `static` — and we did that earlier in a different course — but not just yet .
 We'll get there .
 Now that we have a type method on a class we can use it :
 */
Calculator.squareRoot(64)
/**
 Classes are for inheritance , as we know .
 So let's create a new subclass of Calculator , called NewtonCalculator :
 */
class NewtonCalculator0: Calculator {}
/**
 NewtonCalculator does everything that Calculator can do
 but it does so using unique methods of computation that Isaac Newton came up with way back in the day .
 */
NewtonCalculator0.squareRoot(49)
/**
 Since NewtonCalculator inherits from Calculator ,
 this means that we can already use the squareRoot( ) method , to get the same answer .
 But let's say again
 that we wanted to use Newton's specific method of calculating square roots .
 Just like we can override any of a superclasses methods in a subclass .
 We can override the type method as well , and provide a new implementation .
 Now in here, I'm just going to paste the body of the method in :
 */
class NewtonCalculator: Calculator {
    
    override class func squareRoot(_ value: Double)
    -> Double {
        
        var guess: Double = 1.0
        var newGuess: Double
        
        
        while true {
            
            newGuess = (value/guess + guess) / 2
            if guess == newGuess {
                return guess
            }
            
            guess = newGuess
        }
    }
}


NewtonCalculator.squareRoot(16)
/**
 What you should notice here , is ,
 that we overrode the method implementation by using the `override` keyword
 just as we normally do with instance methods .
 And in the result there ,
 `NewtonCalculator.squareRoot(16)`
 you can see that our new implementation gives the same answer .
 So this is what the `class` keyword gives you ,
 `override class func squareRoot(_ value: Double) -> Double { ... }`
 When you annotate a method with the `class` keyword ,
 not only does it create a type method ,
 but it allows you to override the method in subclasses to provide your own implementation .
 Methods of this kind are _dynamically dispatched_
 this means that when we call the squareRoot( ) method ,
 the compiler does not know which specific method we are calling .
 For example when we called the squareRoot( ) method on the NewtonCalculator ,
 `NewtonCalculator0.squareRoot(49)`
 the first time around ,
 before we overrode squareRoot( ) method ,
 it ended up calling squareRoot( ) on the base class Calculator :
 */
/*
 class Calculator {
     
     class func squareRoot(_ value: Double)
     -> Double {
         
         return sqrt(value)
     }
 }
 */
/**
 But after we provided implementation ,
 it now calls the implementation provided in the `NewtonCalculator` class .
 Therefore it is dynamically dispatched .
 At run time it figures out where the implementation is ,
 which class it is defined in ,
 and then calls it in that specific class .
 
 _What if we wanted to not be able to override the method though ?_
 Let's say we have another method in Calculator :
 */
class Calculator2 {
    
    class func squareRoot(_ value: Double)
    -> Double {
        
        return sqrt(value)
    }
    
    
    class func square(_ value: Double)
    -> Double {
        
        return value * value
    }
}
/**
 We only ever want square( ) to have this implementation ,
 and I don't want any subclass to override it .
 Unfortunately reference types like classes are always inheritable , right ?
 That is the whole point of using classes .
 Actually that is not true .
 By adding the keyword `final` in front of the method name ,
 we prevent the method from being overridden . So , let's give that a try :
 */
class Calculator3 {
    
    class func squareRoot(_ value: Double)
    -> Double {
        
        return sqrt(value)
    }
    
    
    final class func square(_ value: Double)
    -> Double {
        
        return value * value
    }
}
/**
 So down here ,
 if I were to say `override class func square( )` , ...
 */
class NewtonCalculator2: Calculator3 {
    
    override class func squareRoot(_ value: Double)
    -> Double {
        
        var guess: Double = 1.0
        var newGuess: Double
        
        
        while true {
            
            newGuess = (value/guess + guess) / 2
            if guess == newGuess {
                return guess
            }
            
            guess = newGuess
        }
    }
    
    
    // override class func square(_ value: Double) -> Double { return 1.00 } // ERROR : Class method overrides a 'final' class method .
}
/**
 ... you’ll see that you get an error . There we go .
 Basically , if a method in the class is marked as `final` .
 You cannot override it in any subclasses
 and this applies to both type methods and instance methods . By marking it as `final`
 `final class func square(_ value: Double) -> Double { ... }`
 since the compiler knows this is going to be the only implementation of this method .
 The method can be `statically dispatched` just like for value types .
 So if we were to call `square( )` on `NewtonCalculator3` ...
 */
class NewtonCalculator3: Calculator3 {
    
    override class func squareRoot(_ value: Double)
    -> Double {
        
        var guess: Double = 1.0
        var newGuess: Double
        
        
        while true {
            
            newGuess = (value/guess + guess) / 2
            if guess == newGuess {
                return guess
            }
            
            guess = newGuess
        }
    }
}


NewtonCalculator3.square(100)
/**
 the compiler doesn't have to figure out if there is an implementation in NewtonCalculator3
 and whether it should call that or if there is one in Calculator3 and if it should call that .
 Because this method is marked as `final` ,
 `final class func square(_ value: Double) -> Double { ... }`
 it knows that this is always the only implementation .
 In fact , for reference types , for classes ,
 `static` — the keyword we used once — is simply an alias for `final class` .
 We can replace the `final class` keyword with a single word `static` ,
 and get the same behaviour :
 */
class Calculator4 {
    
    class func squareRoot(_ value: Double)
    -> Double {
        
        return sqrt(value)
    }
    
    
    static func square(_ value: Double)
    -> Double {
        
        return value * value
    }
}
/**
 `GOOD PRACTICE` :
 So now that you know all about the behaviours of type methods .
 Which should you use : `class` or `static` ?
 In general ,
 always use `static` to create type methods .
 The only time you should create a _dynamically dispatched type method_ , is ,
 if your subclasses really need to override it ,
 which obviously is a case by case thing .
 
 Before we conclude this video ,
 I want to point out one important thing .
 A few seconds ago , I said ,
 if it is marked as `final` ,
 you can't override it .
 _Does this apply to only type methods or can we mark instance methods as well as final ?_
 And I said
 yes ,
 you could .
 In fact ,
 you can even mark the entire class as final :
 */
final class NewtonCalculator4: Calculator3 {
    
    override class func squareRoot(_ value: Double)
    -> Double {
        
        var guess: Double = 1.0
        var newGuess: Double
        
        
        while true {
            
            newGuess = (value/guess + guess) / 2
            if guess == newGuess {
                return guess
            }
            
            guess = newGuess
        }
    }
}
