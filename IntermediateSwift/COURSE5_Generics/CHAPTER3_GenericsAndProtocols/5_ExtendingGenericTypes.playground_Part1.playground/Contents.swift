import Foundation


/**
 `5 Extending Generic Types` PART 1 of 2
 INTRO — For our final video
 we are going to look at
 an extremely useful application of
 a constraint on an associated type .
 */
/**
 For this final exercise ,
 I have defined a random type here
 to model the current weather :
 */

struct Weather {
    
    let temperature: Double
    let humidity: Double
    let chanceOfRain: Double
    let icon: String
    let highTemperature: Double
    let lowTemperature: Double
    let sunrise: Date
    let sunset: Date
}

/**
 And I have gone ahead and created an instance :
 */

let currentWeather = Weather(temperature : 63 ,
                             humidity : 0.36 ,
                             chanceOfRain : 0.04 ,
                             icon : "Cloudy" ,
                             highTemperature : 67 ,
                             lowTemperature : 50 ,
                             sunrise : Date() ,
                             sunset : Date())
 
/**
 Let's assume that during debugging
 I want to know what all the values are in my model at any given time .
 So I want to log this to the console by using the `print( )` function .
 If I do that ...
 */

print(currentWeather)

/**
 ... you see in the console that this is a bunch of random values all in one line .
 I want this value to be formatted nicely .
 So first , I am going to create a protocol for this :
 */

protocol PrettyPrintable {
    
    var prettyDescription: String { get }
}

/**
 My protocol `PrettyPrintable` has a single requirement .
 But despite doing this , I can't call `prettyDescription` on `currentWeather` just yet
 because the type doesn't conform to the protocol . Okay ,
 so let's add an implementation for that . I am going to paste this in ,
 */

extension Weather: PrettyPrintable {
    
    var prettyDescription: String {
        
        return """
            Temperature : \(temperature)\nHumidity : \(humidity)\nChance of Rain : \(chanceOfRain)\nIcon : \(icon)\nHigh Temperature : \(highTemperature)\nLow Temperature : \(lowTemperature)\nSunrise time : \(sunrise)\nSunset time : \(sunset)
            """
    }
}

/**
 Okay , now if I try to do this , if I say ...
 */

print(currentWeather.prettyDescription)

/**
 ... now I should have a much nicer display of the values in my console .
 Okay , let me paste some more code in :
 */

let tuesdayWeather = Weather(temperature : 63 ,
                             humidity : 0.36 ,
                             chanceOfRain : 0.04 ,
                             icon : "Cloudy" ,
                             highTemperature : 67 ,
                             lowTemperature : 50 ,
                             sunrise : Date() ,
                             sunset : Date())

let wednesdayWeather = Weather(temperature : 63 ,
                               humidity : 0.36 ,
                               chanceOfRain : 0.04 ,
                               icon : "Cloudy" ,
                               highTemperature : 67 ,
                               lowTemperature : 50 ,
                               sunrise : Date() ,
                               sunset : Date())

let thursdayWeather = Weather(temperature : 63 ,
                              humidity : 0.36 ,
                              chanceOfRain : 0.04 ,
                              icon : "Cloudy" ,
                              highTemperature : 67 ,
                              lowTemperature : 50 ,
                              sunrise : Date() ,
                              sunset : Date())


let weeklyWeather: [Weather] = [
    
    currentWeather , tuesdayWeather , wednesdayWeather , thursdayWeather
]
 
/**
 Here I have the weather for the next few days
 and I have stored all of them in an array called `weeklyWeather` .
 I am still debugging though ,
 and I want to inspect my values ,
 but I can't call `prettyDescription` on the `weeklyWeather` Array ,
 but I can loop through the `weeklyWeather` Array ,
 */

for day in weeklyWeather {
    
    print(day.prettyDescription)
}

/**
 In the console , you see that again , it is just a giant wall of text .
 Now , I can certainly format this better inside the `for` loop .
 But every time I want to check the values of weather in the array
 I have to write a similar for loop , or a function ,
 or it is basically just a lot of repeated code .
 Instead what we can do , is ,
 combine our knowledge of generics , associated types , and `where` clauses
 with a concept we are already familiar with , extensions .
 So let's get rid of this :
 
 `// for day in weeklyWeather {`
 
 `//    print(day.prettyDescription)`
 `// }`
 
 And we are going to write an extension on the `Array` type .
 Since we want to call a `prettyDescription` computed property
 on an array of Weather values ,
 
 `extension Array { }`
 
 Here is the tricky part ,
 we don't want to add a `prettyDescription` computed property on every array .
 We just want the ones that contain values that themselves are `PrettyPrintable` .
 `Array` is a generic type — we looked at this earlier — if I COMMAND click on `Array` ,
 
 `public struct Array<Element> { ... }`
 
 it has a single type parameter named `Element` .
 In an `extension` we can define constraints on the generic types
 such that the `extension` only applies in cases where the condition is met .
 So here we can say that we want to add an `extension` on `Array`
 but only when the `Array` contains values that conform to `PrettyPrintable` .
 And we'll do that by applying a constraint on the type parameter , using a `where` clause :
 
 `extension Array where Element: PrettyPrintable {}`
 
 `Element` is the generic type parameter on `Array` ,
 which you can inspect by COMMAND clicking on `Array` .
 And now we can add the `prettyDescription` computed property .
 And again , I am just going to paste some code :
 */

extension Array where Element: PrettyPrintable {
    
    var prettyPrintable: String {
        
        var output = ""
        
        
        for (index , element) in self.enumerated() {
            
            output += "\n\n********\n\nIndex:\(index)\n\n\(element.prettyDescription)"
        }
        
        return output
    }
}

/**
 And now you'll see that I can print ...
 */

print(weeklyWeather.prettyPrintable)

/**
 ... and we have a nicely formatted console log of the values
 from each of those individual elements .
 Even better , if I declare an array of integers , let's say :
 */

let numbersArray = [ 1 , 2 ]

/**
 If I tried to call a `prettyDescription` on this array
 you'll see that Xcode doesn't even auto-complete .
 Since the contents of `numbersArray`
 — here , the array local constant —
 don’t conform to `PrettyPrintable`
 that `extension` that we just defined
 does not even apply here .
 
 
 ⚠️
 The types of constraints we can add might seem confusing
 but they follow the same pattern that we have established throughout :
 
 ( A ) If the constraint is on a _generic type parameter_
 — like `Element` in `Array` —
 then you can add a _protocol_
 or a _class based constraint_ .
 
 ( B ) If the extension is on _a protocol that has an associatedtype_
 you can add a constraint to specify the underlying type .
 For example ,
 the code we just wrote earlier
 added a `prettyDescription` property to
 every `Array` that had Elements conforming to the `PrettyPrintable` protocol ,
 
 `extension Array where Element: PrettyPrintable { ... }`
 
 But what if
 instead of doing that
 I just wanted a `prettyDescription`
 on an array of weather elements only
 — of the type `Weather` ?
 Essentially ,
 I want to constrain the underlying type
 based on the type it is
 and not if it conforms to a protocol .
 Now , if `Weather` — the struct — we have earlier , was a class ,
 then this would be quite simple . Because over here
 
 `extension Array where Element: PrettyPrintable { ... }`
 
 we can just add a _class based constraint_ on a generic type parameter ,
 and state that it needs to be either an instance of `Weather` or a subclass .
 But since `Weather` is a struct ,
 I cannot write a constraint on a generic type `Element` ,
 and I can only go there via a _protocol conformance_ trick .
 However , one of the protocols that governs the behaviour of the `Array` type
 is the `Sequence` protocol . So for example ,
 if I write out `Sequence` , and then COMMAND click before it throws an error ...
 
 `public protocol Sequence {`
 
    `associatedtype Element where Self.Element == Self.Iterator.Element`
 
    `associatedtype Iterator: IteratorProtocol`
    `...`
 `}`

 ... you see that `Sequence` is a protocol that has an `associatedtype` — `Iterator` .
 `Iterator` — the `associatedtype` — has a constraint itself
 that substituted types should conform to the `IteratorProtocol` .
 if I write out `IteratorProtocol` , and then COMMAND click before it throws an error ...
 
 `public protocol IteratorProtocol {`
 
    `associatedtype: Element`
 `}`
 
 ... we see that `IteratorProtocol` itself has an `associatedtype` — `Element` .
 And this — much like the generic type on a `Array` —
 defines the type of element traversed in a collection , or in a sequence .
 So we can use this information to write an `extension` on the `Sequence` protocol
 rather than the `Array` type ,
 and we can add constraints to those associated types .
 _Why am I going this route ?_
 You'll see in just a second . So here , I can say ...
 
 `extension Sequence where Iterator.Element == Weather { ... }`
 
 Once more we are going to use a `where` clause to add the constraint .
 The `associatedtype` on `Sequence` is `Iterator` . And again ,
 `Iterator` has its own `associatedtype` — `Element` .
 And we can access that via dot notation , to say `Iterator.Element` .
 And now for the constraint .
 Because this is an `associatedtype` and
 — as you saw in the previous example with associatedtypes —
 we can add a constraint to say what the underlying type actually should be .
 So here we can say that the `associatedtype Element` should be of type `Weather` .
 
 And now if we copy the `prettyDescription` computed property
 from of the `Array extension` ,
 and paste it in the `Sequence extension` , ...
 */

extension Sequence where Iterator.Element == Weather {
    
    var prettyDescription: String {
        
        var output = ""
        
        for (index , element) in self.enumerated() {
            
            output += "\n\n********\n\nIndex :\(index)\n\n\(element.prettyDescription)"
        }
        
        return output
    }
}

/**
👉 Continue in PART 2
*/
