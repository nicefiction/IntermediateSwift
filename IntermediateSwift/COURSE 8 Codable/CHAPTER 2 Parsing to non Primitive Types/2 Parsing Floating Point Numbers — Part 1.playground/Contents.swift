import Foundation


/**
 `2 Parsing Floating Point Numbers`: PART 1 of 2
 Okay , the last property we need to model , is , the rating for the book .
 So , let’s go back up to the type ,
 and we add that in as a `Double` value .
 */

/*
let json = """
{
   "title" : "Harry Potter and the sorcerer's stone" ,
   "url" : "https:\\/\\/openlibrary.org\\/books\\/OL26331930M\\/Harry_Potter_and_the_sorcerer's_stone" ,
   "publish_date" : "June 26, 1997" ,
   "text" : "VGhpcyBpc24ndCByZWFsbHkgdGhlIGNvbnRlbnRzIG9mIHRoZSBib29r" ,
   "rating" : 4.9
}
""".data(using: .utf8)!
*/


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


/*
let decoder = JSONDecoder()
let dateFormatter = DateFormatter()
dateFormatter.dateFormat = "MMMM dd, YYYY"

decoder.keyDecodingStrategy = JSONDecoder.KeyDecodingStrategy.convertFromSnakeCase
decoder.dateDecodingStrategy = JSONDecoder.DateDecodingStrategy.formatted(dateFormatter)
decoder.dataDecodingStrategy = JSONDecoder.DataDecodingStrategy.base64

let book = try! decoder.decode(Book.self , from : json)
book.publishDate

let encoder = JSONEncoder()
try encoder.encode(book)
 */

/**
 And done .
 We can now inspect the property down here ,
 */

// book.rating // 4.9

/**
 and you will see that this works .
 So , what is all the fuss about ?
 Well ,
 with Doubles ,
 with floating point numbers ,
 there is no fuss really .
 Except that you should be aware of two things .
 The JSON spec allows you to define numbers in more than one way .
 So , for example ,
 let’s assume that this rating was 100 :
 */

let json = """
{
   "title" : "Harry Potter and the sorcerer's stone" ,
   "url" : "https:\\/\\/openlibrary.org\\/books\\/OL26331930M\\/Harry_Potter_and_the_sorcerer's_stone" ,
   "publish_date" : "June 26, 1997" ,
   "text" : "VGhpcyBpc24ndCByZWFsbHkgdGhlIGNvbnRlbnRzIG9mIHRoZSBib29r" ,
   "rating" : 100
}
""".data(using: .utf8)!

/**
 We can specify this value of one hundred as
 100 ,
 100.0 — in decimal notation — ,
 or we can also do 1.0E+2 — which is exponent notation — ,
 or 1E+2 .
 And all of this ,
 gets parsed as 100 correctly ,
 as you can see down here :
 */

let decoder = JSONDecoder()
let dateFormatter = DateFormatter()
dateFormatter.dateFormat = "MMMM dd, YYYY"

decoder.keyDecodingStrategy = JSONDecoder.KeyDecodingStrategy.convertFromSnakeCase
decoder.dateDecodingStrategy = JSONDecoder.DateDecodingStrategy.formatted(dateFormatter)
decoder.dataDecodingStrategy = JSONDecoder.DataDecodingStrategy.base64

let book = try! decoder.decode(Book.self , from : json)
book.publishDate

let encoder = JSONEncoder()
try encoder.encode(book)



book.rating // 100

/**
👉 Continues in PART 2
*/
