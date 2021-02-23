import Foundation


/**
 `4 Reduce`
 INTRO — The `reduce()` function
 allows us
 to combine elements in an array
 into a single value .
 This is conceptually the hardest of the Standard Library functions to understand ,
 and in this video
 we look at a few examples
 before building it ourselves .
 */
/**
 Oftentimes we write code like this :
 */

let scores = [
    10 , 12 , 11 , 10 , 12 , 9
]


var totalScore: Int = 0


for score in scores {
    
    totalScore += score
}


print(totalScore)

/**
 We have a `totalScore` variable that starts off at `0` .
 We iterate through the scores in the `scores` array
 and then we append to `totalScore` the sum of each of those scores .
 Pretty common code that we have seen before .
    As is the theme with this set of videos ,
 we have a Standard Library function that does this
 and is called `reduce()` .
 It is called `reduce()`
 because we are reducing a set of values
 down to a single value .
 `reduce()` is pretty powerful .
 Let's see how we can use it in this case :
 */

// CLOSURE EXPRESSION Longform Olivier :
let totalScoreLongform = scores.reduce(0) { (total: Int , score: Int) -> Int in
    
    return total + score
}


// CLOSURE EXPRESSION Midform Pasan :
let totalScoreMidform = scores.reduce(0 , { total , score in

    return total + score
}) // OLIVIER : This closure expression is the most confusing to me .


// CLOSURE EXPRESSION Shortform :
let totalScoreShortform = scores.reduce(0) { $0 + $1 } // Too cryptic IMO .


print("Total score long form : \(totalScoreLongform)")
print("Total score mid form : \(totalScoreMidform)")
print("Total score short form : \(totalScoreShortform)")

/**
 I pass in a closure .
 
 `{ total , score in`
 
    `return total + score`
 `}`
 
 `NOTE`: Again , the advantage here in using `reduce()` is ,
 that `totalScoreLongform` now is a constant ,
 
 `let totalScoreLongform = scores.reduce(0) { ... }`
 
 and not a variable like we had before .
 
 `var totalScore: Int = 0`
 
 Let's read this function ,
 
 `let totalScoreLongform = scores.reduce(0) { (total: Int , score: Int) -> Int in`
 
    `return total + score`
 `}`
 
 because this is a bit more complicated ,
 The `reduce()` function takes an initial value — `0`,
 
 `scores.reduce(0) { ... }`
 
 And we have provided `0` as the argument ,
 just like when we initialise the `totalScore` variable to `0` in the `for loop` —
 
 `var totalScore: Int = 0`
 
 Next ,
 we pass in a closure that defines our combined function .
 
 `scores.reduce(0) { (total: Int , score: Int) -> Int in`
 
    `return total + score`
 `}`
 
 The combined function takes two parameters — `total` and `score` :
 (`1`) `total` — avariable to hold the combined value as we iterate through the array —
 and (`2`) `score` — the `Element` from the `Array` .
 So this `total` is what we add to every time ,
 and `score` is each score in the array as we iterate through it .
 So initially `total` equals `0` .
 With every value we pull out of the array — which is assigned to `score` ,
 we add that back to the `total` :

 `return total + score`
 
 This is a bit confusing though .
 So , let's define this ourselves .
 Like `map()` and `flatMap()` ,
 `reduce()` is again a generic function :
 */

extension Array {
    
    func customReduce<Result>(_ initialValue: Result ,
                              _ nextPartialValue: (Result , Element) -> Result)
    -> Result {
        
        var totalValue = initialValue
        
        
        for element in self {
            
            totalValue = nextPartialValue(totalValue , element)
        }
        
        return totalValue
    }
}


let customScores = scores.customReduce(0) { (totalScore: Int , score: Int) -> Int in
    
    return totalScore + score
} // let customScores: Int

print("Custom scores : \(customScores)")

/**
 We name the generic type parameter , `Result`
 instead of `T` as we have been doing .
 `reduce()` takes two parameters :
 (`1`) An `initialValue` of type `Result`
 and ( 2 ) a function — `nextPartialResult` —
 that combines the previous value of `Result` with the next
 to form a partial result . So ,
 it takes two arguments : ( A ) `Result` and ( B ) `Element`
 and returns `Result` .
 
 `nextPartialValue: (Result , Element) -> Result`
 
 Right , so this ...
 
 `scores.customReduce(0) { (totalScore: Int , score: Int) -> Int in`
 
    `return totalScore + score`
 `}`
 
 ...  is like ,
 
 `func customReduce<Result>(_ initialValue: Result ,`
                           `_ nextPartialValue: (Result , Element) -> Result)`
 `-> Result { ... }`
 
 when we start out with `0` ,
 we get a new `Element` ,
 we add it back to `Result` ,
 and then return `Result` .
 Finally , `reduce()` has a return type of `Result` as well .
 Inside the body ,
 
 `func customReduce<Result>(_ initialValue: Result ,`
                           `_ nextPartialValue: (Result , Element) -> Result)`
 `-> Result {`
 
    `var totalValue = initialValue`
 
 
    `for element in self {`
 
        `totalValue = nextPartialValue(totalValue , element)`
    `}`
 
    `return totalValue`
 `}`
 
 we first create a temporary variable ,
 and assign the `initialValue` to it ,
 
 `var totalValue = initialValue`
 
 Then we iterate over the values in the array
 and combine the value of result with the value of `element` :
 
 `for element in self {`

     `totalValue = nextPartialValue(totalValue , element)`
 `}`
 
 `totalValue` — and this is a variable ,
 so we can keep assigning back to it —
 is the result of calling `nextPartialResult()`
 and passing in `totalValue`— `Result` first
 and then `element` — `Element`—  second .
 `element` here represents every element in the array
 and `totalValue` is the total .
 When that is done
 — once we have iterated through the whole array —
 we can `return totalValue` .
 
 Hopefully that should clear things up .
 
 `NOTE` : You might have been confused
 as to what `totalScore` and `score` are over here ,
 
 `let customScores = scores.customReduce(0) { (totalScore: Int , score: Int) -> Int in`
 
    `return totalScore + score`
 `}`
 
 Remember ,
 in a `closure expression`
 we can assign `temporary names` to the parameters
 so that we can define the `logical expression` .
 Here , `totalScore` and `score` are the names I gave ,
 it could be `$0` , `$1` if you wanted ,
 
 `let totalScoreShortform = scores.reduce(0) { $0 + $1 }`
 
 but that is really hard to read .
 So this is where closure expressions are really powerful .
 In the body of `customReduce()` , ...
 
 `func customReduce<Result>(_ initialValue: Result ,`
                           `_ nextPartialValue: (Result , Element) -> Result)`
 `-> Result {`
 
    `var totalValue = initialValue`
 
 
    `for element in self {`
 
        `totalValue = nextPartialValue(totalValue , element)`
    `}`
 
    `return totalValue`
 `}`
 
 ... we provide arguments to the `nextPartialValue()` function ,
 
 `totalValue = nextPartialValue(totalValue , element)`
 
 but we do not say
 _how_ it should be combined .
 We defer that until the `reduce()` function is called
 and we pass in a `closure expression` .
 So , for example ,
 `nextPartialValue` — in this case —
 
 `let customScores = scores.customReduce(0) { (totalScore: Int , score: Int) -> Int in`
 
    `return totalScore + score`
 `}`
 
 is just adding it ,
 
 `return totalScore + score`
 
 It could be multiplying ,
 it could be doing whatever it wants ,
 different ways of combination .
 For this example , `reduce()` seems overkill ,
 and in fact ,
 the `for loop` version may read better to you .
 The power of `reduce()` becomes apparent
 when you realise that `reduce()`
 doesn't need
 to return the same type
 as the elements in the array .
 So for example ,
 let's say we wanted to create a random identifier ,
 consisting of numbers under 100
 that are both divisible
 by 3
 and by 7 ,
 all joined together in a `String` .
 That sounds complicated , right ?
 Well , not at all ,
 if we use the functions that we know .
 For example ,
 let’s define our dataset as the numbers under 100
 that are both divisible by three and seven .
 We use the `filter()` function to do this ,
 */

// CLOSURE EXPRESSION Longform Olivier :

let divisibleBy3And7LongForm = (0...100).filter { (number: Int) -> Bool in
    
    return (number % 3 == 0) && (number % 7 == 0)
} // let divisibleBy3And7LongForm: [ClosedRange<Int>.Element]


// CLOSURE EXPRESSION Shortform :

let divisibleBy3And7ShortForm = (0...100).filter { $0 % 3 == 0 && $0 % 7 == 0 }

print("Divisible by 3 and 7 Long form : \(divisibleBy3And7LongForm)")
print("Divisible by 3 and 7 Short form : \(divisibleBy3And7ShortForm)")

/**
 Next , we can use `reduce()` on the `divisibleBy3And7LongForm` array :
 */

// CLOSURE EXPRESSION Longform Olivier :

let identifierLongform = divisibleBy3And7LongForm.reduce("") { (totalString: String , number: Int) -> String in
    
    return totalString + String(number)
} // let identifierLongform: String

// CLOSURE EXPRESSION Shortform :

let identifierShortform = divisibleBy3And7LongForm.reduce("") { $0 + String($1) }


print("Identifier Long form : \(identifierLongform)")
print("Identifier Short form : \(identifierShortform)")

/**
 For the initial value
 we are passing in an empty `String` .
 
 `divisibleBy3And7LongForm.reduce("") { ... } `
 
 Remember that we want a `String` in the end ,
 even though we are starting with an array of numbers , we want a `String` in the end . So ,
 we are using the `reduce()` function on `divisibleBy3And7LongForm` .
 `NOTE` that I am using the actual `reduce()` function here ,
 not the `customReduce()` function we defined earlier .
 
 For the closure expression ,
 
 `divisibleBy3And7LongForm.reduce("") { (totalString: String , number: Int) -> String in`
    `...`
 `}`
 
 we are assigning some names
 — `totalString` and `number` —
 so that it is easier to read . So again ,
 `totalString` is that `String` that we have initially assigned `""`
 — that we are going to add back to over and over again .
 And `number` , is each number that we get out of the `divisibleBy3And7LongForm` array .
 To combine this , we say , `in` .
 We add an interpolated String containing the number , back into the string that we are building up .
 
 `let identifierLongform = divisibleBy3And7LongForm.reduce("") { (totalString: String , number: Int) -> String in`
 
    `return totalString + String(number)`
 `}`
 
 So , in every iteration , we say , `totalString` — which is a result set —
 and to that will add another interpolated string containing the number — `String(number)`
 that we get from the `divisibleBy3And7LongForm` array .
 And that is it .
 If I print the `identifierLongform`
 — I am just going to type it out — so you can see it in the results area ,
 
 `print("Identifier Long form : \(identifierLongform)")`
 
 there you go :
 */

// CONSOLE :
// Identifier Long form : 021426384

/**
 You see a unique number in the results area as a `String` .
 `reduce()` is so powerful
 that you can actually build up `map()` and `filter()` using it .
 */



/**
 Hopefully , `map()` , `flatMap()` ,` filter()` , and `reduce()`
 have shown you
 how useful closures are
 and the kinds of powerful code we can write
 using `higher order functions` .
 It takes a while
 to get used to writing this code though
 and understanding what it does
 and that is okay .
 Remember ,
 give everything time to sink in .
 When you first started learning Swift
 remember how hard a `for in loop` was to grasp ?
 Well now that stuff is like second nature .
 So don't worry ,
 you’ll get there with closures too .
 */
