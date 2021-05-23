import Foundation


/**
 `2 DecodingError Context`
 INTRO — All decoding errors carry
 as an associated value
 a `Context` object .
 In this video
 let's take a look at
 what additional information the `Context` object provides .
 */

let json = """
{
    "id" : 10
}
""".data(using: .utf8)!

/**
 Let's modify the `User` type
 to add a new stored property :
 */

struct User: Codable {
    
    let id: Int
    let name: String
}

/**
 So here ,
 we are adding the `name` property of type `String` .
 When we do this ,
 given that the JSON string does not contain a `"name"` key
 — and the `name` property is not optional , ...
 */

let decoder: JSONDecoder = JSONDecoder()

/**
 the decoding should fail .
 And our generic `catch` statement ...
 */

do {
    try decoder.decode(User.self , from : json)
    
} catch let error {
    print(error)
}

/**
 ... prints out an error in the console .
 */

/* ERROR :
 
 keyNotFound(CodingKeys(stringValue: "name", intValue: nil), Swift.DecodingError.Context(codingPath: [], debugDescription: "No value associated with key CodingKeys(stringValue: \"name\", intValue: nil) (\"name\").", underlyingError: nil))
 */

/**
 Most of the useful information is provided by means of a `Context` object ,
 which is defined as a nested type under `DecodingError` .
 
 `Swift.DecodingError.Context( ... )`
 
 Let's take a quick second to understand this type .
 A `Context` object encapsulates three pieces of information ,
 
 `keyNotFound(CodingKeys(stringValue : "name" , intValue : nil) ,`
             `Swift.DecodingError.Context(codingPath : [] ,`
                                         `debugDescription : "..." ,`
                                         `underlyingError : nil))`
 
 `1` first is a `codingPath` ,
 So here you can see that
 the `codingPath` is an empty array .
 This is the path of the keys in the JSON taken
 to get to the point of the failing decode call .
 And we have touched on the `codingPath` before , so you should be familiar .
 Our value here is an empty array because we failed at the top level .
 There was no path taken to display .
 
 
 `2` Next ,
 the `Context` object displays a `debugDescription`
 which is a `String` describing what went wrong .
 In our case ,
 
 `"No value associated with key CodingKeys(stringValue: \"name\", intValue: nil) (\"name\")."`
 
 the `debugDescription` tells it
 that there is no value associated with the key `CodingKeys` .
 Well , what this
 
 `stringValue: \"name\", intValue: nil`
 
 is ,
 a `String` representation of the `CodingKey` itself .
 So , this is how `CodingKeys` are represented under the hood
 with a `stringValue` and an `intValue` . That is what the protocol specifies .
 So here
 
 `"No value associated with key CodingKeys(stringValue: \"name\", intValue: nil) (\"name\")."`
 
 it says there is " No value associated with this key " , this one .
 
 `CodingKeys(stringValue: \"name\", intValue: nil)`
 
 When you see _"No value associated with this key "_ ,
 it is also a sign that your key wasn't found . But that is obvious
 from the actual error that is thrown :
 
 `keyNotFound( ... )`
 
 So here ,
 
 `\"name\"`
 
 we see the key name `\"name\` ,
 which is the key that is missing .
 
 
 `3` Finally ,
 the `Context` type also contains
 an `underlyingError` — if any existed :
 
 `underlyingError : nil`
 
 So this helps bubble up any lower level errors we might run into .
 Earlier in the last video
 — when we got the `dataCorrupted` error —
 the underlying error property was used
 to propagate the error encountered by the `JSONSerialization class` .
 So it is sort of rethrowing that error up the stack .
 It included a `Cocoa error code`
 and a way to potentially solve the underlying situation .
 We may not use or run into `underlyingError` often
 but it is a useful property to be able to convey more information
 that sort of happened deeper within our code .
 So we know in the last video that , okay , the data was corrupted .
 That is sort of like the generic reason . But then ,
 under that , under the hood ,
 we know that had we allowed , `allowFragments` ,

 `let value = try JSONSerialization.jsonObject(with : json ,`
                                              `options : [.allowFragments])`
 
 it would have worked .
 That is really all there is to it .
 Every error thrown by the `DecodingError` type includes a `Context` .
 So make sure you inspect it .
 In case you have forgotten
 — because you may not have done error handling in a while —
 the way you would do that
 — if you wanted to focus on a specific kind of error — is ,
 to `catch` that specific error
 and bind the members associated values to the local constants .
 So here , we will say ...
 */

do {
    try decoder.decode(User.self ,
                       from : json)
    
} catch DecodingError.keyNotFound(let key ,
                                  let context) {
    print("DecodingError keyNotFound :")
    print(key)
    print(context.debugDescription)
}

/* Prints :
 
 DecodingError keyNotFound :
 CodingKeys(stringValue: "name", intValue: nil)
 No value associated with key CodingKeys(stringValue: "name", intValue: nil) ("name").
 */

/**
 ... `keyNotFound` has two associated values ,
 the `key` and the `context` .
 And now , we can print the `key` and print the `context` object ,
 and we can query it further for specific values that we are interested in ,
 like the `debugDescription` .
 Now interestingly ,
 if we were to just catch our errors only as the `DecodingError` type :
 */

do {
    try decoder.decode(User.self , from : json)
    
} catch let error as DecodingError {
    print("error as DecodingError :")
    print(error.errorDescription)
    print(error.failureReason)
    print(error.helpAnchor)
    print(error.localizedDescription)
    print(error.recoverySuggestion)
}

/**
 Remember that the `catch` statement
 does not contain any type information .
 So we don't know what kind of errors we are getting through ,
 but we can cast it over here and say ,
 
 `let error as DecodingError`
 
 And if we were to do it this way , the error type that we cast to
 exposes several computed properties that describe the error ,
 but much of the information is obscured from us .
 Now , you will notice though
 that nearly all these values are `nil` :
 */

/* Prints :
 
 error as DecodingError :
 nil
 nil
 nil
 The data couldn’t be read because it is missing.
 nil
 */

/**
 It is just `localizedDescription` that provides any information ,
 but it is also vague .
 So we know here that the issue with our code , is ,
 that a `keyIsNotFound` ,
 but the `localisedDescription` says
 
 `The data couldn’t be read because it is missing.`
 
 Which isn't very helpful .
 So , just be aware when you are error handling ,
 that if you get lazy
 and `catch` the errors at just the type level , ...
 
 `do {`
    `...`
 
 `} catch let error as DecodingError {`
    `...`
 `}`
 
 ... instead of specific values
 
 `do {`
    `...`
 
 `} DecodingError.keyNotFound(let key , let context) {`
    `...`
 `}`
 
 you might not end up handling errors correctly .
 Mostly because you might be misinformed .
 There is not a lot of data here .
 
 
 
 Okay ,
 so that is decoding errors .
 In the final video ,
 let's shake out encoding errors .
 */
