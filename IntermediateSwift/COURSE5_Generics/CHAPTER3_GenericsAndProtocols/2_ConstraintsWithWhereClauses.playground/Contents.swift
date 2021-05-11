import Foundation



/**
 `2 Constraints with where clauses`
 INTRO — We have learned how to constrain the generic types we define
 — both with functions and types —
 but sometimes we need to define additional or more complex constraints .
 In this video ,
 let's look at what the `where` clause brings to the table .
 */
/**
 Earlier , we defined a function with a type parameter that had a constraint on it :
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
 The constraint was specifically a protocol constraint ,
 the type we substituted had to be `Equatable` .
 But what if we have more than one constraint requirement ?
 Let's say that we are developing an e-commerce application — those are always fun .
 And we need to figure out a way to implement a cart .
 The parameters are simple for this exercise .
 We need to be able to add any type of item
 — that we have available in our store — to the cart .
 And if we add the item twice ,
 it just needs to update the quantity — typical cart behaviour .
 Since there are several types of hypothetical items ,
 let’s define a protocol that all items conform to .
 We'll keep this simple ,
 */
protocol ShoppingItem {
    
    var price: Double { get }
}
/**
 All the `ShoppingItem` needs to implement is a `price`.
 Next , we'll create a type called `Checkout` that encapsulates all the information
 about a transaction — including
 ( A ) all the items a user is purchasing ,
 ( B ) quantities ,
 ( C ) payment , and so on .
 `NOTE` : Mind you , don't take this as advice on how to actually model such a process .
 This is purely for the sake of this example .
 So , this will be a struct , named `Checkout` :
 */
/*
struct Checkout<Item> {
    
    var cart = [Item : Int]() // ERROR : Generic struct 'Dictionary' requires that 'Item' conform to 'Hashable' .
}
 */
/**
 Items themselves don't need to care about `quantity` being purchased
 because that is something unique to a transaction .
 The main part of this `Checkout` type is ,
 `var cart = [Item : Int]()`
 a Dictionary that holds
 ( A ) as keys , all the different items we are buying
 and ( B ) as values , the corresponding quantities .
 That way , if you go to update a value on the Dictionary
 — let's say , you already have an item in there
 and you want to increase the value
 — if you use that key — and it already exists —
 it will just increase the value by 1 .
 So , we are going to make this type generic ,
 `struct Checkout<Item> { ... }`
 so we can accept any item .
 And in the type , all we are going to do , is ,
 create a new variable of type Dictionary :
 `var cart = [Item : Int]()`
 When we assign a `Dictionary` of type `Item` to `Int` , we get an error
 `// ERROR : Generic struct 'Dictionary' requires that 'Item' conform to 'Hashable' .`
 because we are not providing any information about what `Item` will be .
 And this violates one of the requirements of the `Dictionary` type :
 Any value or object that we use as a key
 needs to conform to the `Hashable` protocol
 and return a hash value .
 This is essential to how a Dictionary works ;
 ( A ) maintains unique keys
 and ( B ) looks up items in an efficient manner .
 Okay , no big deal . We can introduce a type constraint to `Item` ,
 */
struct Checkout1<Item: Hashable> {
    
    var cart = Dictionary<Item , Int>()
}
/**
 Problem solved . Well , not entirely . When you `OPTION click` on `Hashable`.
 By default , Integers are hashable , and so are Strings .
 As it stands now ,
 `struct Checkout<Item: Hashable> { var cart = Dictionary<Item , Int>() }`
 I can add an Integer or a String as a key to our cart ,
 but none of these — Integer or a String — are shopping items .
 We need to introduce an additional constraint here
 and say that only Items that conform to the `ShoppingItem` protocol are acceptable as keys :
 _So how do we do this ?_
 Well , we know that we can define additional type parameters by comma separating
 inside the angle brackets . So let's try that to add another constraint ,
 and say that Item should also conform to `ShoppingItem` :
 */
/*
struct Checkout<Item: Hashable , Item: ShoppingItem> { // ERROR : Definition conflicts with previous value .
    
    var cart = Dictionary<Item , Price>() // ERROR : 'Item' is ambiguous for type lookup in this context .
}
*/
/**
 This doesn't work
 because the compiler thinks
 that we want to define two separate type parameters .
 `struct Checkout<Item: Hashable , Item: ShoppingItem> {  ... }`
 The compiler is complaining
 because the type parameters conflict .
 They are both named the same — `Item`.
 Well , fair enough , this is a valid complaint .
 Okay , how can we do this ?
 One way is to rely on a feature of protocols — multiple inheritance .
 We create a new protocol , `HashableShoppingItem` :
 */
protocol HashableShoppingItem: Hashable , ShoppingItem { }
/**
 The `HashableShoppingItem` protocol conforms to both `ShoppingItem` and `Hashable` .
 We are not providing any additional requirements to the `HashableShoppingItem` protocol .
 */
struct Checkout3<Item: HashableShoppingItem> {
    
    var cart = Dictionary<Item , Int>()
}
/**
 Using the `HashableShoppingItem` protocol ,
 we can specify a single requirement to `Item` ,
 
 `struct Checkout3<Item: HashableShoppingItem> { ... }`
 
 and now , this works . We are guaranteeing that `Item` in here
 will be both `Hashable` , and a `ShoppingItem` . This works ,
 but it necessitates creating this new empty `HashableShoppingItem` type
 purely for the purpose of creating a type constraint , which is needless . Not a good thing .
 There is another feature of protocols that we can use : `Protocol composition` .
 Using `protocol composition` ,
 you can combine multiple protocols
 into a single requirement on the fly , without creating a new type .
 You simply list as many protocols as you need to
 separating them by ampersands .
 So if I get rid of this , ...
 `// protocol HashableShoppingItem: Hashable , ShoppingItem { }`
 ... and I go back to the main definition :
`struct Checkout3<Item: HashableShoppingItem> { ... }`
 In here ,
 we can combine both protocols
 using an ampersand
 to create a single requirement :
 */
struct Checkout4<Item: ShoppingItem & Hashable> {
    
    var cart = Dictionary<Item , Int>()
}
/**
 `NOTE` that this is different from the `&&` operator — which uses double ampersands .
 `NOTE` that you can use `protocol composition` like this anywhere you need
 — like , as function arguments , for example .
 
 Now , this works
 and if we want to improve readability ,
 and have a single name at this constraint definition point ,
 we can even create a `typealias` :
 */
typealias HashableShoppingItemAlias = ShoppingItem & Hashable


struct Checkout5<Item: HashableShoppingItemAlias> {
    
    var cart = Dictionary<Item , Int>()
}
/**
 So now , `HashableShoppingItemAlias` refers to a protocol
 just created through the composition of these two — `Hashable & ShoppingItem` .
 And we can specify that here .
 We seemingly solved the problem . And really , in this case , we have .
 This is a valid way to do this , but this isn't a universal solution .
 _Why not ?_
 Okay , let's define an empty class and struct :
 */
class Shape {}

struct Animator<T> {}
/**
 The responsibility of the struct is
 to perform a series of animations on a bunch of shapes .
 Like before , we'll keep track of the animations we are adding to a `Shape`
 using a `Dictionary` .
 `Shape` is a high level class . And in this example ,
 we'll assume that we have different subclasses of `Shape`
 that the `Animator` struct can accept .
 In addition ,
 since our design necessitates
 these different `Shape` subclasses being used as keys
 — like the previous example —
 we need instances of `Shape` and its subclasses to be `Hashable` .
 So while this example may not truly make sense ,
 it highlights a typical case you might run into
 where you need to introduce a generic type parameter
 — as in this case to our `Animator` struct — and we'll call this `T` :
 `struct Animator<T> {}`
 And this type needs to constrain to both — conforming to a protocol —
 and to be of a certain class or its subclasses .
 With multiple protocol constraints ,
 we could combine the two either at the point of constraint definition
 using a new protocol or using protocol composition .
 ⚠️ But we cannot combine a `class` and `protocol` , though .
 For example , I can't create a `typealias` to combine
 both the fact that we want it to be a Shape , and we want it to be Hashable .
 So what do we do here ?
 We can specify additional requirements on type parameters
 — and even on associatedtypes —
 by including a generic `where` clause
 right before the opening curly brace of a type or function’s body .
 The generic `where` clause consists of the `where` keyword ,
 followed by a comma separated list of one or more requirements .
 Like in `type constraints` we have defined so far
 the requirements in a generic `where` clause specifies
 that a type parameter inherits from a `class` ,
 or conforms to a `protocol` , or `protocol composition` .
 So again , the restrictions are the same ,
 we are just using a different mechanism to apply them :
 */
struct Animator2<T: Shape> where T: Hashable {}
/**
 To start off ,
 we need our `Animator` struct to accept types
 that are `Shape` instances or `Shape` subclasses .
 So , the first requirement is that `T` is a subclass of `Shape` .
 And then ,
 for the next requirement — which we call `T` as well —
 has to be `Hashable` ,
 right before the ending or the opening brace , say `where`
 and we can add in the rest of our requirements .
 So here ,
 `struct Animator<T: Shape> where T: Hashable { ... }`
 I say `T` also needs to be `Hashable` .
 
 `where` clauses can seem like syntactic sugar
 for expressing constraints on type parameters as we have done here .
 For example , we can move `T` conforming to `Shape`
 over here as well , and we do it comma separated
 — just like we do inside the angle brackets — and this works :
 */
struct Animator4<T> where T: Shape , T: Hashable { }
/**
 And this is equivalent to what we had earlier .
 
 `NOTE` that there is no issue with T being listed twice over here ,
 `struct Animator<T> where T: Shape , T: Hashable { }`
 because the compiler knows
 that in a `where` clause ,
 we are referring to types already defined here .
 `struct Animator<T> where ...`
 We can't define any new types here ,
 `... where T: Shape , T: Hashable {}`
 so there aren't any conflicts .
 
 So this is how you start to build more requirements into your type constraints .
 Even when its protocols
 — typically the way to go is
 not how we have done here ,
 
 `typealias HashableShoppingItem = ShoppingItem & Hashable`
 
 `struct Checkout<Item: HashableShoppingItem> { ... }`
 
 through `protocol composition` ,
 — but to use a `where` clause instead ,
 because it lists everything out at the point of the generic definition . So here ,
 
 `struct Animator<T> where T: Shape , T: Hashable { ... }`
 
 we know that `Animator` accepts a type `T` .
 And `T` is both `Hashable` and a `Shape` subclass .
 
 
 
 
 `where` clauses can do much more though ,
 so let's take a break here .
 And in the next video ,
 let's continue our exploration of generics and protocols .
 */



// OLIVIER :

struct Animator_1<T> where T: Hashable & ShoppingItem {} // Protocol & Protocol
struct Animator_2<T> where T: Hashable & Shape {} // Protocol & Class
struct Animator_3<T> where T: Hashable , T: ShoppingItem {}
struct Animator_4<T> where T: Hashable , T: Shape {}
struct Animator_5<T: Hashable & ShoppingItem> {} // Protocol & Protocol
struct Animator_6<T: Hashable & Shape> {} // Protocol & Class



/**
 `ASIDE`:
 In Swift , we can use the `where clause`
 (`1`) along with the `for loop` .
 (`2`) in a `case label` of a `switch statement` ,
 (`3`) a `catch clause` of a `do statement` ,
 (`4`) or in the `case condition` of an `if` ,
 (`5`) `while` ,
 (`6`) `guard` ,
 (`7`) `for-in statement`,
 (`8`) or to define `type constraints` .
 
 Source : https://medium.com/@shubhamkaliyar255/how-to-use-where-clause-in-for-in-loops-e61d0860debe
 */
