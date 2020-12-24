import Foundation


/**
 `2 Failable and Throwing Initialisers`
 INTRO — What happens if we can't initialise an object ?
 This is a common occurrence if initialisation depends on external data .
 Swift gives us two ways to deal with this
 — failable and throwing initialisers .
 */
/**
 Most of the examples we looked at so far
 assumed that initialisation is always possible .
 But this isn't always true . Sometimes , we may want to initialise a class ,
 but the initialisation process depends on external data that may or may not be available .
 To deal with this
 we have two kinds of specialised init( ) methods :
 ( 1 ) The first of which is a failable initializer :
 `init?() {}`
 When initialising an object using a failable initialiser ,
 the result is an optional ,
 that either contains the object if the initialisation succeeded ,
 or it contains nil , if the initialisation failed .
 Let's look at an example we have seen in past courses :
 */
enum Day {
    case sunday
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
}
/**
 So , here we have an enum ,
 representing the different days of the week .
 Let's assume we have some data that we get
 in the form of an integer corresponding to the day of the week ,
 and from there ,
 we’d like to take that data ,
 and get an enum value .
 We can do that by giving the Day enum an Integer raw value :
 */
enum Day2: Int {
    case sunday = 1
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
}
/**
 Because of the auto incrementing nature of integer raw values .
 Every member now has an assigned value ,
 because we simply gave the value 1 to sunday
 so monday is 2 , tuesday is 3 , and so on .
 
 We also know that enums with raw values have an initialiser ,
 automatically .
 So , we can do something like this :
 */
let monday = Day2.init(rawValue : 4)
/**
 If the initialiser argument falls within the range of our defined values ,
 we get an enum member back — wednesday .
 Otherwise we get nil .
 This is very useful ,
 because in many cases
 getting nil back is better than halting app execution .
 By marking an init( ) method as failable ,
 you allow the compiler to consider the different paths of execution
 rather than handling it implicitly .
 We have used failable initialisers in code ,
 but we never took the time to properly write one ourselves , and it is all quite simple .
 All we need to do — to mark an initialiser as failable — , is ,
 to add a question mark or an exclamation point after the init keyword
 which indicates the form of the optional that will be produced
 by constructing an object with that initialiser .
 Once you mark an initialiser as failable
 you can return nil
 to indicate that the initialisation has failed .
 So , let's write a simple one :
 */
class Person {
    var name: String
    var age: Int
    
    init?(dictionary: [String : AnyObject]) {
        guard
            let _name = dictionary["name"] as? String ,
            let _age = dictionary["age"] as? Int
        else { return nil }
        
        self.name = _name
        self.age  = _age
    }
}
/**
 We want to initialise the Person instance from a Dictionary .
 The dictionary that we use may not contain the values that we need ,
 so we will mark this initialiser as failable by adding a question mark :
 `init?(dictionary: [String : AnyObject]) { ... }`
 Inside the else clause of the guard statement ,
 we can return nil ,
 because this is a failable initialiser .
 If it works ,
 we have the values we need ,
 so we can assign those to our stored properties
 and set up the class .
 Basically ,
 a failable initialiser is used ,
 when you want to indicate failure
 to create an instance with a nil value .
 The nil value allows you to figure out
 an alternate path for your code if initialisation fails ,
 at the point where you create an instance .
 
 However ,
 sometimes initialisation can fail ,
 and you simply have no alternate path , or don't want to take one .
 In this case ,
 we have a second specialised initialiser :
 A t`hrowing initialiser .
 The logic is the same, but rather than using a question mark .
 We can mark the initialiser as a throwing method :
 `init() throws {}`
 Going back to our example ,
 let's change this initialiser to a throwing one .
 Rather than returning nil ,
 we are going to throw an error instead .
 We can then deal with the error at the point of initialisation
 rather than making it a concern of the class :
 */
enum HumanError: Error {
    case invalidData
}


class Human {
    let name: String
    let age: Int
    
    init(dictionary: [String : AnyObject]) throws {
        guard
            let _name = dictionary["name"] as? String ,
            let _age = dictionary["age"] as? Int
        else {
            throw HumanError.invalidData
        }
        
        self.name = _name
        self.age  = _age
    }
}
/**
 `NOTE` : If you play around ,
 you'll notice that an init( ) method can be marked as both throwing and failable ,
 but you shouldn't really do that .
 
 `GOOD PRACTICE` : A simple rule ,
 if you want to continue execution
 after initialisation fails
 by adding an alternative path to your code ,
 then use a failable initialiser .
 Otherwise ,
 use a throwing init( )
 and halt program execution in some way
 so that you can deal with that error .
 */
