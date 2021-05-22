import Foundation


/**
 `3 Extending the Int Type`
 INTRO — In this video ,
 let's add an extension to the `Int` type
 and define a function that accepts a math operation .
 */
/**
 Let's take a look at another example .
 Now keep in mind that these examples aren't particularly useful bits of code ,
 but we are going to use them to reinforce our point .
 What is the point of writing a function that accepts another function as an argument ?
 Well , it allows us to write
 a general function ,
 on a type ,
 where we customise and defer the implementation
 when we call the function .
 This concept is also known as a `higher order function` .
 So , let’s write an `extension` on the `Int` type .
 I want to define a method on `Int`
 that applies a math operation to the integer value .
 What math operation are we applying ?
 Well , I don't know right now , and that is exactly the point .
 We'll define this method in such a way
 that we can apply any math operation
 we can conceive of
 when we want ,
 as long as it involves integers .
 So , I’ll say
 */

extension Int {
    
    func applyOperation(_ operation: (Int) -> Int)
    -> Int {
        
        return operation(self)
    }
}

/**
 The `applyOperation()` function has a single parameter `operation` without an external argument label .
 The type of `operation` will be a function type ,
 because we want to be able to pass in any math operation when using the `applyOperation()` function .
 We'll define this parameter as a function that takes an integer
 — remember the parameters have to be enclosed in parentheses —
 and then it returns an integer as well ,
 
 `(Int) -> Int`
 
 okay . So ,
 `applyOperation()` takes an `operation`
 — which is a function that takes an `Int` ,
 and returns an `Int` .
 When we apply this operation to an integer value ,
 we are going to get an `Int` back , as we can see from the return type .
 And we want to return this `Int` as well ,
 so the final return type for the entire function will be an `Int` .
 Inside the body of the `applyOperation()` function ,
 we are simply going to call the function — `operation` — that we provide as an argument .
 Now `operation`
 — which is a constant holding on to that function —
 expects an integer value as an argument .
 And since we are doing this as an `extension` on `Int` itself ,
 we are going to pass in `self` as the argument .
 Now the result of calling `operation` on `self` is an integer as well ,
 so we can return it .
 So pretty simple ,
 we have defined a function that applies some math operation on an integer ,
 where we haven't actually defined any particular math operation .
 Since we can now provide a function that matches the signature as an argument ,
 we have deferred defining the actual `operation` until we call this function .
 What the `applyOperation()` function does , is ,
 ensure that the function we provide as an argument is called ,
 and a value is returned .
 We can see this in action by defining a simple math operation
 that doubles an integer value , so , let’s say
 */

func double(_ value: Int)
-> Int {
    
    return value * 2
}

/**
 `NOTICE` that this signature `Int` to `Int` of the` double()` function
 matches the parameter type of the `applyOperation() `function ,
 
 `func applyOperation(_ operation: (Int) -> Int) -> Int { ... }`
 
 `double()` is a function that takes an integer , and returns an integer .
 We can now use this with the `applyOperation()` function :
 */

5.applyOperation(double)

/**
 Remember this is an extension on the `Int` type ,
 
 `extension Int {`
 
 `func applyOperation(_ operation: (Int) -> Int)`
 `-> Int {`
 
        `return operation(self)`
    `}`
 `}`
 
 so we first write out an integer ,
 
 `5`
 
 and then we call `applyOperation`
 and we can pass in `double` as the argument ,
 
 `5.applyOperation(double) // returns 10`
 
 and notice in the results area we get `10` .
 The `double()` function is really simple , of course ,
 and we don't even need a method for this ,
 but it highlights how we can pass in a function to apply , and get a result .
 The beauty though of this `applyOperation()` function , is ,
 that it can take any function or any `operation` that matches the signature .
 Allowing us to define the operation we implement when we call the function .
 So for example , we can define a new function :
 */

func closestMultipleOfSix(_ value: Int)
-> Int {
    
    for x in 0...100 {
        
        let multiple = x * 6
        
        if multiple - value < 6 && multiple > value {
            
            return multiple
            
        } else if multiple == value {
            
            return value
        }
    }
    
    return 0
}

/**
 This function takes an integer , and returns an integer .
 In the body of the function we just do a bit of math .
 `NOTE` : We just do a bit of math here , what I am doing isn't really important .
 All that matters , is , that it is a different kind of operation . You can just copy this as it is .
 
 Okay , now that we have this new `operation`
 we can use it with the `applyOperation()` function ,
 I can say `32` , and find the `closestMultipleOfSix` , which is `36` :
 */

32.applyOperation(closestMultipleOfSix) // returns 36
12.applyOperation(closestMultipleOfSix) // returns 12
200.applyOperation(closestMultipleOfSix) // returns 204

/**
 Look at that ,
 now you know that you can use functions
 as arguments
 to other functions ,
 — and more importantly —
 this should give you an example
 of why you would want to do that in the first place .
 */
