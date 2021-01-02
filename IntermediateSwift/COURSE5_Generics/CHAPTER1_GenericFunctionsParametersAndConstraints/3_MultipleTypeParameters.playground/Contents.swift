import Foundation


/**
 `3 Multiple Type Parameters`
 INTRO — Generic functions allow us
 to define a placeholder type
 that is substituted
 when we use the code .
 Even cooler ,
 we can define multiple generic type parameters .
 In this video ,
 let's define a function
 that allows for several generic arguments .
 */
/**
 Let's take a look at another example of a generic function .
 This one is going to be a tiny bit more complicated
 but before we move on to the next topic ,
 I want to quickly highlight the point I raised earlier
 in that we can make our function generic
 over more than one type .
 Let's define a function .
 This function is going to have two generic type parameters :
 */
func transform< T , U >( _ argument: T ,
                         with operation: (T) -> U)
-> U {
    
    return operation(argument)
}
/**
 Remember , we start with an angle bracket .
 To list more than one generic type , we add a comma .
 So , it is a comma separated list of arguments :
 so `T` , and then the second one we call `U` ,
 Again , to specify multiple type parameters
 we separate them with commas inside of the angle brackets .
 `NOTE` : We will talk about how we name our type parameters in just a second ,
 but in cases like this
 — again , where there are no meaningful names beyond _argument_ or _value_ —
 the convention is to use uppercase letters ,
 and typically , we start at `T` for type , and then go on from there .
 This function takes two arguments :
 `func transform< T , U >( _ argument: T , with operation: (T) -> U) -> U { ... }`
 For the second argument ,
 this is going to be a bit more tricky .
 It is going to take another function as a parameter .
 We call this function — or we call this parameter `operation` — .
 and for the type we accept a function that takes as an input
 a parameter of type `T` ,
 and returns a parameter of type `U` .
 So how do we define that ?
 It is pretty simple ,
 the type of that function looks like this :
 `(T) -> U`
 Remember ,
 when we are writing a function ,
 we include the arguments that a function accepts inside of parentheses .
 This `operation` function is going to accept a parameter of type `T` .
 Inside parentheses , we put `T` ,
 and then it is going to return an instance — or a value — of type `U` .
 Remember that both `T` and `U` are type parameters — or placeholders .
 Right now they don't mean anything . Our function here ...
 `func transform< T , U >( _ argument: T , with operation: (T) -> U) -> U { ... }`
 ... simply states that it takes a parameter of type `T`
 and then a second parameter — which is a function in its own right — that takes `T` and returns `U` .
 And then this entire `transform( )` function is going to return `U` as well .
 This sounds terribly over complicated ,
 but all we are going to do , is , call this `operation` function .
 Now as you can see here ,
 `operation` takes an argument of type `T`
 and this parameter — `argument` — happens to be of type `T `.
 So , we’ll call this function , and pass through `argument` :
 `func transform< T , U >( _ argument: T ,`
                          `with operation: (T) -> U)`
 `-> U {`
 
    `return operation(argument)`
 `}`
 Calling the `operation` function returns a value of type `U`
 and since that is also what we need to return from the `transform( )` function ,
 we simply return `U` by calling and returning the `operation` function .
 And that is it .
 At this point , we have no idea what `T` or `U` are .
 They are not defined
 but that is okay
 because we are just defining some rules about this function .
 Generic functions are more about defining rules
 rather than a specific implementation . So ,
 we have a function that we pass in to the `operation` argument .
 `func transform< T , U >( _ argument: T ,`
                          `with operation: (T) -> U)`
 `-> U { ... }`
 This function takes as its own parameter
 something of type `T` .
 Our generic function says that this parameter ,
 `_ argument: T ,``
 and both — so this parameter right here — in both the parameter value ,
 `with operation: (T) -> U`
 the `argument` value must be of type `T` . So ,
 before we call `transform( )` , and do anything with it ,
 let's define another function :
 */
func stringToInt(stringValue: String)
-> Int {
    
    guard
        let _stringValue = Int(stringValue)
    else { fatalError() }
    
    return _stringValue
}
/**
 The `stringToInt( )` function takes as a parameter
 an instance of a String — so , a value of type String — and then returns an Int .
 The body of this function converts the String to an Integer ,
 and returns it .
 If it doesn't work — for the sake of this example — we’ll just crash the program .
 This is the initialiser for the Int type , and it takes a value of type Any .
 `Int(stringValue)`
 If it can convert it to an Int , it returns an optional integer . So here ,
 we are trying to unwrap and assign it a value
 and if it doesn't return nil ,
 in that case ,
 we are just going to crash .
 Now , we have a value , so we'll `return _stringValue` .
 We can now use the `stringToInt( `) function
 in the `transform( )` function we defined earlier ,
 `func transform< T , U >( _ argument: T ,`
                          `with operation: (T) -> U)`
 `-> U { ... }`
 Remember that the second parameter — `operation` —
 takes a function as an argument of type `T` to `U` .
 If we pass in `stringToInt( )` as an argument to `operation`
 that makes `T` , `String`
 and `U` , `Int` .
 Since `T` has to be consistent , that means
 we then need to pass in the value of a `String` for the parameter  , `argument` .
 Okay , let's give that a try :
 */
transform("3" ,
          with : stringToInt)
/**
 We call `transform` , and for `argument` ,
 we need to pass in a `String` , so we pass in the string `"3"` , not the number .
 And then for the `operation` , we pass in the `stringToInt( )` function .
 `NOTE` : You might not have seen this earlier ,
 but here ,
 `with : stringToInt`
 we are just passing the function .
 We are NOT  actually calling it .
 Immediately in the results area ,
 you see that we get the value _3_ back .
 Since `T` to `U` is now
 `String` to `Int`
 and our `transform( )` function returns `U` ,
 
 `func transform< T , U >( _ argument: T ,`
                          `with operation: (T) -> U)`
 `-> U {`
 
    `return operation(argument)`
 `}`
 
 This means it now returns an Int value . So here ,
 `transform("3" ,`
           `with : stringToInt)`
 we accepted as an argument a `String` value ,
 and then our `transform`
 `operation` took a function that transformed it
 and returned the result .
 But this is a generic function , right ?
 Which means that we should be able to use it with a different set of types ,
 indeed , we can .
 So ,
 if we write another function that transforms an Int to String
 — so , in the opposite direction — and then returns a String :
 */
func intToString(intValue: Int)
-> String {
    
    return String(intValue)
}
/**
 `NOTE` here that we don't have to write the `guard let` statement to unwrap the value ,
 and that is because you can always convert any Integer to a String .
 
 Just like before ,
 we can call the `transform( )` function ,
 */
transform(5 ,
          with: intToString)
/**
 and again ,
 we are just passing the function in ,
 we are not calling it .
 When we pass it in this time ,
 `intToString` accepts a value of `Int`
 and returns a `String` value , `"5"` . So , `T` here
 `with operation: (T) -> U`
 is now `Int `, and `U` is `String` ,
 which means that `argument`
 `_ argument: T ,`
 needs to be of type `Int`
 and we are going to get a `String` out of our function .
 So , if I pass in `5`
 `transform(5 , with: intToString)`
 you see that we get the String `"5"` back .
 
 `NOTE` : If I do , ...
 */
// transform("2" , with: intToString) // ERROR : Cannot convert value of type 'String' to expected argument type 'Int' .
/**
 ... it is going to fail
 because now our types don't match up .
 
 
 
 So a bit complicated to maybe wrap your head around this function ,
 but it shows you the power of generics .
 Let's take a break here .
 In the next few videos
 let's examine what else we can do with generic functions .
 */
