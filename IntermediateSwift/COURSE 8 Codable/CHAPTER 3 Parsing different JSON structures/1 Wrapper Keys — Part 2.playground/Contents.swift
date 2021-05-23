import Foundation


/**
 `1 Wrapper Keys`: PART 2 of 3
 We can actually get a much cleaner implementation
 if we are willing to provide a protocol implementation ourselves .
 So , let’s get rid of all the code ,
 except the type definition — `struct SearchResult { ... }`, ...
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

/*
struct SearchResult: Codable {
    
    let id: Int
    let booksCount: Int
    let ratingsCount: Int
    let textReviewsCount: Int
}
*/

/**
 ... and we'll start by defining `CodingKeys` .
 Unlike last time ,
 we are going to have more than one set of `CodingKeys` and `container` [ OLIVIER : ? ] here .
 First , we'll define an `enum` ,
 named `OuterCodingKeys` .
 Again , remember ,
 these names are completely up to you .
 This name — `OuterCodingKeys` — just makes sense to me .
 This is going to be an enum with a raw value of `String` ,
 and it is going to conform to `CodingKey protocol` :
 */

/*
struct SearchResult: Codable {
    
    let id: Int
    let booksCount: Int
    let ratingsCount: Int
    let textReviewsCount: Int
    
    
    enum OuterCodingKeys: String ,
                          CodingKey {
        case work
    }
}
 */

/**
 This `OuterCodingKeys enum` has a single member — `work` —
 to map to the outermost key in the JSON .
 Next , we'll define a `CodingKeys enum` :
 */

// struct SearchResult: Codable {
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

/**
 The `CodingKeys enum` has `String raw values` ,
 and conforms to `CodingKey` .
 And this is how we normally do things .
 This enum maps from the stored properties to the JSON .
 Okay , so I am also going to get rid of this `Codable` conformance here .
 And in an extension below , let's conform to `Decodable` ,
 */

extension SearchResult: Decodable {
    
    init(from decoder: Decoder)
    throws {
        /**
         We are going to start by defining a keyed container
         with one main difference .
         We are going to start with the outer key in the JSON ,
         the one with the single key work .
         The outer key — `"work"` —
         is represented by the `OuterCodingKeys enum` :
         */
        let outerContainer = try decoder.container(keyedBy : OuterCodingKeys.self)
        /**
         Next ,
         instead of decoding like we normally do ,
         we are going to ask the `decoder` to create a _nested container_
         to encapsulate the dictionary we get as a value
         from using the key `"work"` . So down here ,
         */
        let innerContainer = try outerContainer.nestedContainer(keyedBy : CodingKeys.self ,
                                                                forKey : OuterCodingKeys.work)
        /**
         instead of asking the `decoder` ,
         we are going to ask the `outerContainer`
         to create a `nestedContainer` .
         And to actually get to this nested container ,
         we are going to use the key `work`
         — which is represented in that `OuterCodingKeys type` .
         Okay ,
         now we can use this nested dictionary
         to initialise all our values ,
         */
        self.id               = try innerContainer.decode(Int.self , forKey : CodingKeys.id)
        self.booksCount       = try innerContainer.decode(Int.self , forKey : CodingKeys.booksCount)
        self.ratingsCount     = try innerContainer.decode(Int.self , forKey : CodingKeys.ratingsCount)
        self.textReviewsCount = try innerContainer.decode(Int.self , forKey : CodingKeys.textReviewsCount)
    }
}

/**
 The important thing to understand here , is , that
 _containers_ are the Swift way of representing a JSON structure .
 A `container` can contain any number of _nested containers_
 and these can be
 (`1`) keyed ,
 (`2`) single value containers ,
 or (`3`) unkeyed .
 Here ,
 
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
 
 the `json` is a dictionary at a high level .
 So ,
 we represent it to start off as a keyed container .
 
 `let outerContainer = try decoder.container(keyedBy : OuterCodingKeys.self)`
 
 Inside that dictionary ,
 there is another dictionary that we care about .
 So , we use a nested container — a nested keyed container — to represent it .
 
 `let innerContainer = try outerContainer.nestedContainer(keyedBy : CodingKeys.self ,`
                                                         `forKey : OuterCodingKeys.work)`
 
 Remember that these are all _throwing methods_ we use .
 So , we need the `try` keyword to actually decode it :
 
 `self.id               = try innerContainer.decode(Int.self , forKey : CodingKeys.id)`
 `self.booksCount       = try innerContainer.decode(Int.self , forKey : CodingKeys.booksCount)`
 `self.ratingsCount     = try innerContainer.decode(Int.self , forKey : CodingKeys.ratingsCount)`
 `self.textReviewsCount = try innerContainer.decode(Int.self , forKey : CodingKeys.textReviewsCount)`
 
 Remember ,
 we are going to ask the `innerContainer` to do the decoding ,
 and that is all we need to do in our initialiser .
 Now ,
 we should be able to decode directly to the type rather than into a dictionary .
 Because inside the `init()` code ,
 we are doing the work of parsing that dictionary :
 */

let decoder: JSONDecoder = JSONDecoder()
decoder.keyDecodingStrategy = .convertFromSnakeCase

let searchResult = try decoder.decode(SearchResult.self ,
                                      from : json) // SearchResult

/**
 Once this playground runs through ,
 
 `// SearchResult`
 
 cool , so that worked .
 */
/**
👉 Continues in PART 3
*/
