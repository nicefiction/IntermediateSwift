import Foundation


/**
 `4 Missing Data`: PART 2 OF 4
 And now ,
 if we go up to the top ,
 and change the `"popularity"` value to `null` ,
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
}



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
    }
}



let decoder: JSONDecoder = JSONDecoder()
decoder.keyDecodingStrategy = .convertFromSnakeCase

let searchResult = try decoder.decode(SearchResult.self , from : json)
print(searchResult.candidates.count)



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
        try innerContainer.encode(bestBook , forKey : InnerCodingKeys.bestBook)
        try innerContainer.encode(candidates , forKey : InnerCodingKeys.candidates)
        try innerContainer.encode(popularity , forKey : InnerCodingKeys.popularity)
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
encoder.outputFormatting = .prettyPrinted

let encodedSearchResult2 = try encoder.encode(searchResult)
print(encodedSearchResult2.stringDescription)

/**
 you can see that this still works ,
 the playground still compiles .
 */

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
     "popularity" : null,
     "books_count" : 222
   }
 }
 */

/**
 If we go down to the instance of `SearchResult` that we are creating ,
 I can query the property ,
 */

searchResult.popularity // nil

/**
 And then at the very bottom in the JSON string that we are outputting in the console ,
 it also says `null` :
 
 `"popularity" : null,`
 
 So if you have values that are occasionally `nil` ,
 you can use optional properties to model them .
 */
/**
👉 Continues in PART 3
*/
