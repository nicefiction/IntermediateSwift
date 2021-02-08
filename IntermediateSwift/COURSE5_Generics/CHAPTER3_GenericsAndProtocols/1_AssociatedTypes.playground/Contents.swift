import Foundation

/**
 `CHAPTER 3`
 `Generics and Protocols`
 In addition to defining generic functions and types
 we can also define generic protocols
 through the use of associated types .
 There are several applications of associated types
 but they can get complicated
 so over the next few videos ,
 let's walk through each one .
 */



/**
 `1 Associated Types`
 INTRO — Much like we can define generic types and functions ,
 we can also create generic requirements in our protocols .
 This isn't as straightforward as it seems however
 and in this video
 lets take our first look at what an associated type is
 and how we implement it .
 */
/**
 In Swift , there are several different ways to represent information and logic ;
 functions , types , and interfaces — or protocols .
 We have seen so far that functions and types can be made generic .
 So what about protocols ?
 You might think of a protocol as already something generic ,
 in that any type can conform to a protocol .
 But what about the internals of a protocol ?
 Can we define a protocol where the requirements themselves are generic ?
 We can , but not in the same way as we have seen so far .
 With protocols , we have a different concept called associatedtype .
    So , open a new playground page
 and we are going to model a new data structure in this video .
 Except , we are not going to provide a full implementation like we just did .
 We'll start by defining an interface through a protocol :
 */
protocol Stack0 {}
/**
 We call this protocol , `Stack` .
 A Stack is essentially an Array with limited functionality .
 You can `push` a new element to the top of a stack ,
 `pop` to remove the element from the top
 and `peek` at the top element without popping it .
 The main point of this Stack is the order .
 A Stack operates on last in , first out order .
 The element you most recently pushed is the one you get back when popped .
 Let's defined this interface .
 So in here ,
 */
protocol Stack {
    
    associatedtype Element
    
    mutating func push(_ element: Element)
    mutating func pop() -> Element?
    
    var top: Element? { get }
}
/**
 first step is the `push( )` function .
 Assuming we set up the Stack using a struct — like an Array —
 then push( ) will be a `mutating` method . And we need to indicate that to the compiler :
 `mutating func push(_ element: Element)`
 The method takes a single argument — an element to push onto the stack .
 `NOTE` : Here is the tricky part .
 What type do we give this method ?
 Remember , we want this method to have a generic requirement .
 Any concrete type of `Stack` that we need to create needs to be able
 ( 1 ) to conform to this protocol
 and ( 2 ) work despite it containing Strings , or Integers , or whatever .
 The end goal is that each `Stack` class or struct that we create
 has to contain one type only .
 What we need here , is , an associated type :
 `associatedtype Element`
 Right above the `push( )` function ,
 we write out the keyword `associatedtype`
 followed by a name we want to give this `associatedtye` .
 This name is just like how we name our type parameters in a generic function .
 Back in the function , we can specify the type
 as a type of our argument — `element` .
 Just like `type parameters` ,
 `associated types` give a placeholder name to a type that is used
 as part of the protocol .
 The actual type to use for that associated type is not specified
 until we actually adopt the protocol .
 Okay , so let's add two other requirements :
 `mutating func pop() -> Element?`
 `pop( )` returns the last element we pushed onto the stack
 — which also mutates the stack .
 Finally , we have `peak` — which lets us look at the very last element without popping it —
 and we call this `top` — [ OLIVIER : a computed property ] .
 
 Let's see how we can go from an associated type to a more concrete usage .
 There are two ways we can do this .
 `( 1 )` The first way to satisfy the associated type requirement , is ,
 to be explicit and state it in code . We do this by using the `typealias` keyword
 and indicating that Element — which is the associated type in our protocol —
 is a typealias for a concrete type inside this object :
 */
struct IntStack: Stack {
    
    typealias Element = Int
    
    private var intArray = Array<Element>()
    
    
    mutating func push(_ element: Element) {
        
        intArray.append(element)
    }
    
    
    mutating func pop()
    -> Element? {
        
        if
            let _element = intArray.popLast() {
            return _element
        }
        
        return nil
    }
    
    
    var top: Element? {
        
        return intArray.last
    }
}
/**
 `Element` is always going to be an Integer inside this Struct .
 All the methods `push( )` and `pop( )` take Integers
 instead of our generic requirement — `Element` .
 Let's provide a really quick implementation .
 We use an underlying Array for storage , and make it `private` :
 `private var intArray = Array<Int>()`
 This is an `Array` that is generic over `Int` .
 For the methods , we'll just use this Array .
 `push( )` appends the element to that Array that we just created .
 `pop( )` removes and returns the last element from the Array .
 And finally , `top` just reads the last element in the Array .
 Okay ,
 now I said there were two ways of doing this ,
 and the second way is to simply
 `( 2 )` let the compiler infer the type for the `associatedtype` requirement .
 By specifying the argument type , or the return type for all the methods as Integer ,
 the compiler can infer that we have substituted `Int` for the `associatedtype`
 because those say `Element` over here :
 `protocol Stack {`
 
 `associatedtype: Element`
 
 `mutating func push(_ element: Element)`
 `mutating func pop() -> Element?`
 
 `var top: Element? { get }`
 `}`
 So , we can just get rid of this typealias declaration :
 */
struct IntStack2: Stack {
    
    // typealias Element = Int
    
    // private var intArray = Array<Element>()
    private var intArray = Array<Int>()
    
    
    // mutating func push(_ element: Element) {
    mutating func push(_ element: Int) {
        
        intArray.append(element)
    }
    
    
    mutating func pop()
    // -> Element? {
    -> Int? {
        
        if
            let _element = intArray.popLast() {
            return _element
        }
        
        return nil
    }
    
    
    // var top: Element? {
    var top: Int? {
        
        return intArray.last
    }
}
/**
 ... and everything should still work .
 So , this is how you give the protocol generic requirements .
 This seems pretty simple
 but we can actually do quite a bit with this .
 Before we go down that road though ,
 let's learn a bit more about type constraints .
 */
