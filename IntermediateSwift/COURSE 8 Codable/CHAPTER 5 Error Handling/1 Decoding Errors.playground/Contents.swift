import Foundation


/**
 `CHAPTER 5`
 `Error Handling`
 Error handling with `Codable` is fairly straightforward .
 Over the next few videos
 let's look at the various kinds of errors we can run into .
 */



/**
 `1 Decoding Errors`
 INTRO — Errors in `Codable` are broken down into two types .
 In this video
 let’s look at
 errors we can encounter when decoding JSON .
 */
/**
 Throughout this series ,
 we have made it a point to just ignore error handling
 so that we could focus on encoding and decoding .
 But as you might have realised
 from the number of times we have typed out
 that exclamation point after the `try` statement ,
 there are several places where encoding and decoding can go wrong .
 Codable breaks up errors in to two types :
 (`1`) decoding errors , defined by the `DecodingError` type ,
 and (`2`) encoding errors , defined by `EncodingError` .
    This is better than one catch-all type ,
 because that would mean having to catch every kind of error ,
 regardless of whether we are serialising or deserialising .
 In practice
 that would mean
 that developers often just write one generic `catch` statement
 or ignore errors all together .
 We have some experience with `DecodingError` .
 In an earlier video ,
 we ran into a situation
 where a key we were looking for
 may have not existed ,
 and instead of force unwrapping that `codingPath` ,
 we threw an error  :
 
 `init(from decoder: Decoder)`
 `throws {`
     
     let languageContainer = try decoder.container(keyedBy : LanguageCodingKeys.self)
     
     guard
         let _name = languageContainer.codingPath.first
     else {
         let context = DecodingError.Context.init(codingPath : languageContainer.codingPath ,
                                                  debugDescription : "Dynamic language key not found .")
         
         throw DecodingError.keyNotFound(Language.LanguageCodingKeys.name ,
                                         context)
     }
     
     self.name        = _name.stringValue
     self.designer    = try languageContainer.decode([String].self , forKey : Language.LanguageCodingKeys.designer)
     self.releaseDate = try languageContainer.decode(String.self   , forKey : Language.LanguageCodingKeys.released)
 `}`
 */
/**
 `DecodingError` is not a complex type at all ,
 and only defines four types of errors :
 `{1}` So the first one is `dataCorrupted` .
 This error is thrown when the data is corrupted .
 If you run into this error
 there is a high chance that your JSON is not valid .
 */

/*
let json = """
    "id" : 10
""".data(using : .utf8)!


struct User: Codable {
    
    let id: Int
}


let decoder = JSONDecoder()
 */

/**
 We have some sample `json` ,
 a `User` type that conforms to `Codable` ,
 and a `decoder` .
 So , let’s try to decode this `json` into an instance .
 The correct way to do this
 — in contrast to the way we have been doing it all along — is ,
 to use a `do try catch statement` ,
 since these are all throwing operations .
 So we will say ,
 */

/*
do {
    try decoder.decode(User.self , from : json)
    
} catch let error {
    print(error)
}
 */

/**
 We include a generic `catch` block , and we print the error .
 The decoding operation should fail .
 And in the console ,
 you can see the `dataCorrupted` error :
 */

/* ERROR :
 
 dataCorrupted(Swift.DecodingError.Context(codingPath: [], debugDescription: "The given data was not valid JSON.", underlyingError: Optional(Error Domain=NSCocoaErrorDomain Code=3840 "Garbage at end." UserInfo={NSDebugDescription=Garbage at end.})))
 */

/**
 The `decoder` took a look at our `json` ,
 and since it didn't begin with an array or dictionary ,
 it considers it invalid
 and throws the `dataCorrupted` error .
 If we got this `json` directly from a server ,
 then this situation is out of our control .
 Now , the `json` string that you see in this playground right now
 is actually valid JSON .
 If you go back down to the error and inspect it further ,
 you'll see that we have the `dataCorrupted` error ,
 but then we also have some more information , a lot of it actually .
 And here is a value called `underlyingError` ,
 
 `underlyingError: Optional(Error Domain=NSCocoaErrorDomain Code=3840 "Garbage at end."`
 
 and we see a `Code` of `3840` for `NSCocoaErrorDomain` ,
 and the description saying
 that the JSON text did not start with an array or an object
 [OLIVIER : In our case it says "Garbage at end."]
 — read : object as a dictionary .
 In addition , it says that the option to allow fragments is not set
 [OLIVIER : This is not the case in our error message] .
 This underlying error is again specified in a `UserInfo` dictionary ,
 
 `UserInfo={NSDebugDescription=Garbage at end.}`
 
 so it tells us twice that we didn't start with an array or dictionary
 [OLIVIER : In our case it says "Garbage at end."]
 and we did not allow fragments .
 [OLIVIER : Fragments are not mentionned in our Error message ."]
 So , there is a lot going on here ,
 particularly with these nested error descriptions .
 Let's peel things back a bit .
 This is really the only complicated error that you might run into .
 As is often the case , since Swift is relatively new ,
 — particularly open source Swift with some of the newer Foundation types —
 a lot of this code is actually relying on existing functionality to get the job done .
 At the very start of this series ,
 I mentioned that `Codable` and its related types
 allow us to bypass `NSJSON serialization` to encode and decode JSON .
 That wasn't entirely true .
 Before we got `Codable` ,
 we got a Swift version of `JSONSerialization` — which is of type `NSObject` .
 `JSONSerialization` lets us parse JSON much like we did in Objective C ,
 but with a more Swift type .
 `Codable` and its related types still use `JSONSerialization` under the hood .
 And while this isn't a Cocoa type ,
 it still implements some of that functionality
 and returns some of its error messages .
 One of the things we could do with `JSONSerialization` was
 passing a `Set` of `options` when decoding ,
 that inform the parser about how the JSON was structured .
 One of those options was called `allowFragments` ,
 so we can actually do that over here :

`let value = try JSONSerialization.jsonObject(with : json ,`
                                             `options : [.allowFragments])`

 We pass in our data object here ,
 
 `with : json`
 
 and in this options field it takes an option Set .
 
 `options : [.allowFragments]`
 
 So , what this tells the parser , is ,
 that JSON may not be structured at the top level as an Array or object ,
 but go ahead and parse it anyway .
 So , that is what allow fragments not sent means
 in this error message in the console ,
 Unfortunately ,
 while `JSONDecoder` uses `JSONSerialization` under the hood
 — and that is why you see all these error messages :
 
 `dataCorrupted(Swift.DecodingError.Context(codingPath: [], debugDescription: "The given data was not valid JSON.", underlyingError: Optional(Error Domain=NSCocoaErrorDomain Code=3840 "Garbage at end." UserInfo={NSDebugDescription=Garbage at end.})))`
 
 — it doesn't expose the ability
 to turn on or off
 the `allowFragments` flag .
 So , while technically , this is valid JSON ,
 
 `let json = """`
     `"id" : 10`
 `""".data(using : .utf8)!`
 
 that we should be able to parse ,
 we cannot do it if we are using `JSONDecoder`,
 
 `let decoder = JSONDecoder()`
 
 so that is what all these errors mean .
 But we can change this up ,
 so let's use a dictionary .
 And now ,
 the console should parse it perfectly ,
 */

let json = """
{
    "id" : 10
}
""".data(using : .utf8)!



struct User: Codable {
    
    let id: Int
}



let decoder = JSONDecoder()



do {
    try decoder.decode(User.self ,
                       from : json)
    
} catch let error {
    print(error)
}

/**
 Okay , and we have a valid type .
 There we go . Okay , so ,
 the remaining decoding errors are pretty straight forward .
 
 {`2`}
 ` keyNotFound` indicates that a key that we are searching for
 was not found in the `json` structure .
 This can occur in three ways ,
 all of which we have covered so far .
 
    {`2.1`} So first , the key exists ,
 but there is a mismatch between the String representation of the key
 defined through our `CodingKey` conforming type and the actual `json` .
 We can resolve this by
 either specifying `.convertFromSnakeCase` at the `decoder` level , ...
 
 `decoder.keyDecodingStrategy = .convertFromSnakeCase`
 
 ... or implementing a custom `CodingKey` conforming type
 where we have more control over our key specifications .
 
    {`2.2`} The second situation you might run into , is ,
 one where the JSON response from the server includes the key
 only some of the time .
 When it is not specified — unless you handle it —
 you'll run into a `keyNotFound` error .
 You have seen this before .
 You would handle this situation by asking the `decoder` to only _decode if present_ .
 
    {`2.3`} Lastly ,
 you might run into a situation where the key actually doesn't exist ,
 which would mean that you need to change your model .

 {`3`}
 The next error that we can run into is a `typeMismatchError` ,
 and this occurs if you are trying to decode into a type
 that does not match what the `decoder` expects .
 So , let's say the `decoder` can convert to a `Integer` value ,
 but you are asking it to convert it to a `Double` value ,
 that wouldn't work . Or a `String` and `Int` .

 {`4`}
 And lastly ,
 you can run into a `valueNotFoundError` .
 And this is simple , we would model this with an optional type .
 */
/**
 So that is all there is to `DecodingError` .
 One thing you notice though , is ,
 that each inner member ,
 so let's go to _help > developer documentation_ ,
 and we are going to look for the `DecodingError` type ,
 There we go ,
 
 
 `case dataCorrupted(DecodingError.Context)`
 An indication that the data is corrupted or otherwise invalid .
 
 `case keyNotFound(CodingKey, DecodingError.Context)`
 An indication that a keyed decoding container was asked for an entry for the given key ,
 but did not contain one .
 
 `case typeMismatch(Any.Type, DecodingError.Context)`
 An indication that a value of the given type could not be decoded
 because it did not match the type of what was found in the encoded payload .
 
 `case valueNotFound(Any.Type, DecodingError.Context)`
 An indication that a non-optional value of the given type was expected ,
 but a null value was found .
 
 
 And if we look at this type ,
 we'll notice that
 all the enumeration cases include — as an associated key — at minimum ,
 all of them carry an instance of `DecodingError.Context` .
 So this bit is important .
 So let's inspect this value a little more in the next video .
 */
