import Foundation


/**
 `3 List of Objects`
 INTRO — JSON objects aren't restricted to
 containing a single payload of information
 and can encapsulate several objects
 by means of an `array` .
 In this video
 we look at
 how we can decode a list of `JSON objects`
 into an `array` of `Codable` conforming types .
 */
/**
 Let's continue to build on our example
 to make this a tiny bit more complicated
 and a bit more realistic .
 In the notes section of this video ,
 I have included a link to an updated sample of this JSON .
 Paste that in ,
 in place of this existing string literal :
 */

let json = """
{
    "work" : {

        "id" : 2422333 ,
        "books_count" : 222 ,
        "ratings_count" : 860687 ,
        "text_reviews_count" : 37786 ,
        "best_book" : {
            "id" : 375802 ,
            "title" : "Ender's Game (Ender's Saga, #1)" ,
            "author" : {
                "id" : 589 ,
                "name" : "Orson Scott Card"
            }
        } ,
        "candidates" : [
            {
                "id" : 44687 ,
                "title" : "Enchanters' End Game (The Belgariad, #5)" ,
                "author" : {
                    "id" : 8732 ,
                    "name" : "David Eddings"
                }
            } ,
            {
                "id" : 22874150 ,
                "title" : "The End Game" ,
                "author" : {
                    "id" : 6876994 ,
                    "name" : "Kate McCarthy"
                }
            } ,
            {
                "id" : 7734468 ,
                "title" : "Ender's Game: War of Gifts" ,
                "author" : {
                    "id" : 236462 ,
                    "name" : "Jake Black"
                }
            }
        ]

    }
}
""".data(using: .utf8)!

/**
 So , I have added a new key to the dictionary ,
 named `"candidates"` ,
 that includes information about other search results `"candidates"`
 that are not the "best_book" listed above .
 The difference here , is ,
 that when you query the key `"candidates"` ,
 the value is an array ,
 which then contains several dictionaries ,
 each of which represents a valid `Book` and an `Author` instance .
 While this seems complicated ,
 there is a lot going on here ,
 we have an array ,
 nested dictionaries,
 and then further nested dictionaries .
 We can actually model this in our type without much additional work .
 So , going back to the `SearchResult` type ,
 let's add a stored property to define this :
 */

struct SearchResult {
    
    // MARK: NESTED TYPES
    
    enum OuterCodingKeys: String ,
                          CodingKey {
        case work
    }
    
    
    enum InnerCodingKeys: String ,
                          CodingKey {
        case id
        case booksCount
        case ratingsCount
        case textReviewsCount
        case bestBook
        case candidates // ☘️
    }
    
    
    struct Author: Codable {
        
        let id: Int
        let name: String
    }
    
    
    struct Book: Codable {
        
        let id: Int
        let title: String
        let author: Author
    }
    
    
    
    // MARK: PROPERTIES
    
    let id: Int
    let booksCount: Int
    let ratingsCount: Int
    let textReviewsCount: Int
    let bestBook: Book
    let candidates: [Book] // ☘️
}

/**
 Again , the key to properly doing this , is ,
 understanding that our best bet is
 matching the JSON structure as closely as possible .
 We already know
 that if we have a nested dictionary containing `Book` and `Author` data ,
 the `Book` type and then the` Author` type can handle that decoding itself .
 So , we don't need to worry about that part .
 The only new thing here , is ,
 that the three dictionaries are inside an array ,
 so we need to model it as an array of books .
 So again , back to the `InnerCodingKeys enum` ,
 we need to add an enum member to the keys types .
 
 `case candidates`
 
 And then , in the `init()` method , ...
 */


// MARK: EXTENSIONS

extension SearchResult: Decodable {
    
    init(from decoder: Decoder)
    throws {
        
        let outerContainer = try decoder.container(keyedBy : OuterCodingKeys.self)
        let innerContainer = try outerContainer.nestedContainer(keyedBy : InnerCodingKeys.self ,
                                                                forKey : OuterCodingKeys.work)
        
        self.id               = try innerContainer.decode(Int.self    , forKey : InnerCodingKeys.id)
        self.booksCount       = try innerContainer.decode(Int.self    , forKey : InnerCodingKeys.booksCount)
        self.ratingsCount     = try innerContainer.decode(Int.self    , forKey : InnerCodingKeys.ratingsCount)
        self.textReviewsCount = try innerContainer.decode(Int.self    , forKey : InnerCodingKeys.textReviewsCount)
        self.bestBook         = try innerContainer.decode(Book.self   , forKey : InnerCodingKeys.bestBook)
        self.candidates       = try innerContainer.decode([Book].self , forKey : InnerCodingKeys.candidates) // ☘️
    }
}

/**
 ... instead of asking the decoder to decode this into a single instance of `Book` ,
 we'll specify an array of books .
 If this seems weird ,
 remember that an array of `Book` is a valid type .
 So , we are not doing anything wildly different here .
 We can inspect this new property ,
 */

let decoder: JSONDecoder = JSONDecoder()
decoder.keyDecodingStrategy = .convertFromSnakeCase

let searchResult = try decoder.decode(SearchResult.self , from : json)
print(searchResult.candidates.count) // prints 3

/**
 Look at that , done .
 You'll often run into arrays
 containing dictionaries worth of information .
 When you do ,
 now you know that an implementation
 allowing for the decoder to do much of the work ,
 takes only a few lines of code .
 */
/**
 `ASIDE `:
 Now a little bit of extra as to what is going on behind the scenes .
 So , when you call
 
 `self.candidates = try innerContainer.decode([Book].self , forKey : InnerCodingKeys.candidates) // ☘️`
 
 what the decoder does , is ,
 it creates an _unkeyed container_ , right ?
 There are no keys in an `Array`, just index values .
 So , it would be something like calling
 
 `try innerContainer.nestedUnkeyedContainer(forKey: .candidates)`
 
 And then,
 it would iterate through all of those
 — and we will look at how that happens in the future —
 but it would iterate through all of those ,
 and for each dictionary
 at each index value ,
 it is going to hand it off to the`Book` type
 which will decode it
 and come back eventually with an array result .
 */
/**
 What else ?
 So , the encoding bit is also handled automatically for us .
 Once we go in here , we just have to write one line of code :
 */

extension SearchResult: Encodable {
    
    func encode(to encoder: Encoder)
    throws {
        
        var outerContainer = encoder.container(keyedBy : OuterCodingKeys.self)
        var innerContainer = outerContainer.nestedContainer(keyedBy : InnerCodingKeys.self ,
                                                            forKey : OuterCodingKeys.work)
        
        try innerContainer.encode(id , forKey : InnerCodingKeys.id)
        try innerContainer.encode(booksCount , forKey : InnerCodingKeys.booksCount)
        try innerContainer.encode(ratingsCount , forKey : InnerCodingKeys.ratingsCount)
        try innerContainer.encode(textReviewsCount , forKey : InnerCodingKeys.textReviewsCount)
        try innerContainer.encode(candidates , forKey : InnerCodingKeys.candidates) // ☘️
    }
}


extension Data {
    
    var stringDescription: String {
        
        return String(data : self ,
                      encoding : .utf8)!
    }
}

/**
 And again , here ,
 it is going to create a nested unkeyed container .
 And if you look at our JSON string down here in the console ,
 */

let encoder: JSONEncoder = JSONEncoder()
let encodedSearchResult = try encoder.encode(searchResult)

print(encodedSearchResult.stringDescription)
// prints {"work":{"textReviewsCount":37786,"id":2422333,"candidates":[{"id":44687,"title":"Enchanters' End Game (The Belgariad, #5)","author":{"id":8732,"name":"David Eddings"}},{"id":22874150,"title":"The End Game","author":{"id":6876994,"name":"Kate McCarthy"}},{"id":7734468,"title":"Ender's Game: War of Gifts","author":{"id":236462,"name":"Jake Black"}}],"ratingsCount":860687,"booksCount":222}}

/**
 We have the `"candidates"` key right at the top here ,
 
 `"candidates":[{"id":44687,"title":"Enchanters' End Game (The Belgariad, #5)","author":{"id":8732,"name":"David Eddings"}},{"id":22874150,"title":"The End Game","author":{"id":6876994,"name":"Kate McCarthy"}},{"id":7734468,"title":"Ender's Game: War of Gifts","author":{"id":236462,"name":"Jake Black"}}]`
 
 and you will notice that there is an array at the top ,
 and then each value is a dictionary :
 
 `{"id":44687,"title":"Enchanters' End Game (The Belgariad, #5)","author":{"id":8732,"name":"David Eddings"}}`
 */
/**
 You can encounter information
 encoded in a combination of dictionaries and arrays in many ways .
 But as I mentioned earlier ,
 the important part , is ,
 modelling it just as the JSON is .
 And you shouldn't have much difficulty parsing it .
 For example ,
 let's go back up to the top here ,
 grab everything from the `"candidates"` key-value pair ,
 all the way to the bottom where the array ends .
 And then , at the very end ,
 we'll just put this in its own JSON string here :
 */

let jsonCandidates = """
{
    "candidates" : [
        {
            "id" : 44687 ,
            "title" : "Enchanters' End Game (The Belgariad, #5)" ,
                "author" : {
                    "id" : 8732 ,
                    "name" : "David Eddings"
                }
            } ,
        {
            "id" : 22874150 ,
            "title" : "The End Game" ,
            "author" : {
                "id" : 6876994 ,
                "name" : "Kate McCarthy"
            }
        } ,
        {
            "id" : 7734468 ,
            "title" : "Ender's Game: War of Gifts" ,
            "author" : {
                "id" : 236462 ,
                "name" : "Jake Black"
            }
        }
    ]
}
""".data(using : .utf8)

/**
 `NOTE` : Remember , multi-line string literal . Also ,
 you need to start with an opening brace for a dictionary ,
 then a key .
 
 Now , if we wanted to parse this blob of JSON
 into an array of books ,
 without worrying about nested keyed containers and unkeyed containers .
 Again , the way here ,
 so notice here that we sort of have a wrapper key — OLIVIER: `"candidates"`.
 So , the information is an array of books , which is the value .
 And then , we have a key to get to that ,
 
 `"candidates"`
 
 and if we wanted to decode this directly
 — again a combination of a dictionary and an array of dictionaries —
 we would say ,
 */

let decodedCandidates = try decoder.decode([String : [SearchResult.Book]].self ,
                                           from : jsonCandidates!) // "candidates": [{…}, {…}, {…}]]
/**
 Again , remember ,
 we are modelling it exactly like the JSON is ,
 which is a `Dictionary` with a key as a `String` .
 And the value is an `Array` of books .
 And then on that entire type , we call `.self` , using `jsonCandidates` .
 Okay , and when you do that ,
 you'll see here that we have a `Dictionary` that has a key `"candidates"` ,
 
 `"candidates": [{…}, {…}, {…}]]`

 and then an `Array` of books in there .
 The type here , is ,
 ( a `Dictionary` of ) `String` to an `Array` of books ,
 
 `[String : [SearchResult.Book]]`

 So , it is important to get that part right .
 Resemble the JSON as much as possible .
 
 
 
 Okay , let's wrap it up here .
 In the next video ,
 we'll look at
 what happens when data is potentially missing .
 */
