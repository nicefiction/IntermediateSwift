import Foundation


/**
 `4 Missing Data`: PART 3 of 4
 There is one more situation we need to take in to account though .
 In some APIs
 when values are `null` ,
 instead of indicating `null` ,
 the entire key value pair could be missing from the JSON altogether .
 So , let's modify the json again :
 */

/*
let json = """
{
    "work" : {

        "id" : 2422333 ,
        "popularity" : null ,
        "sponsor" : "Some Publisher Inc",
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
 */
let json = """
{
    "work" : {

        "id" : 2422333 ,
        "popularity" : null ,
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
 In this case ,
 we'll pretend that some search results are sponsored .
 And when they are ,
 the json contains a key value pair
 — a `"sponsor"` key
 where the string value is indicating who the sponsor is .
 Okay , to model this ,
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
        case candidates
        case popularity
        case sponsor // ☘️
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
    let candidates: [Book]
    let popularity: Double?
    let sponsor: String? // ☘️
}


/*
extension SearchResult: Decodable {
    
    init(from decoder: Decoder)
    throws {
        
        let outerContainer = try decoder.container(keyedBy : OuterCodingKeys.self)
        let innerContainer = try outerContainer.nestedContainer(keyedBy : InnerCodingKeys.self ,
                                                                forKey : OuterCodingKeys.work)
        
        self.id               = try innerContainer.decode(Int.self     , forKey : InnerCodingKeys.id)
        self.booksCount       = try innerContainer.decode(Int.self     , forKey : .booksCount)
        self.ratingsCount     = try innerContainer.decode(Int.self     , forKey : .ratingsCount)
        self.textReviewsCount = try innerContainer.decode(Int.self     , forKey: .textReviewsCount)
        self.bestBook         = try innerContainer.decode(Book.self    , forKey : .bestBook)
        self.candidates       = try innerContainer.decode([Book].self  , forKey : .candidates)
        self.popularity       = try innerContainer.decode(Double?.self , forKey : InnerCodingKeys.popularity)
        self.sponsor          = try innerContainer.decode(String?.self  , forKey : InnerCodingKeys.sponsor) // ☘️
    }
}
 */

/**
 Okay ,
 now we'll go back down to our instance result ,
 and inspect the values ,
 */

/*
let decoder: JSONDecoder = JSONDecoder()
decoder.keyDecodingStrategy = .convertFromSnakeCase

let searchResult = try decoder.decode(SearchResult.self , from : json)
searchResult.sponsor) // Some Publisher Inc
 */

/**
 Cool , but I did say that in some cases
 this key value pair is missing from the JSON all together .
 So , lets get rid of the "sponsor" key value pair ,
 and see what happens .
 When we do this ,
 predictably , the playground should crash , ...
 */

/* ERROR :
 
 Playground execution terminated: An error was thrown and was not caught:
 ▿ DecodingError
   ▿ keyNotFound : 2 elements
     - .0 : InnerCodingKeys(stringValue: "sponsor", intValue: nil)
     ▿ .1 : Context
       - codingPath : 0 elements
       - debugDescription : "No value associated with key InnerCodingKeys(stringValue: \"sponsor\", intValue: nil) (\"sponsor\")."
       - underlyingError : nil
 */

/**
 ... because the decoder is looking for a key named `"sponsor"` , and not finding it .
 Yes , this value is an optional , so we could just mark it as `nil`
 but the decoder doesn't know that :
 
 `self.sponsor = try innerContainer.decode(String?.self , forKey : InnerCodingKeys.sponsor)`
 
 It first looks for the key `"sponsor"` ,
 and then attempts to decode a type .
 So it is failing when it looks for the key `"sponsor"` ,
 it doesn't even get to decode it into an optional string .
 The solution to a situation like this
 — where only in some cases is the key present — is ,
 to ask the `decoder` to only decode if the key is present .
 And we indicate that with a simple change ,
 */

extension SearchResult: Decodable {
    
    init(from decoder: Decoder)
    throws {
        
        let outerContainer = try decoder.container(keyedBy : OuterCodingKeys.self)
        let innerContainer = try outerContainer.nestedContainer(keyedBy : InnerCodingKeys.self ,
                                                                forKey : OuterCodingKeys.work)
        
        self.id               = try innerContainer.decode(Int.self             , forKey : InnerCodingKeys.id)
        self.booksCount       = try innerContainer.decode(Int.self             , forKey : InnerCodingKeys.booksCount)
        self.ratingsCount     = try innerContainer.decode(Int.self             , forKey : InnerCodingKeys.ratingsCount)
        self.textReviewsCount = try innerContainer.decode(Int.self             , forKey : InnerCodingKeys.textReviewsCount)
        self.bestBook         = try innerContainer.decode(Book.self            , forKey : InnerCodingKeys.bestBook)
        self.candidates       = try innerContainer.decode([Book].self          , forKey : InnerCodingKeys.candidates)
        self.popularity       = try innerContainer.decode(Double?.self         , forKey : InnerCodingKeys.popularity)
        // self.sponsor          = try innerContainer.decode(String?.self , forKey : InnerCodingKeys.sponsor)
        // self.sponsor          = try innerContainer.decodeIfPresent(String?.self , forKey : InnerCodingKeys.sponsor) // ERROR : Cannot assign value of type 'String??' to type 'String?'
        self.sponsor          = try innerContainer.decodeIfPresent(String.self , forKey : InnerCodingKeys.sponsor)
    }
}

/**
 So instead of calling the `decode()` method on `decoder` — or the container — ,
 we are going to say `decodeIfPresent()` .
 
 `self.sponsor = try innerContainer.decodeIfPresent(String?.self , forKey : InnerCodingKeys.sponsor)`
 
 There is an error here . So , what is going on ?
 
 `// ERROR : Cannot assign value of type 'String??' to type 'String?'`
 
 There is an important difference to keep in mind .
 So , when we do `decodeIfPresent()` ,
 even though `sponsor` is of type optional String ,
 we need to change this to `String.self` :
 
 `self.sponsor = try innerContainer.decodeIfPresent(String.self , forKey : InnerCodingKeys.sponsor)`
 
 And now , it works .
 If we inspect the property ,
 */

let decoder: JSONDecoder = JSONDecoder()
decoder.keyDecodingStrategy = .convertFromSnakeCase

let searchResult = try decoder.decode(SearchResult.self , from : json)
searchResult.sponsor // nil

/**
 Okay , so , the property is an optional string ,
 
 `let sponsor: String?`
 
 but we have to specify the type argument for `decodeIfPresent()` as a non-optional string .
 
 `self.sponsor = try innerContainer.decodeIfPresent(String.self , forKey : InnerCodingKeys.sponsor)`
 
 `decodeIfPresent()` indicates to the `decoder`
 that this type is already an optional
 because if the key isn't present
 than this should be `nil` .
 When we specify the non optional type as an argument ,
 
 `String.self`
 
 the `decoder` requires that the associated stored property
 [ to be ? ] the optional version of the type .
 So , for an example ,
 if I were to go up at the top where the property is declared ,
 and I change `sponsor` to be just a regular `String` :
 
 `struct SearchResult {`
    `...`
    `let sponsor: String`
 `}`
 
 It will fail again ,
 */

/*
 self.sponsor = try innerContainer.decodeIfPresent(String.self , forKey : InnerCodingKeys.sponsor) // ERROR : Value of optional type 'String?' must be unwrapped to a value of type 'String'
 */

/**
 because it says value of optional type `String?` is not unwrapped .
 So , `decodeIfPresent()` ,
 even though we are saying it should be `String.self` ,
 is converting that to an optional .
 [ OLIVIER : So , let’s change that back to let sponsor: String? ]
 Now moreover ,
 the reason it was failing when we said optional `String?.self` ,
 
 `// self.sponsor = try innerContainer.decodeIfPresent(String?.self , forKey : InnerCodingKeys.sponsor) // ERROR : Cannot assign value of type 'String??' to type 'String?'`
 
 is ,
 because the method is already wrapping the type up in an optional .
 When we do this — optional String — what happens , is , it wraps it twice . So now ,
 this return type is _optional optional String_ .
 Which you can see here , in the results area ,
 Cannot assign value of type String with two question marks .
 So , this is obviously not what we want ,
 let me change that back :
 
 `self.sponsor = try innerContainer.decodeIfPresent(String.self , forKey : InnerCodingKeys.sponsor)`
 
 After making this change ,
 you should inspect the property .
 You can inspect the property to see if it is `nil` :
 
 `searchResult.sponsor // nil`
 */
/**
👉 Continues in PART 4
*/
