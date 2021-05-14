import Foundation


/**
 `2 Parsing Data`
 There are two more cases we have to look at .
 */

let json = """
{
   "title" : "Harry Potter and the sorcerer's stone" ,
   "url" : "https:\\/\\/openlibrary.org\\/books\\/OL26331930M\\/Harry_Potter_and_the_sorcerer's_stone" ,
   "publish_date" : "June 26, 1997" ,
   "text" : "VGhpcyBpc24ndCByZWFsbHkgdGhlIGNvbnRlbnRzIG9mIHRoZSBib29r" ,
   "rating" : 4.9
}
""".data(using: .utf8)!


/*
 struct Book: Codable {
 
    let title: String
    let url: URL
    let publishDate: Date
 }
*/


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

let book = try! decoder.decode(Book.self , from : json)
book.publishDate

let encoder = JSONEncoder()
try encoder.encode(book)

/**
 In our JSON we have a key named `"text"` ,
 with some value as a `String` :

`let json = """`
`{`
 `"title" : "Harry Potter and the sorcerer's stone",`
 `"url" : "https:\\/\\/openlibrary.org\\/books\\/OL26331930M\\/Harry_Potter_and_the_sorcerer's_stone",`
 `"publish_date" : "June 26, 1997",`
 `"text" : "VGhpcyBpc24ndCByZWFsbHkgdGhlIGNvbnRlbnRzIG9mIHRoZSBib29r",`
 `"rating" : 4.9`
`}`
`""".data(using: .utf8)!`

If you haven’t worked with JSON much ,
this is a base `64 encoded String` .
To keep things simple ,
`base 64` is a way of encoding data — any data — into a `String` format .
In JSON , it is a fairly common to encode large data this way ,
for example , images may be send as `base 64 encoded String`
since JSON does not support an image file .
In this sample ,
the `base 64 String` is simply a `String` that I encoded .
Let’s look at how we could decode it . So , first ,
we add the property to our model :
*/

/*
 struct Book: Codable {
 
    let title: String
    let url: URL
    let publishDate: Date
    private let text: Data
 }
 */

/**
I am adding this as a `private` property
to show an example of where
— even though we are able to decode a `base 64 encoded String`
and parse it into data —
we may not want to expose it as data at any call site ,
and we may want a more readable representation .
Assuming this property refers to the contents of the book ,
we may want to display the contents on screen as a `String` .
For that reason
we can keep the actual data private
and expose the `String` via a computed property :
*/


struct Book: Codable {

    let title: String
    let url: URL
    let publishDate: Date
    private let text: Data


    var contents: String {

        return text.stringDescription
    }
}

/**
Again `stringDescription` is a computed property I have defined earlier .

`extension Data {`
  
  `var stringDescription: String {`
      
      `return String(data : self ,`
                    `encoding : .utf8)!`
  `}`
`}`

Back to the problem at hand ,
we didn’t have to do anything additional to get the code working .
If we go down here , and inspect the content’s property :
*/

// book.text // 'text' is inaccessible due to 'private' protection level
book.contents // "This isn't really the contents of the book"

/**
 You will see a decoded String in the results area , automatically .
    Similar to how decoders define a `dateDecodingStrategy` ,
 we can provide a `dataDecodingStrategy` as well .
 The reason we didn’t have to do any additional work
 and define a `dataDecodingStrategy` , is ,
 because by default that strategy is `base 64` .
 If you wanted to explicitly inform the decode of that , you would say :
 */

decoder.dataDecodingStrategy = .base64

/**
 Which is the same thing .
 
 `NOTE` :
 You can also provide a custom data decoder ,
 but that is beyond my knowledge .
 I have only ever encountered base 64 data in the APIs I have worked with .
 */
