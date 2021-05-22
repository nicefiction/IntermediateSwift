import Foundation


/**
 `4 Missing Data`: PART 1 OF 4
 INTRO — We have looked at several variations of JSON objects
 but we haven't taken into account the fact that data can be missing .
 In this video , let’s look at
 how we can deal with `null` data
 and missing keys altogether .
 */
/**
 Let's take a look at what happens when keys aren't defined beforehand .
 This is a pretty common occurrence
 and can happen in one of two ways .
 Let's modify our JSON snippet a bit ,
 let's add another key :
 */

let json = """
{
    "work" : {

        "id" : 2422333 ,
        "popularity" : 3.8 ,
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
 Think of `"popularity"` as a way to sort search results .
 Now it doesn't really make sense at the top level , but it works for this lesson , so let’s go with it .
 The thing about this key , is ,
 that we are not always guaranteed a value .
 Sometimes there is a `Double` value .
 Sometimes it just says `null`
 because the API does not have enough information to determine `"popularity"` .
 _So , how should we model this ?_
 Well , the first thing that comes to mind , is ,
 an optional property . So , let's try that :
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
        case popularity // ☘️
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
    let popularity: Double? // ☘️
}

/**
 Next , in the `decode` method ,
 we are going to proceed as normal ,
 except , the difference here , is ,
 we are going to specify the decoded type as an optional Double value :
 */

extension SearchResult: Decodable {
    
    init(from decoder: Decoder)
    throws {
        
        let outerContainer = try decoder.container(keyedBy : OuterCodingKeys.self)
        let innerContainer = try outerContainer.nestedContainer(keyedBy : InnerCodingKeys.self ,
                                                                forKey : OuterCodingKeys.work)
        
        self.id               = try innerContainer.decode(Int.self    , forKey : InnerCodingKeys.id)
        self.booksCount       = try innerContainer.decode(Int.self    , forKey : .booksCount)
        self.ratingsCount     = try innerContainer.decode(Int.self    , forKey : .ratingsCount)
        self.textReviewsCount = try innerContainer.decode(Int.self    , forKey: .textReviewsCount)
        self.bestBook         = try innerContainer.decode(Book.self   , forKey : .bestBook)
        self.candidates       = try innerContainer.decode([Book].self , forKey : .candidates)
        self.popularity       = try innerContainer.decode(Double?.self , forKey : InnerCodingKeys.popularity) // ☘️
    }
}

/**
 Encoding works no differently .
 As you can see ,
 */

let decoder: JSONDecoder = JSONDecoder()
decoder.keyDecodingStrategy = .convertFromSnakeCase

let searchResult = try decoder.decode(SearchResult.self , from : json)
print(searchResult.candidates.count) // 3

/**
 the playground has already compiled
 so things are working .
    Let's add this to the `encode()` function ,
 and here we'll say :
 */

extension SearchResult: Encodable {
    
    func encode(to encoder: Encoder)
    throws {
        
        var outerContainer = encoder.container(keyedBy : OuterCodingKeys.self)
        var innerContainer = outerContainer.nestedContainer(keyedBy : InnerCodingKeys.self ,
                                                            forKey : OuterCodingKeys.work)
        
        try innerContainer.encode(id , forKey : InnerCodingKeys.id)
        try innerContainer.encode(booksCount , forKey : .booksCount)
        try innerContainer.encode(ratingsCount , forKey : .ratingsCount)
        try innerContainer.encode(textReviewsCount , forKey : .textReviewsCount)
        try innerContainer.encode(bestBook , forKey : .bestBook)
        try innerContainer.encode(candidates , forKey : .candidates)
        try innerContainer.encode(popularity , forKey : .popularity) // ☘️
    }
}


extension Data {
    
    var stringDescription: String {
        
        return String(data : self ,
                      encoding : .utf8)!
    }
}



let encoder: JSONEncoder = JSONEncoder()
encoder.keyEncodingStrategy = .convertToSnakeCase

let encodedSearchResult = try encoder.encode(searchResult)
print(encodedSearchResult.stringDescription)

/**
 You can look in the resulting json string
 and see the key and value encoded there :
 */

// prints {"work":{"ratings_count":860687,"text_reviews_count":37786,"id":2422333,"best_book":{"id":375802,"title":"Ender's Game (Ender's Saga, #1)","author":{"id":589,"name":"Orson Scott Card"}},"candidates":[{"id":44687,"title":"Enchanters' End Game (The Belgariad, #5)","author":{"id":8732,"name":"David Eddings"}},{"id":22874150,"title":"The End Game","author":{"id":6876994,"name":"Kate McCarthy"}},{"id":7734468,"title":"Ender's Game: War of Gifts","author":{"id":236462,"name":"Jake Black"}}],"popularity":3.7999999999999998,"books_count":222}}

/**
 `NOTE`
 The difference though between the decimal representation in the original String
 — `"popularity" = 3.8` —
 and how it is encoded here in this String
 — `"popularity":3.7999999999999998`.
 
 `TIP`:
 One thing I totally forgot to show you
 that makes life quite a bit easier , is ,
 a property on the `encoder` .
 The json string we are outputting is getting
 pretty large and nested
 and now it is hard to parse .
 There is no way we can figure out
 what the structure is from this string in the console .
 But we can ask the encoder to `prettyPrinted` it
 by setting the outputFormatting to `.prettyPrinted` :
 */

encoder.outputFormatting = .prettyPrinted

/**
 And when you do that ,
 */

let encodedSearchResult2 = try encoder.encode(searchResult)
print(encodedSearchResult2.stringDescription)

/*
 {
   "work" : {
     "ratings_count" : 860687,
     "text_reviews_count" : 37786,
     "id" : 2422333,
     "best_book" : {
       "id" : 375802,
       "title" : "Ender's Game (Ender's Saga, #1)",
       "author" : {
         "id" : 589,
         "name" : "Orson Scott Card"
       }
     },
     "candidates" : [
       {
         "id" : 44687,
         "title" : "Enchanters' End Game (The Belgariad, #5)",
         "author" : {
           "id" : 8732,
           "name" : "David Eddings"
         }
       },
       {
         "id" : 22874150,
         "title" : "The End Game",
         "author" : {
           "id" : 6876994,
           "name" : "Kate McCarthy"
         }
       },
       {
         "id" : 7734468,
         "title" : "Ender's Game: War of Gifts",
         "author" : {
           "id" : 236462,
           "name" : "Jake Black"
         }
       }
     ],
     "popularity" : 3.7999999999999998,
     "books_count" : 222
   }
 }
 */

/**
 look at the JSON string , much nicer .
 So at the bottom here ,
 
 `"popularity" : 3.7999999999999998,`
 
 we can see the `"popularity" key` and the value that it encodes .
 Okay , this works .
 */
/**
👉 Continues in PART 2
*/
