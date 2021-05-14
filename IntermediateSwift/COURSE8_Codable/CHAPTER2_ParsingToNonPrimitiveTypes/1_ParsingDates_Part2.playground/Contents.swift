import Foundation


/**
 `1 Parsing Dates`: PART 2 OF 2
 _But what if the date is in a different format ?_
 There are several ways dates can be represented as a string ,
 an infinite number of ways .
 So , Harry Potter and the Sorcerer's Stone was published on June 26th, 1997,
 which is what this date is right here ,
 */

/*
let json = """
{
    "title" : "Harry Potter and the sorcerer's stone" ,
    "url" : "https:\\/\\/openlibrary.org\\/books\\/OL26331930M\\/Harry_Potter_and_the_sorcerer’s_stone" ,
    "publish_date" : "1997-06-26T00:00:00+0000" ,
    "text" : "Once upon a time ." ,
    "rating" : 4.9
}
""".data(using: .utf8)!
 */

struct Book: Codable {
    
    let title: String
    let url: String
    let publishDate: Date
}

/*
let decoder = JSONDecoder()
decoder.keyDecodingStrategy = .convertFromSnakeCase
decoder.dateDecodingStrategy = .iso8601

let book = try! decoder.decode(Book.self , from : json)
book.publishDate // "Jun 26, 1997 at 2:00 AM"
 */

/**
 But let's see the JSON data that we get back ,
 in the JSON data ,
 the date is written as one would write dates in your diary , so
 `June 26th, 1997`.
 */

let json = """
{
    "title" : "Harry Potter and the sorcerer's stone" ,
    "url" : "https:\\/\\/openlibrary.org\\/books\\/OL26331930M\\/Harry_Potter_and_the_sorcerer’s_stone" ,
    "publish_date" : "June 26, 1997" ,
    "text" : "Once upon a time ." ,
    "rating" : 4.9
}
""".data(using: .utf8)!

/**
 Our code is going to fail again here , ...
 */

/* ERROR message :
 
 Fatal error: 'try!' expression unexpectedly raised an error: Swift.DecodingError.dataCorrupted(Swift.DecodingError.Context(codingPath: [CodingKeys(stringValue: "publishDate", intValue: nil)], debugDescription: "Expected date string to be ISO8601-formatted.", underlyingError: nil)): file __lldb_expr_19/1_ParsingDates_Part2.playground, line 60
 */

/**
 ... because the decoder cannot parse the date anymore .
 If _COMMAND + click_
 on the `JSONDecoder()` type ,
 you'll find an `enum`
 that defines all possible `DateDecodingStrategies` :
 */

/*
 /// The strategy to use for decoding `Date` values.

 open class JSONDecoder {
    public enum DateDecodingStrategy {
 
        case deferredToDate
        case secondsSince1970
        case millisecondsSince1970
        @available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
        case iso8601
        case formatted(DateFormatter)
        case custom((Decoder) throws -> Date)
    }
 }
 */

/**
 At the top , you have four predefined values :
 we have
 `deferredToDate` ,
 `secondsSince1970` ,
 `millisecondsSince1970` ,
 and then `iso8601` .
 Right , so we have used this one ,
 these are other predefined formats ,
 and `deferredToDate` is the default strategy .
 Below these ,
 we have two options to define a custom format string .
 The first of the two involves using a `DateFormatter` object
 that defines the format string of the expected date value .
 The second allows us to pass in a closure
 that takes a `Decoder` object , and returns a `Date` .
 Let's look at the example using the `DateFormatter` object
 so that you have an idea of how to work with custom date strings
 should you run into them , which chances are pretty high that you will .
 So , let’s go back ,
 and first we are going to create a formatter object
 — an instance of `DateFormatter()` :
 */

/*
let decoder = JSONDecoder()
decoder.keyDecodingStrategy = .convertFromSnakeCase
// decoder.dateDecodingStrategy = .iso8601
let dateFormatter = DateFormatter()
 */

/**
 `DateFormatter` is a Swift object
 that converts between
 a date object and its textual representation
 — which is exactly what we are trying to do .
 With a `DateFormatter` instance ,
 you can specify a format string that encodes a date
 in a fixed format date representation .
 This is quite outside the scope of this course ,
 but let's take a look at a resource that provides an overview .
 One of my friends
 — Ben Sherman , who runs `nsscreencast.com` —
 has created this really handy date formatting website for Swift developers
 over at `nsdateformatter.com` .
 So in the table below [ OLIVIER : on the nsdateformatter.com website ] ,
 you see on the left various ways of specifying dates over here .
 And on the right ,
 the fixed format that is used to represent it .
 So , given a random date ,
 to get a string that looks like this ,
 
 `Saturday, Aug 10, 2019`
 
 we use this format :
 
 `EEEE, MMM d, yyyy`
 
 If you go up at the top ,
 there is a date in a `DATE` field ,
 and a `FORMAT STRING` specified on the right
 that lets you convert this date into a textual representation .
 So , in this first row , for example ,
 using this date over here ,
 `EEEE` is converted to _Saturday_ .
 `MMM` is converted to _Aug_ ,
 the short form of the month and so on .
 `d` is the _date_ ,
 and `yyyy` gives you the _year_ .
 To figure out what all this is
 and how we know what to specify ,
 you can click on this `Reference tab` ,
 and you'll see what each of these characters mean .
 Take some time to get familiar with it ,
 You can see that if you want to convert a date to just a single month
 — the numeric month of the year —
 you provide an uppercase `M` as a date format string .
 And notice here that if you do a single `M` , it will use "1" for January ,
 whereas double uppercase `M` uses "01" for January .
 The reason this is important that we use a date format — or object with a format string — is
 because not everyone represents dates the exact same way .
 December is the English version of the name of the month .
 So if , for example ,
 our locale on our iPhone was France
 — or any other country for that matter — and we just encode it as December ,
 that is wrong .
 By providing these codes
 — so MMMM gives you the full name of the month —
 the date formatter will figure out what your `locale` is ,
 what your time zone is ,
 and convert these to the right way ,
 to represent a date in your country and culture .
 Okay , so going all the way up to the top ,
 so we have a date here .
 Let's write in that date string that we had earlier
 — which was June 26, 1997 .
 So now you see here with this date ,
 it is parsing this date using this format string
 and getting a textual representation .
 So what we want to do here , is ,
 to get a textual representation that looks exactly like this .
 So , replicate this bit of information
 down here ,
 and that way we know that the format string is
 how the date is encoded in our JSON structure .
 So right now ,
 _June_ is being converted to `Jun` .
 We want the full form ,
 so let's go over to the Reference list at the bottom .
 If we scroll down to the `MONTH` section ,
 
 `MMMM`     `December`
 
 you'll see that to get the full name of the month
 we need four uppercase Ms — like we looked at earlier .
 So here ,
 we will add one more `M`
 and hit _Enter_ ,
 and there we go . Now it says _June_ .
 But it still doesn't say day .
 The day is missing from the resulting string ,
 so if we scroll down to the `DAY` section ,
 we have a couple different options :
 
 `dd`       `14`
 
 To get the day of the month as a number,
 a single `d` will use just _1_ — in case it is a single digit number .
 And if we use _two lowercase ds_ , it uses _01_ .
 So , let’s go with the two lowercase .
 We are going to make an assumption here about
 how single digit numbers are represented ,
 so after the four uppercase Ms , we'll put two lowercase ds .
 
 `MMMM dd yyyy`
 
 Once that is done ,
 we also need a comma right after the day representation .
 
 `MMMM dd , yyyy`
 
 Because that is actually part of how our date is formatted in the JSON structure .
 And then if we hit _Enter_ ,
 you will see that now the text representation
 of parsing and converting this date
 using our format string
 is identical .
 Which means
 this is the format being used by the JSON value .
 So we'll copy this format string
 and go back to the playground .
 We can now specify this format
 by assigning it as a `String` to
 the `dateFormat` property
 on the `dateFormatter` instance we created :
 */

let decoder = JSONDecoder()
decoder.keyDecodingStrategy = .convertFromSnakeCase

let dateFormatter = DateFormatter()
dateFormatter.dateFormat = "MMMM dd, yyyy"

/**
 Now that this `DateFormatter` object
 knows about the date format ,
 we can pass it along to the `Decoder` object to use :
 */

decoder.dateDecodingStrategy = .formatted(dateFormatter)

/**
 `NOTE` :
 Remember there is an enum case for this , `.formatted` ,
 and it takes a `DateFormatter` — `dateFormatter`.
 
 Okay ,
 once the playground figures things out ,
 there we go ...
 */

let book = try decoder.decode(Book.self , from : json)
book.publishDate // "Jun 26, 1997 at 12:00 AM"

/**
 ... the date is being passed correctly ,
 the date object here specifies , `June 26, 1997` .
 
 `NOTE` : Our format string
 and our date value in the JSON
 
 `let json = """`
 `{`
     `"title" : "Harry Potter and the sorcerer's stone" ,`
     `"url" : "https:\\/\\/openlibrary.org\\/books\\/OL26331930M\\/Harry_Potter_and_the_sorcerer’s_stone" ,`
     `"publish_date" : "June 26, 1997" ,`
     `"text" : "Once upon a time ." ,`
     `"rating" : 4.9`
 `}`
 `""".data(using: .utf8)!`
 
 does not specify a time .
 So , the `Date` type defaults this to the start of the day .
 Pretty cool , right ?
    By specifying a decoding strategy
 and using a formatter ,
 we can take date strings in JSON
 and convert them to more type-safe date object in our model ,
 which is always a delight .
 No stringly type code means no errors .
 */


/**
 In the next video ,
 let's talk about three more things :
 URLs ,
 data ,
 and floating point numbers .
 */
/**
 `ASIDE`:
 As an aside ,
 the little exercise we did
 of matching up the characters to get the right format string ,
 you won't have to do to that realistically .
 APIs — good APIs at least — will always indicate which date format string they use ,
 and they'll provide that format string if it is anything that is not a standard .
 */



/* CODE OVERVIEW :
 
 let json = """
 {
    "title" : "Harry Potter and the sorcerer's stone",
    "url" : "https:\\/\\/openlibrary.org\\/books\\/OL26331930M\\/Harry_Potter_and_the_sorcerer's_stone",
    "publish_date" : "June 26, 1997",
    "text" : "Once upon a time .",
    "rating" : 4.9
 }
 """.data(using: .utf8)!

 
 struct Book: Codable {
 
    let title: String
    let url: String
    let publishDate: Date
 }
 
 
 let decoder = JSONDecoder()
 decoder.keyDecodingStrategy = .convertFromSnakeCase
 // decoder.dateDecodingStrategy = .iso8601
 let dateFormatter = DateFormatter()
 dateFormatter.dateFormat = "MMMM dd, yyyy"
 decoder.dateDecodingStrategy = .formatted(dateFormatter)
 
 
 let book = try! decoder.decode(Book.self, from: json)
 book.title
 book.url
 book.publishDate // returns "Jun 26, 1997 at 12:00 AM"
 book.publishDate < Date() // false
 */
 
