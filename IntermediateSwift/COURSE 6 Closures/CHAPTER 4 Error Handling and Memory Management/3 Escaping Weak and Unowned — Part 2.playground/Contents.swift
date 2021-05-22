import Foundation


/**
 `3 Escaping, Weak and Unowned` PART 2 OF 2
 */
/**
 The last topic we are going to talk about here is `reference cycles` .
 We mentioned earlier
 that closures are reference types
 because they can capture a reference to an object
 defined outside of its scope .
 Because they are reference types
 — just like classes —
 we can also run into `strong reference cycles` when using closures .
 Let's look at an example :
 */

/*
class Fibonacci {
    
    var value: Int
    
    
    init(value: Int) {
        
        self.value = value
    }
    
    
    lazy weak var fibonacci: () -> Int = { () -> Int in
        
        // Some temporary variables.
        var a = 0
        var b = 1
        
        // Add up numbers to the desired iteration.
        for _ in 0..<self.value {
            
            let temp = a
            a = b
            b = temp + b
        }
        
        return a
    }
    
    
    deinit {
        
        print("\(value) is being deinitialized . Memory deallocated .")
    }
}
*/

var f = Fibonacci(value : 7)
f.fibonacci()

/**
 Here , we have a class called `Fibonacci`
 that helps us get values in a `Fibonacci` sequence .
 You initialise this class with a number ,
 
 `init(value: Int) {`
 
    `self.value = value`
 `}`
 
 which I have done here ,
 
 `let f = Fibonacci(value : 7)`

 and then
 you call the `fibonacci` property ,
 
 `f.fibonacci()`
 
 to get the corresponding `Fibonacci` value .
 So , `fibonacci` here ,
 
 `f.fibonacci()`
 
 is a `lazy store property`
 to which we have assigned a closure .
 
 `lazy var fibonacci: () -> Int = { () -> Int in`
 
    `// Some temporary variables .`
    `var a = 0`
    `var b = 1`
 
    `// Add up numbers to the desired iteration .`
    `for _ in 0..<self.value {`
 
        `let temp = a`
        `a = b`
        `b = temp + b`
    `}`
 
    `return a`
 `}`
 
 The implementation of this closure is
 an iterative approach
 to obtaining a Fibonacci value .
 Not really important .
 The interesting part , though , is ,
 _inside the closure_ . Here ,
 in this `for loop` , ...
 
 `for _ in 0..<self.value {`

     `let temp = a`
     `a = b`
     `b = temp + b`
 `}`
 
 the closure captures a reference to `self`
 by calling this `value` property .
 
 `class Fibonacci {`
     
    `var value: Int`
 
    `...`
 `}`
 
 Because this is a reference type
 — `Fibonacci` is a class —
 and by default we have _strong relationships_ .
 This
 
 `for _ in 0..<self.value { ... }`
 
 is a strong relationship from the closure
 — this closure right here — ...
 
 `lazy var fibonacci: () -> Int = { () -> Int in`
 
    `// Some temporary variables .`
    `var a = 0`
    `var b = 1`
 
    `// Add up numbers to the desired iteration .`
    `for _ in 0..<self.value {`
 
        `let temp = a`
        `a = b`
        `b = temp + b`
    `}`
 
    `return a`
 `}`
 
 ... to the `Fibonacci` class .
 If that were just the case , that'd be okay .
 But we have a problem .
 Since this closure is also assigned to a stored property
 
 `lazy var fibonacci: () -> Int = { ... }`
 
 which also has a strong relationship by default ,
 we now have a `strong reference`
 going from the class
 to the closure as well
 which — as we know — creates a `reference cycle` .
 To prove this , I have some code down here :
 */

var t: Fibonacci? = Fibonacci(value : 8)
t?.fibonacci()

/**
 And we have a `deinit()` method
 where I have added a `print()` statement
 to show that the class is being deinitialised , in the memory , deallocated :
 
 `deinit {`
 
    `print("\(value) is being deinitialized . Memory deallocated")`
 `}`
 
 So here ,
 if we create an optional instance of Fibonacci ,
 
 `var t: Fibonacci? = Fibonacci(value : 8)`
 
 use it ,
 and then assign `nil` to the variable , ...
 */

t = nil

/**
 ... you'll see , or you wont see , a log statement .
 Okay , so as you can see here ,
 
 `var f = Fibonacci(value : 7) // RESULTS AREA : Fibonacci`
 `f.fibonacci() // RESULTS AREA : 13 `
 
 `var t: Fibonacci? = Fibonacci(value : 8) // RESULTS AREA : Fibonacci`
 `t?.fibonacci() // RESULTS AREA : 21`
 `t = nil // RESULTS AREA : nil`
 
 this code works .
 We have got a Fibonacci value — `21` .
 But when we assign `nil` ,
 you don't see a log statement from the the `deinit()` method .
 Meaning that the instance has not been deinitialised
 because of that `strong reference cycle` .
 So , just like we had to keep this in mind with classes ,
 when using closures
 you need to be aware of reference cycles .
 
 _How do we solve them , though ?_
 
 We could make the `fibonacci` property a `weak` one :
 
 `OLIVIER :`
 `lazy weak var fibonacci: () -> Int = { () -> Int in ... } //  ERROR : 'weak' may only be applied to class and class-bound protocol types, not '() -> Int' .`
 
 But we won't always be using closures
 that capture `self` as `weak` properties
 in the sense that we won't be always using it as a stored property .
 So we need to figure out another approach .
 Closures solve this problem by defining what is called a `capture list`
 as part of the closure’s definition .
 A `capture list` defines the rules to use
 when capturing reference types
 within a closure's body ,
 as we are doing here — `self.value`,
 
 `for _ in 0..<self.value {`
 
    `let temp = a`
    `a = b`
    `b = temp + b`
 `}`
 
 Remember that
 when using it with value types
 — like if this were a struct —
 that doesn't matter .
 As with strong reference cycles between class instances ,
 you can declare captured references in a closure as `weak` or `unowned` ,
 rather than a strong reference .
 Now , we haven't talked about `unowned` before ,
 but we will talk about it in just a second .
 A `capture list`
 sort of looks like an `Array`
 defined at the start of the closure body .
 So this is the start of the closure body right here :
 */

/*
class Fibonacci {
    
    var value: Int
    
    
    init(value: Int) {
        
        self.value = value
    }
    
    
    lazy var fibonacci: () -> Int = { [weak self] in
        
        // Some temporary variables.
        var a = 0
        var b = 1
        
        // Add up numbers to the desired iteration.
        for _ in 0..<self.value {
            
            let temp = a
            a = b
            b = temp + b
        }
        
        return a
    } // ERROR : Value of optional type 'Fibonacci?' must be unwrapped to refer to member 'value' of wrapped base type 'Fibonacci' .
    
    
    deinit {
        
        print("\(value) is being deinitialized . Memory deallocated .")
    }
}
 */

/**
 We add two empty square brackets , and the keyword `in` .
 These square brackets define a `capture list` .
 And inside , we pair either the `weak` or `unowned` keyword
 with the reference to the class or property we are trying to capture .
 So here ,
 
 `lazy var fibonacci: () -> Int = { [weak self] in ... }`
 
 we are trying to capture `self` inside the closure .
 And we want to capture it _weakly_
 since we don't want a `reference cycle` .
 So , we can say `weak self` .
 When we do that , we get an error
 
 `// ERROR : Value of optional type 'Fibonacci?' must be unwrapped to refer to member 'value' of wrapped base type 'Fibonacci' .`
 
 because now ,
 the closure knows that `self` can be `nil` .
 And our `for loop` is going to fail
 
 `for _ in 0..<self.value {`
 
    `let temp = a`
    `a = b`
    `b = temp + b`
 `}`
 
 because we may not be able to create this range .
 To bypass this
 — just for the sake of example —
 right over here ,
 */

/*
class Fibonacci {
    
    var value: Int
    
    
    init(value: Int) {
        
        self.value = value
    }
    
    
    
    lazy var fibonacci: () -> Int = { [weak self] in
        
        // Some temporary variables.
        var a = 0
        var b = 1
        
        
        guard
            let _value = self?.value
            else { fatalError() }
        
        
        // Add up numbers to the desired iteration.
        for _ in 0..<_value {
            
            let temp = a
            a = b
            b = temp + b
        }
        
        return a
    }
    
    
    deinit {
        
        print("\(value) is being deinitialized . Memory deallocated .")
    }
}
 */

/**
 we will use a `guard statement`
 and crash in the event of `nil`
 so that we cannot create that `for loop` :
 
 `guard`
    `let _value = self?.value`
    `else { fatalError() }`
 
 When I do that ,
 now immediately in the console ,
 you should see the `deinit()` log message , ...
 */

// CONSOLE :
// 8 is being deinitialized . Memory deallocated .

/**
 ... meaning ,
 our code is now safe with a `weak` reference .
 When we assign `nil` ,
 this closure doesn't get executed .
 So , that is basically it .
 If we were capturing more than one reference ,
 we could add them to the `captured list`
 separated by commas . Just like an array .
 */
/**
 Before we conclude ,
 what is the difference between `weak` and `unowned` ?
 I just mentioned the `unowned` keyword .
 Both `weak` and `unowned` references
 enable one instance
 to refer to the other instance
 without keeping a strong hold on it ,
 thereby avoiding `reference cycles` .
 We use a `weak` reference
 — this is particularly important —
 we use a `weak` reference
 when the other instance
 that we are holding onto
 has a shorter life time . That is ,
 when the instance being captured is deallocated first .
 So think about the case of how we use delegates .
 A `delegate property` is declared `weak` ,
 and that is because we can `nil` out the delegate
 while that parent object still survives .
 So , the object being held on to
 — the weak one —
 has a shorter lifetime.
 In our example ,
 both the closure
 and the class
 have the same lifetime
 because one doesn't exist without the other .
 So , in this case , ...
 */

/*
class Fibonacci {
    
    var value: Int
    
    
    init(value: Int) {
        
        self.value = value
    }
    
    
    
    lazy var fibonacci: () -> Int = { [unowned self] in
        
        // Some temporary variables.
        var a = 0
        var b = 1
        
        
        guard
            let _value = self?.value
            else { fatalError() } // ERROR : Cannot use optional chaining on non-optional value of type 'Fibonacci' .
        
        
        // Add up numbers to the desired iteration.
        for _ in 0..<_value {
            
            let temp = a
            a = b
            b = temp + b
        }
        
        return a
    }
    
    
    deinit {
        
        print("\(value) is being deinitialized . Memory deallocated .")
    }
}
 */

/**
 ... we use an `unowned` — instead of a `weak` — reference :
 
 `lazy var fibonacci: () -> Int = { [unowned self] in ... }`
 
 The interesting thing with an `unowned` reference , is
 that the compiler knows that both the closure and the class exist at the same time ,
 and therefore `self.value` cannot be `nil` when the closure exists .
 `NOTE` that
 when we changed our capture list to
 `[unowned self]` ,
 we get another error :
 
 `// ERROR : Cannot use optional chaining on non-optional value of type 'Fibonacci' .`

 And that is
 because now
 `self` cannot be `nil` ,
 so we don't need the `guard let` statement .
 
 `// guard`
 `//    let _value = self?.value`
 `//    else { fatalError() }`
 
 We can just use `self.value` here as a non-optional property :
 
 `// for _ in 0..<_value { ... }`
 `for _ in 0..<self.value { ... }`
 */

class Fibonacci {
    
    var value: Int
    
    
    init(value: Int) {
        
        self.value = value
    }
    
    
    
    lazy var fibonacci: () -> Int = { [unowned self] () -> Int in
        
        // Some temporary variables.
        var a = 0
        var b = 1
        
        
//        guard
//            let _value = self?.value
//            else { fatalError() }
        
        
        // Add up numbers to the desired iteration.
//        for _ in 0..<_value {
        for _ in 0..<self.value {
            
            let temp = a
            a = b
            b = temp + b
        }
        
        return a
    }
    
    
    deinit {
        
        print("\(value) is being deinitialized . Memory deallocated .")
    }
}


var unowned: Fibonacci? = Fibonacci(value : 5)
unowned?.fibonacci
unowned = nil

/**
 So remember ,
 you use `weak`
 when the object being captured
 — the reference type being captured —
 is going to have a shorter lifetime
 than the object holding on to it . So here ,
 if the class `Fibonacci` was deallocated
 before the closure went away ,
 then we need the `weak` property .
 But because they have the same lifetime ,
 that is ,
 the closure
 cannot exist without the class , ...
 
 `class Fibonacci {`
 
    `var value: Int `
 
    `...`
 
    `lazy var fibonacci: () -> Int = { [unowned self] in ... }`
 `}`
 
 ... then we are going to use `unowned`
 which tells the compiler
 that `value`
 can never be `nil` while this closure exists .
 And with that ,
 let's conclude our course .
 Like with other courses on language features ,
 don't worry if you didn't get all of this .
 Closures aren't easy ,
 and that is totally okay .
 We'll get lots more practice with using them ,
 including how to define them ,
 where they are useful ,
 how to handle errors ,
 and how to avoid reference cycles
 all in the near future .
 Until then , happy coding .
 */
/**
 `QUIZ`
 (`1`) All Closures are `escaping` by default . `FALSE`
 (`2`) The `rethrows` keyword indicates to the compiler
 that the outer function is a throwing function
 only if the closure passed in
 throws an error that is propagated to the current scope .
 (`3`) If the body of the closure throws an error ,
 but the outer function isn't throwing ,
 we need to handle the error
 from inside the closure itself .
 `TRUE`
 (`4`) To throw from inside a closure ,
 which of the following
 needs to contain the `throws` keyword
 in its signature ?
 `B. The parameter that accepts the closure .`
 */
