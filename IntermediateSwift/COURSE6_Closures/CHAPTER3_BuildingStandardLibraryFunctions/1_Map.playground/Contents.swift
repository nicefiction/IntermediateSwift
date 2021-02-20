import Foundation


/**
 `CHAPTER 3`
 `Building Standard Library Functions`
 The Swift standard library contains many extremely useful functions
 that accept closures as parameters
 to carry out complex logic .
 In this stage ,
 we are going to look at
 how these functions work ,
 how we can build them ourselves
 and why functions that accept closures
 are one of the best things ever .
 */
/**
 `1 Map`
 INTRO — The `map()` function allows us
 to apply a transformation
 to each element in an array .
 In this video ,
 let’s explore
 how the `map()` function works
 and how we can build it ourselves .
 */
/**
 With all the code we have written so far across different courses ,
 we have iterated over quite a few arrays
 using `for` loops .
 Broadly speaking ,
 there are two primary reasons
 you iterate over a collection
 using a loop :
 (`1`) One , to use the elements in the array for some computation .
 Lets say you have an array of names ,
 and for every name in the array
 you want to use it to print out a string of some sort .
 (`2`) The second case is when you want to transform the elements in the array .
 Let's say you have an array of numbers ,
 and you want to double each value in the array .
 You could do it like this :
 */

var originalNumbers: [Int] = [
    1 , 3 , 5 , 7 , 9
]


var numbersDoubled = Array<Int>()


for number in originalNumbers {
    
    numbersDoubled.append(number * 2)
}


print(numbersDoubled)

/**
 So this here — what we just did — it is called an `imperative approach` .
 What do I mean by _imperative_ ?
 With `imperative programming` ,
 you tell the compiler what you want to execute ,
 line by line
 for each step .
 The alternative to this is known as the _declarative_ approach .
 In `declarative programming`
 you write code that describes the end result .
 You don't write the intermediate steps for how you want to get there .
 The code we just wrote
 — applying a transformation to each member in the array —
 is exactly what the `map()` function does .
 The difference between the two is that `map()` is a `declarative approach` .
 Take the following example :
 */

// OPTION 1 :

let doubledNumbers = originalNumbers.map { (number: Int) -> Int in
    
    return number * 2
}


// OPTION 2 :

let tripledNumbers = originalNumbers.map { $0 * 3 }


print(doubledNumbers)
print(tripledNumbers)

/**
 In this line of code ,
 
 `let tripledNumbers = originalNumbers.map { $0 * 3 }`
 
 all I am saying , is ,
 that I want to iterate over the array — `originalNumbers` ,
 and multiply each value by `3` ,
 and get a new array back — `tripledNumbers` .
 So , this is the `declarative style` .
 I am not saying that I want to use a `for` loop
 and then iterate over each one
 with each one ,
 I want to take that ,
 and multiply it by `3` .
 That is abstracted away .
 Using this approach ,
 the two main differences that are glaringly obvious , are ,
 that (`1`) in the imperative approach ,
 my final array — `numbersDoubled` —
 is `mutable` — it is declared using `var `:

 `var numbersDoubled = Array<Int>()`
 
 And remember , we don't like mutability .
 It can lead to unexpected results .
    The `declarative approach` on the other hand
 results in an `immutable value`
 — as you can see here :
 
 `let tripledNumbers = originalNumbers.map { $0 * 3 }`
 
 This new array is directly assigned to a constant — `let tripledNumbers` .
 You may have often heard of _functional programming_ .
 `Functional programming` is
 a `declarative` style of programming
 where we use many small functions
 that return immutable data types .
 We abstract away the code that indicates
 _how we want to do things_
 but instead say
 _what we want to do_ .
 Wherever you see the `map()` function ,
 it should be immediately clear that this means one thing :
 (`2`) You are applying a `transformation function`
 to an array of values
 and getting an immutable new array back
 that does not mutate the original data set .
 So , that is the second major difference .
 Here ,
 
 `var originalNumbers: [Int] = [`
     `1 , 3 , 5 , 7 , 9`
 `]`
 
 we are not mutating any array .
 So , _what does this have to do with closures ?_
 Well — as you can see —
 
 `originalNumbers.map(transform: (Int) throws -> T)`
 
 the `map()` function takes a `transformation function`
 in the form of a `closure expression` that it then applies to each element :
 
 `// CLOSURE EXPRESSION` RULE #1 :
 `let doubledNumbers = originalNumbers.map { (number: Int) -> Int in`
 
    `return number * 2`
 `}`
 
 `// CLOSURE EXPRESSION` RULE #6 :
 `let tripledNumbers = originalNumbers.map { $0 * 3 }`
 
 Along with `map()` ,
 there are few other functions in Swift that allow you to program
 in a more declarative style with less mutation .
 To truly understand how they work though
 — rather than just showing you how to use them —
 let’s build each function
 from the ground up .
 In doing this
 you will also gain
 a much better understanding
 of how closures are used across our code .
    So the first function we are going to build , is ,
 the `map()` function .
 We are going to declare the `map()` function
 as part of the `Array` type
 so let's do this in an `extension` :
 */

// extension Array {}

/**
 When we build the `applyOperation()` function earlier , ...
 */

extension Int {
    
    func applyOperation(_ operation: (Int) -> Int)
    -> Int {
        
        return operation(self)
    }
}

/**
 ... we had a parameter that was essentially the transformation function
 except that it was hard coded to accept only integer values .
 
 `operation: (Int) -> Int`
 
 The `map()` function doesn't work that way ,
 instead
 the signature of the transformation function
 that we pass in the closure expression
 depends on
 the array that you call `map()` on .
 Remember earlier
 we said that `map()` — `originalNumbers.map` — knows
 that an integer is being passed in here — `$0` —
 
 `let tripledNumbers = originalNumbers.map { $0 * 3 }`
 
 because `originalNumbers` is an array of integers ,
 
 `var originalNumbers: [Int] = [`
     `1 , 3 , 5 , 7 , 9`
 `]`

 So the signature of this function — `$0 * 3` — that is inferred ,
 depends on the collection that we are calling `map()` on .
 If you can `map()` on an array of strings for example ,
 it expects that the transformation function takes a `String` as an argument .
 _What about the return type ?_
 Well , the return type depends on what you actually do in the transformation function .
 For example ,
 
 `let tripledNumbers = originalNumbers.map { $0 * 3 }`
 
 here — `$0 * 3` — we are just multiplying an integer by an integer
 so , the signature returns an integer .
 If your transformation function returns a boolean value ,
 that is what the return type of the `map()` function is .
 So how do we take all of this into account
 when defining our own version of `map()` ?
 Well , we use generic code .
 Earlier
 you learned
 how you can create generic types and functions
 that work with a range of different types .
 `map()` is no different .
 So let's create this new version of `map()` .
 We will name it `customMap()` ,
 so as not to conflict with the built in one :
 */

// originalNumbers.map(transform: (Int) throws -> T)

extension Array {
    
    func customMap<T>(_ transform: (Element) -> T)
    -> [T] {
        
        var result = Array<T>()
        
        
        for element in self {
            
            result.append( transform(element) )
        }
        
        return result
    }
}

/**
 The `customMap()` function is generic over the type `T` ,
 it takes as an argument
 a transformation function  — `transform` .
 The signature — the type of this function — is `Element to T` ,
 
 `transform: (Element) -> T`
 
 We know that the `Array` type itself is a generic type .
 And so , `Element` here
 
 `transform: (Element) -> T`
 
 refers to the `type parameter` defined in `Array` .
 — OLIVIER : If you COMMAND Click on Array to go to its definition —
 
 `@frozen public struct Array<Element> { ... }`
 
 `T` is the return type of the transformation function ,
 
 `transform: (Element) -> T`
 
 If we pass in a transformation function
 that takes an integer value from an array of ints
 and returns a `String` ,
 `T` will then be a `String` .
 Remember ,
 the `map()` function returns a new array . So ,
 the return type of the `customMap ()` function is an `Array of T` :
 
 `func customMap<T>(_ transform: (Element) -> T)`
 `-> [T] { ... }`
 
 Inside the body of the `customMap()` function is
 the code that we are used to :

 `func customMap<T>(_ transform: (Element) -> T)`
 `-> [T] {`
 
    `var result = Array<T>()`
 
 
    `for element in self {`
 
        `result.append( transform(element) )`
    `}`
 
    `return result`
 `}`
 
 First we create an empty array of the same type as our return type :
 
 `var result = Array<T>()`
 
 Next ,
 we iterate over the elements in the array
 and apply this transformation function to each value :
 
 `for element in self {`
 
     `result.append( transform(element) )`
 `}`
 
 We apply the transformation function
 
 `transform: (Element) -> T`
 
 which takes as an argument an `Element` instance
 — which here is represented by `element` .
 
 `for element in self { ... }`
 
 And the `transform` function guarantees a `return T` .
 So , we can go ahead and append that `[T]` `result`
 
 `result.append( transform(element) )`
 
 — which is an array of `T` ,
 Once we have done that ,
 we can `return result` .
 Remember ,
 the goal of a declarative approach to programming , is ,
 to abstract away the _how_ .
 Here , our `customMap()` function is taking care of
 (`1`) the iterating over the array ,
 and (`2`) applying the transformation function — `transform` — to each value .
 This is the _how_ .
 Our goal in using the `customMap()` function is
 to provide the _what_
 — the transformation function —
 _what_ we want to do to each element .
 So let's see how we can use this . For example ,
 we can say
 */

// LONG FORM :
let integerValuesLongForm = [ "2" , "4" , "6" , "8" , "10" ].customMap { (element: String) -> Int? in

    return (Int(element) ?? nil)
}


// SHORTHAND :
let integerValuesShorthand = [ "2" , "4" , "6" , "8" , "10" ].customMap { Int($0) }



print(integerValuesLongForm)
print(integerValuesShorthand)

/**
 I am just creating a new array on the fly ,
 
 `[ "2" , "4" , "6" , "8" , "10" ]`
 
 an `array literal` with `String` literals representing numbers .
 We are calling `customMap()` on the array literal .
 
 `[ "2" , "4" , "6" , "8" , "10" ].customMap { ... }`
 
 Now , we need to provide a closure expression here . Remember ,
 because this is first the only expression — or the only argument — to our function
 and the last argument , we can get rid of the parentheses ,
 and just provide a `trailing closure` .
 
 `[ "2" , "4" , "6" , "8" , "10" ].customMap { Int($0) }`
 
 So , in this example , I am iterating over an array of strings , this one right here .
 The transformation function accepts our `String` ,
 
 `extension Array {`
 
    `func customMap<T>(_ transform: (Element) -> T)`
    `-> [T] {`
 
        `var result = Array<T>()`
 
 
        `for element in self {`
 
            `result.append( transform(element) )`
        `}`
 
        `return result`
    `}`
 `}`
 
 because `Element` is of type `String` here .
 
 `[ "2" , "4" , "6" , "8" , "10" ].customMap { Int($0) }`
 
 And then it tries to convert that to an integer
 
 `Int($0)`
 
 because this is the initialiser for the `Int` type
 and `$0` represents that first argument .
 Now , this `Int` function — this integer initialiser —
 has a `faillable init()` .
 Basically , if the `String` can be converted to an `Integer`
 we get an integer back
 but if not , we get `nil` back . So ,
 the return type of the `Int()` function is `optional Int` .
 That means , if you look here ,

 `extension Array {`
 
    `func customMap<T>(_ transform: (Element) -> T)`
    `-> [T] { ... }`
 `}`
 
 since this — `(Element) -> T`— is an optional `Int` ,
 the return type of `customMap()` will be an array of optional Ints .
 
 `(_ transform: Element) -> T) -> [T]`
 
 And if you check the type here ,
 OLIVIER : by OPTION clicking on `integerValuesShorthand` ,
 
 `let integerValuesShorthand = [ "2" , "4" , "6" , "8" , "10" ].customMap { Int($0) }`
 
 you'll see that it is an array of optional integers ,
 
 `let integerValuesShorthand: [Int?]`
 
 Since the `map()` function
 — both the real `map()` and `customMap()` —
 are generic  ,
 the return type of the function is determined by
 the return type of the transformation ,
 
 `Int($0)`
 */
/**
 Let's look at one more example :
 */

struct Formatter {
    
    static let formatter = DateFormatter()
    
    
    static func date(from string: String)
    -> Date? {
        
        formatter.dateFormat = "d MMM yyyy"
        
        return formatter.date(from : string)
    }
}


let dateStrings = [
    "10 Oct 1988" , "11 Jan 1947" , "28 Mar 2002"
]

/**
 So here , I have just created a tiny `struct` — `Formatter` ,
 with a `static` method
 that accepts a `string`containing a date in a particular format ,
 
`formatter.dateFormat = "d MMM yyyy"`
 
 and returns an optional instance of `Date` :
 
 `static func date(from string: String)`
 `-> Date? { ... }`
 
 `Date` is the `Foundation class` to work with `Date objects` .
 If we can convert the `string` to a date ,
 we get an instance of `Date` , otherwise we get `nil` .
 Next up , we define an array of `dateStrings` .
 Using a `customMap( )` function ,
 we can map over this array
 and transform each string value to an instance of date :
 */

let formattedDates = dateStrings.customMap { Formatter.date(from : $0) }

/**
 We are using the `Formatter` object I created
 that has a `static` method — `date(from string: String)` — ,
 and remember
 each argument passed in ,
 is represented by `$0` ,
 and that is it . And now , if I say
 */

print(formattedDates)

/**
 you'll see that each of those strings
 has been converted to
 an actual date value
 that the computer can read :
 */

// CONSOLE :
// [Optional(1988-10-09 23:00:00 +0000), Optional(1947-01-10 23:00:00 +0000), Optional(2002-03-27 23:00:00 +0000)]

/**
 `map()` is a super useful function
 that combines the power of generics and closures
 to allow us
 to transform
 arrays .
 You may be thinking , wow ,
 now that I know how to use `map()` ,
 _why should I ever use a for loop ?_
 These are really two distinct tools ,
 and can't be used interchangeably .
 You only use `map()`
 in theory
 when you want to transform an array
 by applying a transformation function
 to go from one type to another .
 So , here
 
 `let formattedDates = dateStrings.customMap { Formatter.date(from : $0) }`
 
 we are going from strings to date types .
 Here
 
 `let integerValuesShorthand = [ "2" , "4" , "6" , "8" , "10" ].customMap { Int($0) }`
 
 we are going from strings to integers .
 And then up here ,
 
 `let numbersDoubled = numbers.map { $0 * 2 }`
 
 integers to integers ,
 but we are transforming it in some way .
 
 `for loops` on the other hand
 are used
 when you want to perform side effects .
 _What does this mean ?_
 If the code you want to execute on looping over the array
 mutates an object
 or modifies the state of your program elsewhere in your code .
 Then a `for loop` is the tool that you need .
 In fact , if you use `map()`
 without actually returning what `map()` does
 and assigning that to a new constant ,
 Xcode will warn you . And say
 that your result is unused because — really —
 you only want to use `map()`
 to transform some dataset
 into another dataset .
 
 
 Okay , enough about `map()` , onto the next thing .
 */
