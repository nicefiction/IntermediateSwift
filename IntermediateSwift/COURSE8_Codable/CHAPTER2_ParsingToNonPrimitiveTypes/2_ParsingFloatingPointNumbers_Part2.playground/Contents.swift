import Foundation


/**
 `2 Parsing Floating Point Numbers`: PART 2 OF 2
 The second thing you need to be aware of , is ,
 the absence of a value .
 So , let’s say that we have this book API ,
 and a brand new book entry has been added .
 One without any ratings .
 Or even more complicated .
 Let’s say this rating value is computed somehow in our backend .
 */

let json1 = """
{
   "title" : "Harry Potter and the sorcerer's stone" ,
   "url" : "https:\\/\\/openlibrary.org\\/books\\/OL26331930M\\/Harry_Potter_and_the_sorcerer's_stone" ,
   "publish_date" : "June 26, 1997" ,
   "text" : "VGhpcyBpc24ndCByZWFsbHkgdGhlIGNvbnRlbnRzIG9mIHRoZSBib29r" ,
   "rating" : 1.0E2
}
""".data(using: .utf8)!

/**
 Well , in such a case ,
 we may run into an error where there is nothing to compute from .
 There is no base values in a brand new book .
 So , in that case ,
 _what do we expect the value of reading to be in a JSON response ?_
 One situation is that the rating key might not be present .
 And we haven’t figured out to tackle that one , just yet .
 We will though . But ,
 the easiest way would be to model `rating` as a `Double` value ,
 so we can assign `nil` to it .
 Now , both of those things are true and possible ,
 but there does exist a third possibility where the key is still present in the JSON
 but the value is not something we expect .
 In JavaScript — and thereby JSON —
 we can represent the absence of a value
 in one of three ways :
 (`1`) As a `NaN` value —which stands for _Not a Number_ — ,
 (`2`) as `positive infinity` ,
 or (`3`) as `negative infinity` . I
 n such cases ,
 the JSON data would include a `String` that reads `Not a Number` .
 Exactly like this ,
 */

let json2 = """
{
   "title" : "Harry Potter and the sorcerer's stone" ,
   "url" : "https:\\/\\/openlibrary.org\\/books\\/OL26331930M\\/Harry_Potter_and_the_sorcerer's_stone" ,
   "publish_date" : "June 26, 1997" ,
   "text" : "VGhpcyBpc24ndCByZWFsbHkgdGhlIGNvbnRlbnRzIG9mIHRoZSBib29r" ,
   "rating" : "NaN"
}
""".data(using: .utf8)!



struct Book: Codable {
    
     // /////////////////
    //  MARK: PROPERTIES

    let title: String
    let url: URL
    let publishDate: Date
    private let text: Data
    let rating: Double // ⭐️


     // //////////////////////////
    //  MARK: COMPUTED PROPERTIES
    
    var contents: String {

        return text.stringDescription
    }
}



extension Data {
    
    var stringDescription: String {
        
        return String(data : self ,
                      encoding : .utf8)!
    }
}


let decoder = JSONDecoder()
let dateFormatter = DateFormatter()
dateFormatter.dateFormat = "MMMM dd, YYYY"

decoder.keyDecodingStrategy = JSONDecoder.KeyDecodingStrategy.convertFromSnakeCase
decoder.dateDecodingStrategy = JSONDecoder.DateDecodingStrategy.formatted(dateFormatter)
decoder.dataDecodingStrategy = JSONDecoder.DataDecodingStrategy.base64

/*
 let book = try! decoder.decode(Book.self , from : json2) // ERROR : Execution was interrupted, reason: EXC_BAD_INSTRUCTION (code=EXC_I386_INVOP, subcode=0x0).
 book.publishDate

 
 let encoder = JSONEncoder()
 try encoder.encode(book)
 
 book.rating
 */
/* ERROR
 
 Fatal error: 'try!' expression unexpectedly raised an error: Swift.DecodingError.typeMismatch(Swift.Double, Swift.DecodingError.Context(codingPath: [CodingKeys(stringValue: "rating", intValue: nil)], debugDescription: "Expected to decode Double but found a string/data instead.", underlyingError: nil)): file __lldb_expr_174/2_ParsingFloatingPointNumbers_Part2.playground, line 107
 */

/**
 When a value is missing .
 We need to provide the decoder — in such a case — with information ,
 so that , if this occurs , we don’t get the error that we are currently getting ,
 and we can handle it gracefully .
 Rather than store this as a `String` value ,
 we want the `decoder` to convert this to Swift’s NAN representation .
 Which is defined on the `Float` type .
 They way we do that , is ,
 by specifying a non conforming `Float` decoding strategy .
 
 `NOTE` :
 Now , at this point , we are maybe getting into the weeds here .
 You might not have to do this often ,
 but it is good to know .
 
 So , we are going to do :
 */

decoder.nonConformingFloatDecodingStrategy = .convertFromString(positiveInfinity : "+infinity" ,
                                                                negativeInfinity : "-infinity" ,
                                                                nan : "NaN")

/**
 The default for the `nonConformingFloatDecodingStrategy` property is
 `.throw` — OLIVIER : OPTION click on `nonConformingFloatDecodingStrategy` .
 Which means
 when the decoder encounters a `nonConformingFloatDecodingValue` ,
 it will throw an error ,
 which is exactly what is happening now .
 So instead ,
 we are going to assign the case `.convertFromString` .
 So , we are going to say ,
 if you are expecting a `Double` value where you encounter a `String` ,
 we want you to convert from a `String` ,
 and these are the strings we expect :
 
 `positiveInfinity : "+infinity"`
 `negativeInfinity : "-infinity"`
 `nan : "NaN"`
 
 And now ,
 when we do that ,
 things work again .
 */

let book = try decoder.decode(Book.self , from : json2)
book.rating // nan

/**
 So here ,
 we are specifying
 that these are the strings
 
 `positiveInfinity : "+infinity"`
 `negativeInfinity : "-infinity"`
 `nan : "NaN"`
 
 that the API we are working with
 will return for this corresponding absence values ,
 right , for nothingness .
 If you go down the results area now ,
 
 `book.rating // nan`
 
 you see that rating has been converted to
 a Swift representation of `Not A Number` ,
 instead of storing this as a `String` .
 
 `NOTE` :
 Whether this is how you actually want to model your data ,
 is a completely different story .
 But , in this way ,
 you can handle edge cases introduced by floating point numbers .
 */





/* CODE OVERVIEW :
 
 let json2 = """
 {
    "title" : "Harry Potter and the sorcerer's stone" ,
    "url" : "https:\\/\\/openlibrary.org\\/books\\/OL26331930M\\/Harry_Potter_and_the_sorcerer's_stone" ,
    "publish_date" : "June 26, 1997" ,
    "text" : "VGhpcyBpc24ndCByZWFsbHkgdGhlIGNvbnRlbnRzIG9mIHRoZSBib29r" ,
    "rating" : "NaN"
 }
 """.data(using: .utf8)!



 struct Book: Codable {
     
      // /////////////////
     //  MARK: PROPERTIES

     let title: String
     let url: URL
     let publishDate: Date
     private let text: Data
     let rating: Double


      // //////////////////////////
     //  MARK: COMPUTED PROPERTIES
     
     var contents: String {

         return text.stringDescription
     }
 }



 extension Data {
     
     var stringDescription: String {
         
         return String(data : self ,
                       encoding : .utf8)!
     }
 }

 

 let decoder = JSONDecoder()
 let dateFormatter = DateFormatter()
 dateFormatter.dateFormat = "MMMM dd, YYYY"

 decoder.keyDecodingStrategy = JSONDecoder.KeyDecodingStrategy.convertFromSnakeCase
 decoder.dateDecodingStrategy = JSONDecoder.DateDecodingStrategy.formatted(dateFormatter)
 decoder.dataDecodingStrategy = JSONDecoder.DataDecodingStrategy.base64
 decoder.nonConformingFloatDecodingStrategy = .convertFromString(positiveInfinity : "+infinity" ,
                                                                 negativeInfinity : "-infinity" ,
                                                                 nan : "NaN")
 
 book.rating
 */





/**
 Let’s take a break here .
 Now we know how to do basic encoding and decoding ,
 and how to allow the decoder to do some additional work for us .
 Over the next few videos ,
 we are going to step things up ,
 and look a few more complicated situations .
 */
