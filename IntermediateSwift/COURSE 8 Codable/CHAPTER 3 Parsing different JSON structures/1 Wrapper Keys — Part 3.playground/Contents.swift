import Foundation


/**
 `1 Wrapper Keys`: PART 3 of 3
 */

let json = """
{
    "work" : {
        "id" : 2422333,
        "books_count" : 222,
        "ratings_count" : 860687,
        "text_reviews_count" : 37786,
        "best_book" : {
            "id" : 375802,
            "title" : "Ender's Game (Ender's Saga, #1)",
            "author" : {
                "id" : 589,
                "name" : "Orson Scott Card"
            }
        }
    }
}
""".data(using: .utf8)!



struct SearchResult {
    
     // ///////////////////
    //  MARK: NESTED TYPES
    
    enum OuterCodingKeys: String ,
                          CodingKey {
        case work
    }
    
    
    enum CodingKeys: String ,
                     CodingKey {
        case id
        case booksCount
        case ratingsCount
        case textReviewsCount
    }
    
    
    
     // /////////////////
    //  MARK: PROPERTIES
    
    let id: Int
    let booksCount: Int
    let ratingsCount: Int
    let textReviewsCount: Int
}



extension SearchResult: Decodable {

    init(from decoder: Decoder)
    throws {
        
        let outerContainer = try decoder.container(keyedBy : OuterCodingKeys.self)
        let innerContainer = try outerContainer.nestedContainer(keyedBy : CodingKeys.self ,
                                                                forKey : OuterCodingKeys.work)
        
        self.id               = try innerContainer.decode(Int.self , forKey : CodingKeys.id)
        self.booksCount       = try innerContainer.decode(Int.self , forKey : CodingKeys.booksCount)
        self.ratingsCount     = try innerContainer.decode(Int.self , forKey : CodingKeys.ratingsCount)
        self.textReviewsCount = try innerContainer.decode(Int.self , forKey : CodingKeys.textReviewsCount)
    }
}



let decoder: JSONDecoder = JSONDecoder()
decoder.keyDecodingStrategy = .convertFromSnakeCase

let searchResult = try decoder.decode(SearchResult.self ,
                                      from : json)
/**
 What about encoding , though ?
 Let's assume that for some reason ,
 we are going to send a search result back to the server ,
 and it has to be wrapped in a `work` key , as well .
 So , let's see how we implement this :
 */

extension SearchResult: Encodable {
    /**
     In the extension we provide an implementation for the encode( ) function .
     */
    func encode(to encoder: Encoder)
    throws {
        /**
         We already have the `CodingKeys` we need ,
         so we start by creating our outer container ,
         */
        var outerContainer = encoder.container(keyedBy: OuterCodingKeys.self)
        /**
         Remember , that — since we are writing to this container — it needs to be variable .
         And then — using this `outerContainer` —
         we can create an `innerContainer` that is wrapped using the key `.work` ,
         */
        var innerContainer = outerContainer.nestedContainer(keyedBy : CodingKeys.self ,
                                                            forKey : OuterCodingKeys.work)
        /**
         `NOTICE` that this is much the same code ,
         it is just going in the opposite direction .
         
         And now we can `encode` ,
         */
        try innerContainer.encode(id , forKey : CodingKeys.id)
        try innerContainer.encode(booksCount , forKey : CodingKeys.booksCount)
        try innerContainer.encode(ratingsCount , forKey : CodingKeys.ratingsCount)
        try innerContainer.encode(textReviewsCount , forKey : CodingKeys.textReviewsCount)
    }
}

/**
 Let's see if this works .
 So , down here , we create an `encoder` :
 */

let encoder: JSONEncoder = JSONEncoder()
encoder.keyEncodingStrategy = .convertToSnakeCase

let encodedSearchResult = try encoder.encode(searchResult)

/**
 The value here is `encodedSearchResult` , ...
 */

extension Data {
    
    var stringDescription: String {
        
        return String(data : self ,
                      encoding : .utf8)!
    }
}

/**
 ... and we'll call `stringDescription`
 — which we defined earlier in the Data+Extensions.swift file —
 */

encodedSearchResult.stringDescription

/**
 And now ,
 if we look below in the console ,
 we can see the JSON string .
 */
// prints "{"work":{"id":2422333,"text_reviews_count":37786,"ratings_count":860687,"books_count":222}}"

/**
 It represents or resembles that JSON structure we started out with .
 So , we have this outer key
 
 `"work"`,
 
 and then an inner nested object ,
 
 `{"id":2422333,"text_reviews_count":37786,"ratings_count":860687,"books_count":222}`
 */



/**
 Okay ,
 so that is one situation
 that we are going to run into with wrapper keys .
 And now you know how to use `Codable` to encode and decode .
 But we are not done with this example .
 If you go back to the JSON string up at the top ,
 
 `let json = """`
 `{`
     `"work" : {`
         `"id" : 2422333,`
         `"books_count" : 222,`
         `"ratings_count" : 860687,`
         `"text_reviews_count" : 37786,`
         `"best_book" : {`
             `"id" : 375802,`
             `"title" : "Ender's Game (Ender's Saga, #1)",`
             `"author" : {`
                 `"id" : 589,`
                 `"name" : "Orson Scott Card"`
             `}`
         `}`
     `}`
 `}`
 `""".data(using: .utf8)!`
 
 you'll notice that we didn't model all the data that is represented in here .
 Inside of the nested dictionary ,
 we have two more nested dictionaries .
 In the next video though ,
 let's talk about
 how we handle that
 in a way that is different from what we just did .
 */
