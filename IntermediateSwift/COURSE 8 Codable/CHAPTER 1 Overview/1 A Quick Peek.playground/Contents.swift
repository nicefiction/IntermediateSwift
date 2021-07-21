import Foundation


/**
 `COURSE 8`
 `Parsing JSON Using Codable`
 Parsing JSON is one of the more common tasks
 you will undertake in Swift ,
 whether it is for an iOS app
 or server side development .
 Swift 4 introduced the `Codable` protocol
 along with a set of related types
 to provide a built in solution for this.
 Over this course ,
 let's explore
 how to use these types
 to parse JSON of varying complexity .
 
 What you will learn :
 `•` Serialization
 `•` Deserialisation
 `•` Parsing JSON into models
 */



/**
 `CHAPTER 1`
 `An Overview of Codable`
 Before we dig into any of the mechanics of what makes Codable work ,
 let's dive right in
 and parse JSON into a model
 and vice versa
 to understand how easy this is .
 */



/**
 `1 A Quick Peek`
 INTRO — `Codable` is so easy to use
 we can parse some JSON into a model
 with less than 5 lines of code .
 Let's check it out !
 */
/**
 In this series ,
 we are going to take a look at `serialisation` and `deserialisation` ,
 or the `encoding` and `decoding` of data in Swift .
 Much of what we do as Swift developers
 — whether it is moving iOS apps or writing server-side code —
 is taking data that is constructed in a specific format — say , JSON or a PLIST —
 and converting that to Swift objects .
 */

/*
 
 {
 "name" : "Dorothy" ,
 "role" : "designer" ,
 "start date" : "April 10 1900"
 } // JSON
 
 👇

 struct Employee {
 
 let name: String
 let role: Role
 let strartDate: Date
 } // MODEL
 */

/**
 In the past ,
 we have achieved this
 by leaning on foundation types
 like `NSJSONSerialization` ,
 which took in some `JSON` data
 and returned a foundation object .
 */

/*
 let jsonDict = try! JSONSerialization.jsonObject(with : json ,
                                                  options : [])
 
 let model = try! Employee(dict : jsonDict)
*/

/**
 While this got the job done , it wasn't ideal .
 The class was not built with Swift in mind .
 We would still use error prone methods , like
 (`1`) using stringly typed keys to parse the resulting object .
 (`2`) We had to optionally cast to inspect values ,
 and (`3`) we had to coalesce
 — OLIVIER : coalesce = _to come together to form one mass_ —
 several points of failure to something coherent at the call site .
    None of this felt at home in the type-safe world of Swift .
 And this was evident by the fact that there was
 an explosion of third-party JSON parsing libraries ,
 each with their own set of custom operators .
 In Swift 4 the core team added a language feature to handle this .
 And that is what we are here to talk about .
 So without any further ado ,
 let's dive right into the `Codable` protocol .
 Swift's attempt at solving this problem is by means of a protocol ,
 or rather , a set of protocols .
 So let's see how this works :
 */

let json: Data? = """
    {
    "name" : "Dorothy" ,
    "id" : 1 ,
    "role" : "designer"
}
""".data(using : .utf8)

/**
 I have here a playground filed with some simple sample JSON to start with ,
 defined as a `multi-line string literal` .
 (`!`) This isn't actually how JSON would be transmitted in a networking response ,
 so right after , we have some code
 that is converting the string literal to a `Data` object
 using the `UTF-8 string encoding` .
 This JSON represents some information about a particular employee in some database .
 Now , in a code base , we won't be working with `String` or `Data` instances .
 And instead we would have a model that represents this .
 So we have one right here :
 */

/*
struct Employee {
    
    let name: String
    let id: Int
    let role: String
}
 */

/**
 Now , our goal is to get the information ,
 encapsulated in this JSON response ,
 which is currently represented
 as an instance of the Data type
 — as an instance of the model — ,
 
 `let json: Data? = """`
 
 And we can do this in three easy steps :

 `STEP 1`:
 We are going to make our model conform to the `Codable` protocol .
 There should be no additional work to do beyond that , and we'll get into the why later .
 And that is all we need to do with the model .
 */
struct Employee: Codable {
    
    let name: String
    let id: Int
    let role: String
}

/**
 `STEP 2`,
 We need a decoder to handle decoding the JSON ,
 parsing it ,
 and assigning values to the stored properties in our model .
 Foundation now includes — as of Swift 4 — new built-in decoder types .
 So , let’s create an instance of `JSONDecoder` :
 */
let decoder = JSONDecoder()

/**
 `STEP 3`,
 Now that we have a decoder , we can ask it
 to give us an instance of our model using the JSON provided :
 */
let employee = try decoder.decode(Employee.self , from : json!)

/**
 And just like that , we have an `employee` instance .
 
 `NOTE` :
 There are two important things to note here .
 (`1`) One , is , that this is a _throwing_ operation .
 For now we are ignoring this by using the forced version of the `try` ,
 (`2`) Second , when we decode ,
 we simply indicate what type we want to decode to .
 So over here the type I want to decode to is `Employee` ,
 but I don't pass in an instance because that is what we want .
 Instead I pass in the type by saying `Employee.self` ,
 And that is all we need to do . 
 So in the results area ,
 you can see that we have a valid `employee` instance .
 And we can also inspect properties on the return instance :
 */

employee.name // "Dorothy"
employee.id // 1
employee.role

/**
 And you'll see that in the results area ,
 this matches up to the JSON data that we had defined earlier ,
 
 `let json: Data? = """`
     `{`
     `"name" : "Dorothy" ,`
     `"id" : 1 ,`
     `"role" : "designer"`
 `}`
 `""".data(using : .utf8)`
 
 Pretty easy ?
 Of course , there is a good amount of magic going on here .
 So over the next few videos ,
 let's break this simple example down .
 */
