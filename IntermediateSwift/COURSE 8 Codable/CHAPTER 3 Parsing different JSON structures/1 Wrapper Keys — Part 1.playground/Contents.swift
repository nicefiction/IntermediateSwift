import Foundation


/**
 `CHAPTER 3`
 `Parsing Different JSON Structures`
 Now that we know how to use `Codable`
 and its related types
 to decode
 and encode
 to JSON
 let's work through several examples .
 In these examples
 we will encounter some of the various ways JSON is structured
 and take a look at strategies to make parsing it
 easier .
 */



/**
 `1 Wrapper Keys`: PART 1 of 3
 INTRO — Often times
 the JSON data we desire to populate our model
 is not represented at the top level of the object
 but wrapped using a key .
 In this video
 we look at different strategies for decoding and encoding
 when we encounter wrapper keys .
 */
/**
 Now that we know how to do some basic encoding and decoding ,
 let's look at a few situations that you will run into often ,
 and see how you can tackle them .
 Let's start with `wrapper keys` .
 _Now , what do I mean by that ?_
 I worked with the `Goodreads API` recently .
 Goodreads is a social website for everything book and reading related .
 And while their `API` actually returns `XML` ,
 it is formatted something like this
 — if it were in `JSON` :
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

/**
 When you search for a book ,
 instead of getting a list of results back ,
 each result is wrapped .
 I have defined in here a snippet of this resulting JSON
 and what it could possibly look like .
 In all the snippets of JSON we have seen so far ,
 the data was just represented as a `dictionary` at the top level
 and we used keys to get to what we want .
 Here , however ,
 the data that we want is inside this `nested dictionary` .
 The key work wraps around the result info that we want .
 Now in this query , I have hit the search end point
 and I am looking for Ender's Game .
 We get a bunch of results back ,
 and each of those results is wrapped in this `work key` .
 We don't really care about this `work key` though .
 We just want the stuff that is inside .
 So let's look at how we can model this .
 Since the data represented inside `work` is a result of sorts ,
 I have defined a model down here called SearchResult :
 */

// struct SearchResult {}

/**
 For now ,
 we'll leave the information inside `best_book` .
 So if we go back to the JSON ,
 you'll see that there's `"work"` .
 Then you have an `"id"` ,
 `"books_count"` ,
 `"ratings_count"` ,
 `"text_reviews_count"` ,
 and then finally there is a further nested dictionary called `"best_book"` .
 We are going to leave that out for now ,
 and we'll just focus on getting this data into the model first .
 But we'll get to that , don't worry .
 Now , since all these properties on the model are primitive types ,
 we can conform to `Codable` with no issues :
 */

struct SearchResult: Codable {
    
    let id: Int
    let booksCount: Int
    let ratingsCount: Int
    let textReviewsCount: Int
}

/**
 Next , we have a decoder ,
 */
let decoder: JSONDecoder = JSONDecoder()
/**
 And here , I have indicated that the keys in the JSON are in SnakeCase  ,
 */
decoder.keyDecodingStrategy = .convertFromSnakeCase

// let searchResult = try decoder.decode(SearchResult.self , from : json)

/**
 If we try and decode this in the same way that we have been doing so far ,
 it will fail ,
 */

/* ERROR :
 
 Playground execution terminated: An error was thrown and was not caught:
 ▿ DecodingError
   ▿ keyNotFound : 2 elements
     - .0 : CodingKeys(stringValue: "id", intValue: nil)
     ▿ .1 : Context
       - codingPath : 0 elements
       - debugDescription : "No value associated with key CodingKeys(stringValue: \"id\", intValue: nil) (\"id\")."
       - underlyingError : nil
 */

/**
 The reason it is failing here , is ,
 because the outer dictionary in the JSON ,
 so this one ☘️,
 
 `let json = """`
 `{`
     ☘️`"work" : {`
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
 
 does not map to the model directly .
 The wrapper key gets in the way .
 The trick — so to speak — to getting this to work , is ,
 to understand that we need to ask the `decoder`
 to decode the JSON in exactly the same way
 as it is represented in the structure here
 — which is a dictionary .
 Where the `key` is a `String`
 
 `"work"`
 
 and the `value` is a nested dictionary
 
 `"id" : 2422333 ,`
 `"books_count" : 222 ,`
 `"ratings_count" : 860687 ,`
 `"text_reviews_count" : 37786 ,`
 `"best_book" : {`
     `"id" : 375802 ,`
     `"title" : "Ender's Game (Ender's Saga, #1)" ,`
     `"author" : {`
         `"id" : 589 ,`
         `"name" : "Orson Scott Card"`
     `}`
 `}`
 
 that can be decoded into our type .
 So if we change our decoder request
 — our decode request to match that representation —
 by saying ,
 instead of saying directly `SearchResult.self` , ...
 */

// let searchResult = try decoder.decode(SearchResult.self , from : json)
/**
 ... if we say `String` to `SearchResult` , as a `Dictionary` , ...
 */

let searchResult = try decoder.decode([String : SearchResult].self ,
                                      from : json) // ["work" : {id 2422333 , booksCount 222 , ratingsCount 860687 , textReviewsCount 37786}]

/**
 ... now our code compiles ,
 and we have managed to decode the JSON .
 From here ,
 we can extract the value to `SearchResult`
 — which is a value in this dictionary — using the `key` .
 
 `// ["work" : {id 2422333 , booksCount 222 , ratingsCount 860687 , textReviewsCount 37786}]`
 
 This is not ideal , though .
 The value we care about
 is wrapped inside the dictionary .
 And because of how Swift dictionaries work ,
 this means unwrapping
 to actually get to a value we know is there .
 We could `map` over the resulting dictionary
 and return the value .
 But because the compiler does not know
 how many key value pairs the dictionary contains ,
 the result is now an array of search results .
 So , if I were to say `map()` ,
 */

let result = try decoder.decode([String : SearchResult].self , from : json).map {
    return $1 // returns SearchResult
}

/**
 which — `$1` — represents the value ,
 we now have a `SearchResult` type ,
 but when you OPTION click on `result`
 you will see that `result` is an array of `SearchResult` .
 So , from here , we would have to call first ,
 
 `result.first`
 
 which returns an optional ,
 so not good , right ? This isn't a great approach .
 _What else can we do ?_
 */
/**
👉 Continues in PART 2
*/
