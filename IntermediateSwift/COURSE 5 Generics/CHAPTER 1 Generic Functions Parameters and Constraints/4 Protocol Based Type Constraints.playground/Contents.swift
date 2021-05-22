import Foundation


/**
 `4 Protocol Based Type Constraints`
 INTRO — We have managed to write generic code
 but we have an issue in that we can pass any type
 as a substitute for the generic type ,
 even where it doesn't make sense .
 This makes our code less safe
 but as you will see in this video ,
 we can define constraints on generic types .
 */
/**
 In the two functions we just defined , ...
 */
func swapValues<T>(_ a: inout T ,
                   _ b: inout T) {
    
    let tempA = a
    a = b
    b = tempA
}


func transform<T , U>(_ argument: T ,
                      with operation: (T) -> U)
-> U {
    
    return operation(argument)
}
/**
 ... we could pass in any type to substitute for `T `, or for `U` — for that matter .
 It strings anything we want , and that is a point of generics , right ,
 being able to write code that you can use with a wide variety of types .
 Sometimes — well oftentimes actually — we want to write generic code
 but we don't want to necessarily make it work with every type under the sun .
 We would like to create some set of restrictions governing the types that we allow .
 This is indeed possible , but it can get complex .
 So , let’s start simple with this video .
 We know how to get a value from a key given a dictionary .
 But what if we wanted to get a key given a value ?
 Now there are ways we can do this already ,
 but let's go ahead and write a generic function :
 */
/*
func findKey<Key , Value>(for value: Value ,
                          in dictionary: Dictionary<Key , Value>)
-> Key? {
    
    for (iterKey , iterValue) in dictionary {
        if iterValue == value { // ERROR : Binary operator '==' cannot be applied to two 'Value' operands .
            return iterKey
        }
    }
    
    return nil
}
 */
/**
 Since we want the `findKey( )` method to work on any possible dictionary type ever ,
 we are making it a generic method .
 The `findKey( )` method has two generic type parameters
 and this time we have given it sensible names ,
 `<Key , Value>`
 For the argument list ,
 we accept a value to consider
 and a dictionary to search in .
 Since the argument type for the first argument is `Value` — which is pretty specific —
 I am going to make the external name , `for` , and give it a local name of `value` .
 `(for value: Value ,`
 For the second argument ,
 let's set the external name to , `in` , give a local name of `dictionary` .
 For the type , we give it a type of a Dictionary that is generic over `Key` and `Value` .
 `in dictionary: Dictionary<Key , Value>)`
 If this function finds a key for the value we provide ,
 we return that `Key` ,
 otherwise we return `nil` .
 So our return type is an optional `Key?` .
 The body of this function is quite simple .
 We iterate through the `dictionary` passed in .
 Remember that when we iterate through a dictionary
 it returns each key value pair as a compound value in the form of a tuple ,
 but by defining local constants for each of those components
 we can access them easily :
 `for (iterKey , iterValue) in dictionary { ... }`
 Inside the tuple we name the local constants `iterKey` and` iterValue` .
 I am calling these `iterKe`y and `iterValue`
 to indicate that they are keys and values we are iterating over .
 This distinguishes them to the compiler from `value`
 `func findKey<Key , Value>(for value: Value ,`
 In the body of the `for` loop , it is pretty simple ,
 if the `iterValue` is equal to the `value` that is passed in as an argument ,
 then we will `return` the key — `iterKey` :
 `for (iterKey , iterValue) in dictionary {`
    `if iterValue == value {`
        `return iterKey`
    `}`
`}`
 When you run the function in the playground ,
 the computer will throw an error :
 `if iterValue == value { // ERROR : Binary operator '==' cannot be applied to two 'Value'`
 We are using the equality operator here ,
 to compare the iterated value — `iterValue` — and the value being passed in — `value` .
 Because of the way we have defined our generic function , we know that both
 — `value` , the argument ,
 and the values in our dictionary — are of the same type .
 So why can't we compare them ?
 If they are both strings , we should be able to ,
 because strings can be compared right out of the box . Well ,
 think about if it were a custom type . So , for example ,
 let's define one a struct Item to represent an `Item` you purchase ,
 */
struct Item {
    
    let price: Int
    let quantity: Int
}
/**
 If this were a value in a Dictionary ,
 what would checking for equality mean ?
 It is undefined.
 So , going back to our generic function ,
 is this — [ OLIVIER : comparing the value of our custom type with a value of the Dictionary ] — possible ?
 `if iterValue == value { // ERROR : Binary operator '==' cannot be applied to two 'Value'`
 Do we just scrap our generic function ?
 Thankfully no , we can just place a constraint on one of the Type parameters :
 */
func findKey<Key , Value: Equatable>(for value: Value ,
                                     in dictionary: Dictionary<Key , Value>)
-> Key? {
    
    for (iterKey , iterValue) in dictionary {
        
        if iterValue == value {
            return iterKey
        }
    }
    
    return nil
}
/**
 We are adding a type constraint to the `Value` Type parameter .
 And the way we do that , is ,
 right after the type we place a colon ,
 and then we list out a constraint .
 A constraint can be a class or a protocol .
 ( A ) In the case of a `class` ,
 we are saying that the type parameter that we substitute must eventually be substituted by a class
 — that is , a subclass , or the class itself , listed as a constraint .
 We'll look at that in a second though .
 ( B ) In the case of a `protocol` ,
 we are saying that the type substituted must conform
 to the specified protocol listed as a constraint .
 So , what protocol do we specify here ?
 We learned some time ago that to make a type have a sense of equality ,
 we need to conform to the `Equatable` protocol
 and provide an implementation for the double equals operator — ==( ) .
 Well , here we can specify that any type that is substituted for the value type parameter
 has to conform to `Equatable` by implementing the protocol :
 `func findKey<Key , Value: Equatable>(for value: Value ,`
                                      `in dictionary: Dictionary<Key , Value>)`
 `-> Key? { ... }`
 When we do ,
 the error goes away
 because the compiler infers
 — even though it doesn't know about any specific types —
 it knows that whatever is substituted in as a value
 will be equatable with one another .
 This is essentially a contract
 that the compiler can now enforce
 and guarantee that our code will work .
 So , let’s test this out . Down here we'll declare a constant ,
 */
let airportCodes: [String : String] = [
    "CDG" : "Charles de Gaule" ,
    "HGK" : "Hong Kong International Airport"
]
/**
 We are assigning a Dictionary of type String to String .
 Strings conform to Equatable out of the box ,
 because they are a Standard Library type .
 So we don't have to do any additional work .
 Now we can pass in `airportCodes` as a dictionary argument to our function .
 Since the value types in the airportCodes dictionary are of type String ,
 we need to provide a valid String for the first argument :
 */
findKey(for : "Charles de Gaule" ,
        in : airportCodes)
/**
 You see in the results area that we get the key "CDG" back , so awesome .
 But we need this to work with Dictionaries of any type .
 So let's add some code in here :
 */
enum Snack {
    case gum , cookie
}


let inventory: [Snack : Item] = [
    .gum : Item(price : 1 ,
                quantity : 5) ,
    .cookie : Item(price : 2 ,
                   quantity : 3)
]


let someItem = Item(price : 2 ,
                    quantity : 3)
// findKey(for : someItem , in : inventory) // ERROR : Global function 'findKey(for:in:)' requires that 'Item' conform to 'Equatable' .
/**
 Here we have a `Snack` enum to represent different kinds of snacks .
 Using those two — the `Snack` enum and the `Item` struct —
 we have gone ahead and created a Dictionary to model an `inventory` of sorts .
 For each snack , as a key ,
 you get information about the price of the item and the quantity remaining .
 Next we have a random instance of the item — `someItem` . And given this value ,
 we want to see if it matches any in the inventory and return the key .
 Imagine some obscure use case
 where a customer walks into a grocery store and says ,
 I want to buy three items costing two dollars each , what do you have ?
 So , we decide to use our `findKey( )` method that we have defined
 and get a key to the relevant item :
 `findKey(for : someItem , in : inventory)`
 it is not going to work .
 `// ERROR : Global function 'findKey(for:in:)' requires that 'Item' conform to 'Equatable' .`
 This is because we used a type constraint to say that the value must be `Equatable` :
 `func findKey<Key , Value: Equatable>(for value: Value ,`
                                      `in dictionary: Dictionary<Key , Value>)`
 `-> Key? { ... }`
 And so far ,
 our Dictionary has values of type `Item` , ...
 `let inventory: [Snack : Item] = [`
 `.gum : Item(price : 1 ,`
             `quantity : 5) ,`
 `.cookie : Item(price : 2 ,`
                `quantity : 3)`
 `]`
 ... and `Item` isn't Equatable .
 To be able to use the `inventory` Dictionary along with our generic `findKey( )` function
 we need to make sure that only Equatable objects or values are used
 because we need to respect that contract that we wrote earlier .
 This one right here guarantee that the code works .
 So let's try that .
 Down here ,
 right after the `Item` struct ,
 we’ll create an `extension` to the `Item` struct
 and we'll make Item conform to `Equatable` .
 To conform to the `Equatable` protocol
 we need to provide an implementation for the static double equals operator :
 */
extension Item: Equatable {
    
    static func ==(lhs: Item ,
                   rhs: Item)
    -> Bool {
        
        return lhs.price == rhs.price && lhs.quantity == rhs.quantity
    }
}
/**
 And the second I hit enter
 all our errors should go away , and now we get a key back :
 */
findKey(for : someItem ,
        in : inventory) // returns cookie
/**
 So this is a first glimpse at
 how you can use protocols
 to constrain the type parameters
 defined when creating generic functions .
 
 
 
 In the next video ,
 let’s see how we can use class constraints .
 */



/* QUESTION ON TREEHOUSE :
 * Why use an extension here ?
 * In the example we used an extension
 * to add the Equatable conformance to Item .
 * What rationale should we be considering
 * when using an extension
 * versus
 * adding the conformance to the struct itself ?
 *
 * ANSWER ON TREEHOUSE :
 * It is a common convention in Swift
 * to use extensions
 * to break apart the functionality of a class / struct
 * into different sections ,
 * usually according to conformance to some protocol/s .
 * It makes things more readable .
 * Still , there is nothing preventing you from NOT doing it this way .
 */
