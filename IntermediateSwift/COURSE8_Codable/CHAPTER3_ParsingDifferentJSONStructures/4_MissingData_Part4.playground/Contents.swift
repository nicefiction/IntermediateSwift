import Foundation


/**
 `4 Missing Data`: PART 4 OF 4
 There is also a counterpart method for the `encoder` that we can use .
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
        case sponsor
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
    let sponsor: String?
}



extension SearchResult: Decodable {
    
    init(from decoder: Decoder)
    throws {
        
        let outerContainer = try decoder.container(keyedBy : OuterCodingKeys.self)
        let innerContainer = try outerContainer.nestedContainer(keyedBy : InnerCodingKeys.self ,
                                                                forKey : OuterCodingKeys.work)
        
        self.id               = try innerContainer.decode(Int.self             , forKey : InnerCodingKeys.id)
        self.booksCount       = try innerContainer.decode(Int.self             , forKey : .booksCount)
        self.ratingsCount     = try innerContainer.decode(Int.self             , forKey : .ratingsCount)
        self.textReviewsCount = try innerContainer.decode(Int.self             , forKey: .textReviewsCount)
        self.bestBook         = try innerContainer.decode(Book.self            , forKey : .bestBook)
        self.candidates       = try innerContainer.decode([Book].self          , forKey : .candidates)
        self.popularity       = try innerContainer.decode(Double?.self         , forKey : InnerCodingKeys.popularity)
        self.sponsor          = try innerContainer.decodeIfPresent(String.self , forKey : InnerCodingKeys.sponsor)
    }
}



let decoder: JSONDecoder = JSONDecoder()
decoder.keyDecodingStrategy = .convertFromSnakeCase

let searchResult = try decoder.decode(SearchResult.self , from : json)
searchResult.sponsor // nil

/**
 So , in the `encode()` method , we'll say
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
        try innerContainer.encode(bestBook , forKey : InnerCodingKeys.bestBook)
        try innerContainer.encode(candidates , forKey : InnerCodingKeys.candidates)
        try innerContainer.encode(popularity , forKey : InnerCodingKeys.popularity)
        try innerContainer.encode(sponsor , forKey: InnerCodingKeys.sponsor) // ☘️
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

let encodedSearchResult = try encoder.encode(searchResult)
print(encodedSearchResult.stringDescription)

/**
 And now
 we can scan our resulting json string at the bottom
 and you should not be able to find a "sponsor" key ,
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
     "sponsor" : null,
     "books_count" : 222
   }
 }
 */

/**
 When you add it — the "sponsor" key — back in , ...
 */

let jsonWithSponsorKey = """
{
    "work" : {

        "id" : 2422333 ,
        "popularity" : null ,
        "sponsor" : "Some Publisher Inc" ,
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



let searchResult2 = try decoder.decode(SearchResult.self , from : jsonWithSponsorKey)

/**
 ... Then in the value for the property ,
 we should see `"Some Publisher Inc"`
 in the results pane for `result.sponsor` ,
 */

searchResult2.sponsor // "Some Publisher Inc"

let encodedSearchResult2 = try encoder.encode(searchResult2)
print(encodedSearchResult2.stringDescription)

/**
 And in the JSON string — in the results area — ,
 you should see the key value pair reflected
 
 `"sponsor" : "Some Publisher Inc",`:
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
     "sponsor" : "Some Publisher Inc",
     "books_count" : 222
   }
 }
 */

/**
 And that is how you deal with missing , or null data .
 
 
 
 In the next video ,
 let's take a look at
 what happens when keys aren't defined beforehand .
 */
