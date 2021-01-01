import Foundation


/**
 `2 Writing Generic Functions`
 INTRO — Now that we are aware of the problem ,
 let's attempt to solve it using a Swift feature
 that we haven't encountered before - Generics !
 */
/**
 Let's write a new function .
 The standard library already has a `swap( )` function ,
 so we will call ours `swapValues( )` :
 */
func swapValues<T>(_ a: inout T ,
                   _ b: inout T) {
    
    let tempValue = a
    a = b
    b = tempValue
}
/**
 Unlike anything we have done before ,
 right after the name of the function ,
 we are adding , between a set of angle brackets , the letter `T` .
 There shouldn't be any spaces between the name of the function and the angle bracket .
 `NOTE` : We have always said that when writing functions
 immediately after the function name ,
 we put our argument list ,
 but here is the first time we are doing something different .
 
 Next — after the angle brackets — we add the argument list , like we usually do .
 Since this is a swap function that swaps two values , again ,
 we take two arguments , and we omit the external names , and follow the same convention as we have been doing .
 So the first argument name — or local name — is `a` ,
 and we still want it to be an `inout` argument
 — or we want to pass by reference —
 so we add the `inout` keyword .
 The type of a is the letter `T` . Make sure it is an uppercase `T` ,
 just like we have defined over here :
 `func swapValues<T>(_ a: inout T , _ b: inout T) { ... }`
 This is a generic function .
 A generic function uses a _placeholder type name_
 in place of an actual type name — which we have named `T `in this case .
 `NOTE` that `T` doesn't mean anything special , it is just a name .
 I can name this `U` , `V` , `X` , or even full words like `Value` , `Argument` , and so on .
 `T `isn't a specific type ,
 and this function doesn't say what `T` must be .
 
 I haven't specified whether it is a String or an Int ,
 but what the function does say , is ,
 that both `a` and `b` must be of the same type `T` ,
 whatever `T` comes to represent .
 So what does that mean , whatever `T` comes to represent ?
 You'll see in just a second .
 Let's use our generic `swapValues( )` function :
 */
var d = 12
var e = 10

swapValues(&d , &e)

d
e
/**
 You see from the results area of the playground that this works perfectly ,
 and our values are being swapped .
 Okay , so we know that works .
 Let's call swapValues again ,
 and now , we pass in g and h :
 */
var g = "Gale"
var h = "Dorothy"

swapValues(&g , &h)

g
h
/**
 Again , this works too .
 What sorcery is this ?
 In a generic function ,
 the placeholder type
 — T — in this case ,
 is replaced
 with an actual type
 when you call the function ,
 this is important to remember .
 When we called swapValues( ) the first time ,
 and passed in d and e ,
 everywhere in the function where we used T
 — which is in the argument list in this case —
 `func swapValues<T>(_ a: inout T , _ b: inout T) { ... }`
 `T` gets replaced with `Int` ,
 since `Int` is the argument type being passed in .
 The second time , we call it — since we pass in Strings —
 `T` is replaced with a type `String` .
 If you tried to call `swapValues( )` ,
 and we'll try to pass in `d` and then `g` ,
 this will fail :
 */
// swapValues(&d , &g) // ERROR : Cannot convert value of type 'String' to expected argument type 'Int' .
/**
 If you read the error , it says
 _Cannot convert value of type 'String' to expected argument type 'Int'  ._
 This is because we said
 when defining the function
 — even though we don't know what `T` is —
 both `a` and `b` have to be the same type
 because they are both specified as `T` .
 When we pass in an `Int` and a `String` — as we are doing here —
 since the first argument is an `Int`  , `T` — the placeholder — now represents the `Int` type .
 This makes the argument type for the second argument `Int` as well .
 A `String` is not an `Integer` , so we get an error .
 
 At the point of definition , the angle bracket `T` , here ...
 `func swapValues<T>(_ a: inout T , _ b: inout T) { ... }`
 ... tells the compiler that this is a generic function
 and that `T` defines a placeholder type that will be specified when the function is called .
 `T` is more specifically called a `type parameter` . This way ,
 when we specify the types of the arguments as `T` ,
 when we are defining the function ,
 the compiler knows to not go looking for an actual type called `T` .
 Type parameters can be used as
 1. the type for function’s arguments — as we have done .
 2. It can also be used as
 the function's return type ,
 or 3. to represent a type within the body of the function .
 Whatever the case , when the function is actually called
 the type parameters — and there can be more than one —
 will be replaced with an actual type .
 
 Now that we have a generic function ,
 we can get rid of our two specific implementations ,
 */
/*
func swapInts(_ a: inout Int ,
              _ b: inout Int) {
    
    let tempA = a
    a = b
    b = tempA
}


func swapStrings(_ a: inout String ,
                 _ b: inout String) {
    
    let tempA = a
    a = b
    b = tempA
}
*/
/**
 `swapValues( )` works on both of these types ,
 and even any type we have yet to define .
 */
