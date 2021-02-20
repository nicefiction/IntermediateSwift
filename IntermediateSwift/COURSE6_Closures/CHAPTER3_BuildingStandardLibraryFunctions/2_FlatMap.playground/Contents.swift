import Foundation


/**
 `2 Flat Map`
 INTRO — Where `map()` applied
 a transformation function
 to elements
 in an array ,
 `flatMap()` let's us do the same thing
 on a nested array .
 In this video ,
 let's build `flatMap()` from scratch .
 */
/**
 Let's say we are trying to build a blog in swift ,
 really simple one .
 All blogs have posts and our `BlogPost` struct looks like this :
 */
struct BlogPost {
    
    var content: String
    var tags: [String]
}

/**
 Using our `BlogPost` model ,
 we can build a teeny tiny blog .
 We make this an array of posts :
 */

let blogPosts = [
    
    BlogPost(content : "Hello, world!" ,
         tags : ["first", "programming"]) ,
    BlogPost(content : "Just another short post" ,
         tags : ["general"])
]

/**
 If we wanted to hypothetically `map()` over all of the content in the blogPosts
 and transform the strings ,
 we can easily do something like this .
 Since `blogPosts` is an array , we can say
 */

let contentStrings = blogPosts.map { String($0.content) }

print("Content strings : \(contentStrings)")

/**
 `NOTE` that I am not actually doing anything here ,
 I am not transforming anything .
 And `NOTE` that I am back to using the built-in `map()` here ,
 not the custom one we wrote .
 
 Okay ,
 so we can `map()` over it ,
 that is the entire point .
 Now ,
 let’s say we want to add a feature to our blog .
 A tags page where a reader can click any tag and see all the blogPosts .
 We also want to transform the strings inside the tags property into uppercase words .
 So , we can `map()` over it
 and try to transform the strings :
 */

let blogTags = blogPosts.map { $0.tags }

print(blogTags) // Prints [["first", "programming"], ["general"]]

/**
 Here , I am not making the strings uppercase
 but just mapping over the `blogTags`
 to get all the blog posts for all the tags
 rather for all the blog posts .
 You'll notice — before we do anything else —
 that the `blogTags` constant doesn't actually contain an array of tags
 — which is what we expected to be —
 but an array of an array of tags :
 — OPTION click on `blogTags` —
 
 `let blogTags: [[String]]`
 
 This is not what we want to display on our tags page .
 We simply want to list all the tags .
 The problem here is
 that the `blogTags` property is an array itself .
 
 `let blogTags: [[String]]`
 
 When we `map()` over the `blogPosts`,
 and do some work on the `tags` property ,
 we are mapping over an array of arrays ,
 so the return type is an array of arrays .
 Instead of `map()` ,
 Swift has another handy function built in ,
 called `flatMap()` .
 Like `map()` ,
 `flatMap()` iterates over an array
 and applies a transformation function to the individual elements .
 But this time
 it flattens the resulting array , meaning ,
 it takes an array of arrays
 and makes it a single array .
 Hence , the name `flatMap() `.
 So if we change the function name here to `flatMap( )` ,
 */

let flattenedTagArray = blogPosts.flatMap { $0.tags }

print("flattenedTagArray = \(flattenedTagArray)")

// OLIVIER :
let tagsUppercased = flattenedTagArray.map { $0.uppercased() }

print("tagsUppercased = \(tagsUppercased)")

/**
 when you OPTION click on `flattenedTagArray`
 
 `let flattenedTagArray: [String]`
 
 You see that it is a single flattened array ,
 _how easy is that ?_
 
 Let's see how this — `$0.tags` — is implemented ,
 because , again ,
 it takes a closure .
 Like `map()` ,
 we are going to start for a custom implementation
 with an `extension` on the `Array` type .
 `flatMap()` is a generic function as well ,
 allowing us to pass in
 any closure expression
 as a transformation function ,
 where the signature matches . So ,
 like we did for `map()`,
 we will name ours `customFlatMap()` :
 */

extension Array {
    
    func customFlatMap<T>(_ transform: (Element) -> [T])
    -> [T] {
        
        var flattenedArray = Array<T>()
        
        
        for element in self {
            
            flattenedArray.append(contentsOf : transform(element))
        }
        
        return flattenedArray
    }
}

/**
 Now remember , this is generic ,
 so we give it a generic type parameter `T` .
 The first difference is
 where in `customMap()`
 we had a `transform` function
 that went from `Element to T` ,

 `func customMap<T>(_ transform: (Element) -> T ) -> [T] { ... }`
 
 Here ,
 we have a `transform` function
 that goes from `Element to an array of T` .
 And again — like we did with `map()` —
 the return type
 — since we want a single flattened array —
 will be an array of `T`— `[T]` .
 Now , let’s make sure our `customFlatMap()` signature

 `func customFlatMap<T>(_ transform: (Element) -> [T])`
 `-> [T] { ... }`
 
 matches that of `flatMap()` ,
 — OLIVIER : OPTION click on `flatmap()` — , ...
 */

/*
 func flatMap<SegmentOfResult>(_ transform: (Post) throws -> SegmentOfResult) rethrows -> [SegmentOfResult.Element] where SegmentOfResult : Sequence
 */

/**
 ... okay , basically the same . So ,
 inside the body of the function ,
 we are going to create an empty `flattenedArray` array
 — just like before — so ,
 
 `var flattenedArray = Array<T>()`
 
 Here we initialise the `Array` of type `T` .
 And next ,
 we iterate over the elements in `self` .
 
 `for element in self {`
 
    `flattenedArray.append(contentsOf : transform(element))`
 `}`
 
 Now this time , instead of appending the result of transforming `element` ,
 we are going to `append` the result of transforming all the contents of `element` .
 Remember , `Element` , here ,
 
 `transform: (Element) -> [T]`
 
 is an array itself ,
 we are iterating over an array of arrays .
 So , `element` — in this `for loop` — is an array .
 
 `NOTE` :
 We could do this by writing a `nested for loop`
 to iterate over this inner array , so I can say : `for y in x` .
 But Swift has a useful function , `append contentsOf` .
 We simply use the `append(contentsOf:)` function here  , ...
 
 `flattenedArray.append(contentsOf : transform(element))`
 
 ... and append the result of applying the `transform()` function on `element` .
 An array is appended to the `flattenedArray` ,
 which is why — when we use the `map()` function — we get an array of arrays .
 By using the `append(contentsOf:)` function ,
 Swift takes the individual elements from the resulting array
 and appends it to the `flattenedArray` ,
 which gives us that single flattened array
 rather than a series of nested arrays .
 So what we do , is ,
 _append the contents of_ applying the transformation function on `element`
 to the `flattenedArray` array :
 
 `func customFlatMap<T>(_ transform: (Element) -> [T])`
 `-> [T] {`
 
    `var flattenedArray = Array<T>()`
 
 
    `for element in self {`
 
        `flattenedArray.append(contentsOf : transform(element))`
    `}`
 
 
    `return flattenedArray`
 `}`
 
 And that is it .
 We are going to return the `flattenedArray` array ,
 very simple
 but really useful .
    Let's say you downloaded some data from the network ,
 and the data comes in as a series of arrays .
 You can quickly flatten the resulting data into a single array to work with ,
 by using `flatMap()` function
 rather than multiple nested loops .
 In the midst of the flattening process,
 you can even apply a transformation to the contents .
 We'll be doing stuff like that
 where we use `flatMap()`
 to both flatten an array
 and transform the contents in the future .
 One thing you should be aware of though
 — that you may have already noticed — is ,
 the signatures of functions we wrote for `flatMap()`and `map()` ,
 and the rest of the functions we are going to write ,
 aren’t the actual signatures of the Standard Library versions .
 For example , our `customMap()` looked like this ,
 
 `func customFlatMap<T>(_ transform: (Element) -> [T])`
 `-> [T] { ... }`
 
 The real `flatMap()` function of the Standard Library looks like this ,

 `func flatMap<SegmentOfResult>(_ transform: (Post) throws -> SegmentOfResult) rethrows -> [SegmentOfResult.Element] where SegmentOfResult : Sequence`
 
 
 `NOTE` : As you can see , it is a bit different here .
 The function signature is a throwing one , meaning
 that we can use a transformation function that also throws an error .
 Also , there is this bit about `rethrows` , which we'll cover in the near future .
 There are also specialisations on this generalised function type
 that make it work better — with certain types for the Standard Library version that is .
 
 For example ,
 one really useful aspect of `flatMap()` , is ,
 that it can map over an array of optional types and return non-optionals only .
 Here we have an example of a user account :
 */

struct Account {
    
    let username: String
    let billingAddress: String?
}
 
/**
 The account just contains a `username` and an optional `billingAddress` .
 Then we have an array of `allUsers` . Some of who have an address , some who don’t :
 */

let allUsers = [
    
    Account(username : "pasanpr" ,
            billingAddress : nil) ,
    Account(username : "benjakuben" ,
            billingAddress : "1234 Imaginary Street") ,
    Account(username : "instantNadel" ,
            billingAddress : "5678 Doesn't Live Here Dr.") ,
    Account(username : "sketchings" ,
            billingAddress : nil) ,
    Account(username : "paradoxed" ,
            billingAddress : "1122 Nope Lane")
]

/**
 Let's say
 my company is undergoing some billing changes ,
 so I'd like to send a letter to my customers informing them .
 Now , one way to do this , is ,
 use a `for loop` ,
 iterate over every account ,
 figure out which one has addresses associated with it ,
 and then get those emails out .
 We could then go through the resulting array
 remove the optionals ,
 do whatever we need .
 With `flatMap()` ,
 all that is handled for you .
 You simply say that you want to `flatMap()` over the `allUsers` array
 and you want the billing addresses :
 */

let validBillingAddresses = allUsers.compactMap { $0.billingAddress }

/* WARNING Apple :
 * flatMap' is deprecated :
 * Please use compactMap(_:)
 * for the case where closure returns an optional value
 */

print("Valid billing addresses : \(validBillingAddresses)")

/**
 We pass in a closure .
 
 `{ $0.billingAddress }`
 
 Now the transformation function here
 interprets this as we want only the non know values .
 And this is specialised version of `flatMap()` — OLIVIER : `compactMap` ,
 written for optionals ,
 and as you can see
 — even though the billing addresses here are `nil` , ...
 
 `Account(username : "pasanpr" , billingAddress : nil) `—

 ... and `nil`
 
 `Account(username : "sketchings" , billingAddress : nil)` ,
 
 we have ,
 if you OPTION click on the constant `validBillingAddresses` , ...
 */

// let validBillingAddresses: [String]

/**
 ... it has a type of just `String` , and not optional String — `String?` .
 And if I were to do something like call `count` on it ,
 you'll see that there are three values :
 */

validBillingAddresses.count // returns 3

/**
 Remember that
 typically  , the return type of `map()` or `flatMap()` is
 the return type of the transformation function .
 
 `allUsers.compactMap { $0.billingAddress }`
 
 OLIVIER : When you OPTION click on `billingAddress` ,
 `billingAddress` is an optional string ,
 so , you’d expect the return type of this array
 
 `let validBillingAddresses = allUsers.compactMap { $0.billingAddress }`
 
 to be an array of optional strings .
 Except `flatMap()` weeds those optionals out
 and a return type is simply an array of strings ,
 — OLIVIER : If you OPTION click on `validBillingAddresses` ,
 
 `let validBillingAddresses: [String]`
 
 The other nice thing is
 that since both `map()` and `flatMap()`
 return arrays
 you can chain methods .
 We you could simply chain the `count` call over here ,
 rather than writing it on a separate line :
 */

let totalOfValidBillingAddresses = allUsers.compactMap { $0.billingAddress }.count

/**
 Another use case is ,
 if we wanted to transform
 each string in the address array
 into a different type
 we can now `map()` over the resulting array .
 */

let transformedAddresses = validBillingAddresses.map { $0.uppercased() }

print(transformedAddresses)

/**
 NOTE :
 Before we move on to the next thing ,
 it is worth clearing up some confusion .
 I said that `map()` and `flatMap()` take transformation functions only ,
 and if you want to perform side effects ,
 you should use a `for loop` .
 What about this case though ?
 
 `let validBillingAddresses = allUsers.compactMap { $0.billingAddress }`
 
 `billingAddress` isn't really transforming anything though , is it ?
 Well , actually it is , we are transforming an array of accounts — `allUsers` —
 into an array of strings without mutating the original data set .
 [ OLIVIER : + we are creating an array with only valid addresses , that is ,
 all addresses that are nil , are not in the new validAddresses array . ]
 
 As we use `map()` and `flatMap()` in our code more and more ,
 it should be more clear on where we should use what , `map()` or a `for loop` .
 */
