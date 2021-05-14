import Foundation


/**
 `2 Parsing URLs , Data , and Floating Point Numbers`
 INTRO — Similar to how we decoded dates ,
 in this video
 let's take a look at
 how a decoder
 can automatically handle
 URLs ,
 data ,
 and floating point numbers .
 */

let json = """
{
   "title" : "Harry Potter and the sorcerer's stone",
   "url" : "https:\\/\\/openlibrary.org\\/books\\/OL26331930M\\/Harry_Potter_and_the_sorcerer's_stone",
   "publish_date" : "June 26, 1997",
   "text" : "Once upon a time",
   "rating" : 4.9
}
""".data(using: .utf8)!

/*
 struct Book: Codable {
 
    let title: String
    let url: String
    let publishDate: Date
 }
 */

let decoder = JSONDecoder()
let dateFormatter = DateFormatter()
dateFormatter.dateFormat = "MMMM dd, YYYY"

decoder.keyDecodingStrategy = JSONDecoder.KeyDecodingStrategy.convertFromSnakeCase
decoder.dateDecodingStrategy = JSONDecoder.DateDecodingStrategy.formatted(dateFormatter)

let book = try decoder.decode(Book.self , from : json)
book.publishDate

let encoder = JSONEncoder()
try encoder.encode(book)

/**
 In the last video we refactored our type
 to store an actual `Date` object
 instead of a `String` representing a date .
 Stringly typed code is really bad .
 By eliminating room for error
 — particularly when using the date —
 we will have much safer code .
 There are still other properties that are unnecessary represented by primitive type
 when we could do much better .
 At the moment we are decoding and storing the url as a `String` .
 
 `let url: String`
 
 But ultimately — when we use the information —
 we will want that to be a URL where we can fetch additional data from .
 Fortunately we don’t really have to do any work here
 because URL encoding and decoding works right out of the box .
 All we need to do , is , change the stored property’s type
 — so the type on the URL property here —
 to the native `URL` instead of `String` .
 And the decoder should handle the rest with no additional work :
 */

struct Book: Codable {

   let title: String
   // let url: String
    let url: URL
   let publishDate: Date
}

/**
 Okay , so just remember ,
 when implementing `Codable` for your own types .
 Don’t store URLs and dates as strings .
 With very little additional work ,
 the decoder can handle the work of converting this information
 into a more type safe representation ,
 leaving you with safer code.
 */
