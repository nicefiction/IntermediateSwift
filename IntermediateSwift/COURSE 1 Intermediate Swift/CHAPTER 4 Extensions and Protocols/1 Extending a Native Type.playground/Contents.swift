import Foundation


/**
 `CHAPTER 4`
 `Extensions and Protocols`
 In many languages
 you can add functionality to a type
 outside of the type's declaration .
 In Swift this feature is known as an `extension`
 and in the next set of videos
 we are going to learn
 how to extend a type
 to add
 new computed properties ,
 methods ,
 and protocol conformance .
 We'll even take a look at
 how extending protocols
 can lead to some tricky behaviour .
 */
/**
 `1 Extending a Native Type`
 INTRO — Extensions not only allow you to add functionality
 to your own types
 but Swift's native types as well .
 In this video , let's extend `Int` to add some additional functionality .
 */
/**
 Up until now , we have spent our time
 diving deeper on topics you are already familiar with .
 Let's take a break from that and learn something totally new .
 Beware that this is going to blow your mind , some really cool stuff coming up .
 We have learned how to create custom types , right ?
 Structs , Classes , Enums , and so on .
 We have also learned about the built in types in Swift ; `Int` , `String` , etc.
 And if you have taken iOS content ,
 you have learned about the classes provided in the iOS SDK ;
 `UIViewController` , `UIView` , and many more .
 With the custom types we created , we could add whatever functionality we want .
 But what if we wanted to add some minor functionality on top of an existing class ?
 Let's say `UIView` — and I mean `UIView` itself , not just a subclass that we create .
 Tough luck , right ? Actually , not at all .
 In Swift , we can use an `extension`
 to add functionality
 to an existing class , structure , enumeration , or even a protocol type .
 If you are familiar with objective C , this probably sounds a lot like a category .
 Not only can we extend _our_ types , but we can also extend _the types_
 for which we don't have the source code ,
 like a class in the iOS SDK , or in native Swift type .
 Let's look at a simple and silly example .
 I am pretty bad at determining whether a number is odd or even .
 So I want to make it very clear .
 I could write a function that returns `true` if odd , `false` if even , but that is just cumbersome .
 I have to pass in an argument to the function . Instead ,
 I'd like to call something on the number itself .
 Maybe it is not a function , maybe it is a computed property .
 And this means that I need to add the functionality to the `Int` type .
 So how do I do that ?
 */

extension Int {
    
    var isOdd: Bool {
        
//        if self % 2 == 0 {
//            return true
//        } else {
//            return false
//        }
        
        self % 2 == 0 ? true : false
    }
}

/**
 We start with the keyword `extension` ,
 followed by the type name that we want to extend , which in this case , is , `Int` .
 We open the body of the extension , and inside the extension ,
 you can add whatever you want to do to extend it . So , I am going to add
 a computed property that returns a Boolean `true` value if it is odd , and `false` if not .
 Note that to refer to the instance of the type — which is the number here —
 we use `self` . Let's give this a try :
 */

3.isOdd
8.isOdd

/**
 And just like that , we have added our own functionality to a native type .
 
 Extensions are pretty amazing .
 But you can't add anything you want .
 There are a few rules , and let's look at the simple ones first :

 (`1`) You can add `computed properties` to an existing type using an extension ,
 and we have seen how you can do that .
 
 (`2`) You cannot , however , add stored properties ,
 nor can you add property observers to existing stored properties .
 This is important because adding stored properties would mean
 that all of a type's existing initialisers would have to be reimplemented .
 Since classes from the iOS's SDK , for example , are closed source and proprietary ,
 we can't re-implement those , so we can't mess around by adding stored properties .
 
 (`3`) You can add new `instance methods` and `type methods` to a type .
 And you do this in just the way that you would add them in a regular type .
 
 (`4`) You can also define `nested types` . So you can add a new struct
 inside of an existing class or struct . And we'll look at why this is useful in the future .
 
 (`5`) You can also add your own `convenience initialisers` .
 `Note` that you can't add a designated initialiser
 for the same reason you can't add stored properties .
 It would involve messing around with the internals of a class a bit too much .
 
 (`6`) The last case , adding `protocol conformance` to a class through extensions
 is an interesting enough topic , but we are going to tackle that next in its own video .
 */
