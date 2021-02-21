import Foundation


/**
 `3 Filter`
 INTRO — The `filter()` function allows us
 to easily narrow down
 an array of elements
 to values that match a predicate .
 In this video ,
 let's build the `filter()` function !
 */
/**
 One of the most common operations we conduct with arrays is
 ( A ) to iterate through it
 and ( B ) use elements
 that match
 a particular predicate
 or set of requirements .
 For example ,
 you have written code in the past
 to iterate through a range of values
 using a `for loop`
 and append to a new array
 only the even numbered values .
 Of course , there is another Standard Library function
 to handle exactly this kind of code ,
 the `filter()` function .
 As an example of how `filter()` works ,
 let's try and get an array of even numbers from 1 to 100 :
 */

let evenNumbersLongform = (1...10).filter { (number: Int) -> Bool in
    
    return number % 2 == 0
} // let evenNumbersLongform: [ClosedRange<Int>.Element]


let evenNumbersShortform = (1...10).filter { $0 % 2 == 0 }


print("Even numbers long form : \(evenNumbersLongform)")
print("Even numbers short form : \(evenNumbersShortform)")

/**
 you should see a bunch of even numbers in your console :
 */

// Even numbers long form : [2, 4, 6, 8, 10]
// Even numbers short form : [2, 4, 6, 8, 10]

/**
 Of course ,
 as we have been doing so far ,
 the easiest way to understand what `filter()` does , is ,
 to build a simple version ourselves .
 And again , as with previous examples ,
 we will start with an `extension` on `Array` :
 */

extension Array {
    
    func customFilter(_ isIncluded: (Element) -> Bool)
    -> [Element] {
        
        var filteredElements = Array<Element>()
        
        
        for element in self
        where isIncluded(element) {
            
            filteredElements.append(element)
        }
        
        return filteredElements
    }
}

/**
 Unlike `map()`or `flatMap()` ,
 `filter()` doesn't define its own generic parameter
 because it always has a specific signature .
 `filter()` takes a closure as an argument [ OLIVIER : parameter ]
 with a type signature of `Element to Bool` .
 
 `(Element) -> Bool`
 
 Remember that `Element` refers to the Array's type parameter .
 — OLIVIER : If you OPTION click on Array :
 
 `@frozen public struct Array<Element> { ... }`
 
 Basically ,
 the closure takes a generic parameter — `Element`,
 performs some logic on it to determine whether it fits our criteria ,
 and then returns `true` or `false` .
 If we return `true` from our logical check ,
 then we include the `Element` in a new array , otherwise we don’t .
 Since we are simply filtering through an array
 and not transforming it ,
 the return type of `filter()`
 is the same type as the existing array :
 
 `func customFilter(_ isIncluded: (Element) -> Bool)`
 `-> [Element] { ... }`
 
 We say , `isIncluded` ,
 which is our function
 that checks
 to see
 if we want to include this element
 in a new array .
 And the signature is `Element to Bool` . And again ,
 because we are not transforming
 the return type is going to be an array of the same type ,
 so an array of `Element` .
 These types of functions always return a new array
 because we want to maintain immutability of data . So ,
 we always create a new array .
 Like before , we will start off with
 creating an empty array to start out
 — which is a new array that we are going to append our elements to :

 `var filteredElements = Array<Element>()`
 
 Again ,
 we are going to iterate through `self`
 and grab each element ,
 but this time we are going to do something special ,
 
 `for element in self`
 `where isIncluded(element) { ... }`
 
 Here we are using a `where clause` .
 A `where clause` — just like with generic code —
 is used to introduce a constraint .
 Now , here though , it is a lot more flexible ,
 and essentially ,
 you can provide any expression
 that returns a `Boolean` value as a condition ,
 much like any `control flow statement` . So ,
 after this `where` , we can include a predicate .
 Which is some logic that matches an `Element` to a set of criteria
 and returns either `true` or `false` .
 
 `isIncluded(element)`
 
 If `true` , then we enter the body of the `for loop` ,
 otherwise we just jump to the next iteration :
 
 `func customFilter(_ isIncluded: (Element) -> Bool)`
 `-> [Element] { ... }`
 
 What this — `isIncluded(element)`— does , is ,
 it means we only enter the `for loop`
 if the result of calling `isIncluded` on `element` is `true` .
 So , `isIncluded` is the closure passed into the `filter()` function .
 And if we call that closure
 using the current value of `element` from the array ,
 
 `isIncluded(element)`
 
 if that is `true` , we step in ,
 otherwise we just move to the next iteration .
 So , in that case if it is `true` , we'll just say
 
 `for element in self`
 `where isIncluded(element) {`
 
    `filteredElements.append(element)`
 `}`
 
 `NOTE` : Make sure you don't select `append contentsOf` .
 
 After that , all we are going to do , is ,
 return the [ OLIVIER : new ] result [ OLIVIER : array ] .
 
 `return filteredElements`
 
 Because `filter()` always has to return a `Boolean` value ,
 the closure expression we pass in
 must perform a comparison operation
 and return a `Boolean` .
 */
/**
 Let's look at another variation of using the accounts example :
 */

struct Account {
    
    var username: String
    var billingAddress: String?
}


let allUsers: [Account] = [
    
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
 Let's say in our app
 we displayed a central directory of all accounts
 — much like your contacts app .
 Just like in your contacts app ,
 let's say there was a search bar up at the top
 that lets you type and filter through the list .
 This is as simple as using the `filter()` function .
 For example ,
 to get all the users whose user name start with `p` ,
 we can say
 */

// LONG FORM :
let pNamesLongform = allUsers.customFilter { (account: Account) -> Bool in
    
    return account.username.first == "p"
}


// SHORT FORM :
let pNamesShortform = allUsers.customFilter { $0.username.first == "p" }


print("Long form > Names that start with a 'p' : \(pNamesLongform)")
print("Short form > Names that start with a 'p' : \(pNamesShortform)")

/**
 We pass in a closure .
 
 `$0.username.first == "p"`
 
 And if you `print` `pNamesLongform` and `pNamesShortform` ,
 */

/* CONSOLE :
 Long form > Names that start with a 'p' : [__lldb_expr_5.Account(username: "pasanpr", billingAddress: nil), __lldb_expr_5.Account(username: "paradoxed", billingAddress: Optional("1122 Nope Lane"))]
 
 Short form > Names that start with a 'p' : [__lldb_expr_5.Account(username: "pasanpr", billingAddress: nil), __lldb_expr_5.Account(username: "paradoxed", billingAddress: Optional("1122 Nope Lane"))]
 */

/**
 we see that there are only two accounts that have a `username` with `p` .
 Our closure expression performs an equality operation
 
 `$0.username.first == "p"`
 
 to check whether the first character in the `username` string is equal to `p` .
 This returns `true` if it is , or `false` otherwise .
 and the `customFilter()` function uses that value to determine
 whether it should be appended to the new array — `customFilter` — , or not .
 
 `Filter()` is a bit more intuitive to understand than `map()` or `flatMap()` .
 But works much in the same way ,
 in that it is a very general purpose function
 that takes any kind of closure expression
 matching the signature required .
 This allows you to filter through nearly everything .
 Okay ,
 we have `map()` ,
 `flatMap()` ,
 and `filter()` done . Next ,
 let's walk through the `reduce()` function .
 */
