import Foundation


/**
 `CHAPTER 2`:
 `Parsing to Non-Primitive Types`
 In this short section
 we take a look at the built in support Codable has for parsing
 date strings ,
 urls ,
 floats ,
 and data
 directly to the relevant Foundation types .
 */





/**
 `1 Parsing Dates`: PART 1 OF 2
 INTRO — Dates in JSON are represented as String values
 but this doesn't mean we need to store them as strings in our models .
 In this video , let's take a look at
 how `Codable` can do most of the work for us
 in converting a stringly typed date
 to a more type safe value .
 */
/**
 If you are using the playground I provided at the beginning of the series ,
 open up the project navigator ,
 and you should see different playground pages
 Head over to the Handling Foundation Types page .
 And you can do that
 either using the project navigator ,
 or quickly using the jump bar ,
 In here ,
 we have some new JSON that we are going to work with for the next few videos :
 */

let json = """
{
    "title" : "Harry Potter and the sorcerer's stone" ,
    "url" : "https:\\/\\/openlibrary.org\\/books\\/OL26331930M\\/Harry_Potter_and_the_sorcerer’s_stone" ,
    "publish_date" : "1997-06-26T00:00:00+0000" ,
    "text" : "Once upon a time ." ,
    "rating" : 4.9
}
""".data(using: .utf8)!

/*
struct Book: Codable {
    
    let title: String
    let url: String
    let publishDate: String
}
 */

/*
let decoder = JSONDecoder() // Foundation.JSONDecoder
decoder.keyDecodingStrategy = .convertFromSnakeCase // Foundation.JSONDecoder
let book = try! decoder.decode(Book.self , from : json) // Book

book.title // "Harry Potter and the sorcerer's stone"
book.url
book.publishDate // "1997-06-26T00:00:00+0000"
 */

/**
 We are still working with relatively simple `JSON` here . 
 There are five key value pairs : a title , a URL , a publish date ,
 what looks like text , and a book rating .
 Below that , we have a `Book` type that partially models this data .
 The Book type already conforms to `Codable` .
 We have used a `JSONDecoder()` to go from JSON to an instance of Book .
 Below that , you can inspect the properties .
 I have already done so ,
 and you can see the values reflect the JSON data .
 How all of this works
 should be familiar to you at this point .
 We have managed to achieve our end goal , that is ,
 getting an instance of the model from the JSON structure ,
 but the work is not the best that we can do , why ?
 All right ,
 now the `publishDate` stored property is of type String :
 Inspecting the value down here ,
 
 `book.publishDate // "1997-06-26T00:00:00+0000"`
 
 we see the exact same String as the one in the `JSON data` .
 
 `"publish_date" : "1997-06-26T00:00:00+0000" ,`
 
 JSON can only encode information in a limited number of ways ,
 so it is pretty common to encode dates as strings .
 Typically , the API that we work with to get JSON
 will clearly identify what format the date string is in
 so that we know how to parse it .
 This complicated string that you see right here
 — if you are not familiar with dates —
 is a date in the `ISO 8601 format` ,
 which is a pretty common way of encoding dates .
 It is a standardised format .
 So yeah ,
 while JSON encodes dates as strings ,
 it doesn't mean that our Swift types have to as well .
 Dates in Swift can be represented — or better represented —
 by the `Date` type defined in `Foundation` .
 So yes , you can store your dates as strings ,
 but really , you want to convert them to `Date` .
 Because that allows for a much safer way
 to model
 and work with
 dates and date-based operations
 in Swift .
 The `Date` type encodes a lot of information
 — including calendars , time zones , locales , and so on .
 Prior to `Codable` , the way we would do that ,
 converting from this `String` to a `Date` , is ,
 to use the `DateFormatter` object .
 We would indicate which format `String` we are working with
 and ask it to convert from a `String` to a `Date` .
 With `Codable` we don't have to do any of that .
 Again the type does much of the work .
 Let's change the type of `publishDate`
 from `String` to `Date` :
 */

struct Book: Codable {
    
    let title: String
    let url: String
    // let publishDate: String
    let publishDate: Date
}

/**
 When we do this ,
 execution will get halted , ...
 */

/* ERROR message when using try! :
 
 Fatal error: 'try!' expression unexpectedly raised an error: Swift.DecodingError.typeMismatch(Swift.Double, Swift.DecodingError.Context(codingPath: [CodingKeys(stringValue: "publishDate", intValue: nil)], debugDescription: "Expected to decode Double but found a string/data instead.", underlyingError: nil)): file __lldb_expr_16/1_ParsingDates.playground, line 61
 */
/* ERROR message when using try :
 
 Playground execution terminated: An error was thrown and was not caught:
 ▿ DecodingError
   ▿ typeMismatch : 2 elements
     - .0 : Swift.Double
     ▿ .1 : Context
       ▿ codingPath : 1 element
         - 0 : CodingKeys(stringValue: "publishDate", intValue: nil)
       - debugDescription : "Expected to decode Double but found a string/data instead."
       - underlyingError : nil

 */

/**
 ... and that is because the decoder knows we want a date ,
 but it doesn't know how to get there .
 The most common way to represent time in code , is ,
 by the number of seconds elapsed since January 1st 1970 .
 This is also standard . It is known as `Unix time` , and in Swift
 it is modelled as a value of type `TimeInterval` ,
 which is an _alias_ [ OLIVIER : typealias ? ] for `Double` .
 By default
 — when we specify the type of one of our stored properties as `Date` —
 the decoder expects that the value it gets from the JSON data
 will be a `Double` value in `Unix time` .
 Which is why in the console you see an error .
 It says ,
 
 `Swift.DecodingError.typeMismatch( ... )`
 
 It expected to decode `Double` ,
 but found a `String` instead ,
 so that is what is happening here .
 Just like we had an error earlier
 when we had a key mismatch ,
 we need to provide the decoder
 with additional information
 about the expected JSON values .
 And here ,
 we are going to indicate
 what format the date is in
 by defining a `dateDecodingStrategy` :
 */

let decoder = JSONDecoder()
decoder.keyDecodingStrategy = .convertFromSnakeCase

decoder.dateDecodingStrategy = .iso8601 // ⭐️

let book = try decoder.decode(Book.self , from : json)

/**
 `ASIDE` :
 If you want to read more about the representation of dates and times as an international standard ,
 👉  https://en.wikipedia.org/wiki/ISO_8601
 */

/**
 So ,
 earlier we looked at `keyDecodingStrategy` .
 
 `decoder.keyDecodingStrategy = .convertFromSnakeCase`
 
 This is a `dateDecodingStrategy` .
 
 `decoder.dateDecodingStrategy = .iso8601`
 
 It is real simple .
 Here it will say the date is `.iso8601` .
 Once you do that ,
 you'll notice that we now have a valid Date instance ,
 */

book.publishDate // "Jun 26, 1997 at 2:00 AM"

/**
 which we can perform all sorts of date operations on in a very safe manner .
 We can say ,
 `book.publishDate` is less than today's date ,
 */

book.publishDate < Date() // true

/**
 and it should say true , look at that !
    Okay , `iso8601` is common Date format ,
 which is why there is a predefined value , as you see here .
 But what if the date is in a different format ?
 There are several ways dates can be represented as a `String` ,
 an infinite number of ways .
 So , Harry Potter and the Sorcerer's Stone was published on June 26th, 1997,
 which is what this date is right here ,
 
 `decoder.dateDecodingStrategy = .iso8601`
 */
/**
👉 Continues in PART 2
*/



print("Debug")
