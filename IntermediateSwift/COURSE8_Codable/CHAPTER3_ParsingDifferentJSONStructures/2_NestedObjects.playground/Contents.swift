import Foundation


/**
 `2 Nested Objects`
 INTRO — The JSON we are working with
 contains more than one level of information
 — dictionaries are nested at the top level .
 We need to figure out
 how to decode this information
 and in this video
 we look at two strategies .
 */
/**
 In the last video , we managed to parse
 some mildly complicated JSON
 containing nested dictionaries in wrapper keys into our type .
 But we have still got some more work to do
 with this example .
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
 The JSON structure still has
 two additional nested dictionaries
 
 `"best_book" : {`
     `"id" : 375802 ,`
     `"title" : "Ender's Game (Ender's Saga, #1)" ,`
 
 `"author" : {`
     `"id" : 589 ,`
     `"name" : "Orson Scott Card"`

 that we need to model .
 _How do we handle this ?_
 The answer to all this
 depends
 on how you want to model your data :
 (`1`) Option one is
 to flatten the JSON into a single model
 when representing it in code .
 _What do I mean by flattening ?_
 In the last video ,
 even though we started with an inner dictionary that had a wrapper key ,
 we were able to parse nested containers to model the data we wanted .
 So , over here ,
 you can see that the data we want
 is at a different depth than the initial key ,
 but we were able to flatten that down to one model .
 So , for the second example ,
 with the `"best_book"` information ,
 we could do that as well .
 We could simply
 extract the information
 from inside the `"best_book"` dictionary
 and assign those values to stored properties
 modelled on the `SearchResult` type ,
 essentially flattening all the information down to one type .
 If that is what you want to do ,
 you already know how to do it .
 Like we did in the last video ,
 you simply create nested key dictionaries to parse these key value pairs further ,
 but we really don't want to do that .
 Imagine that instead of containing one nested book result
 this `"work"` information contained multiple books with many authors .
 Flattening that to one type is not going to be an accurate representation of the data .
 So what we are going to do instead , is ,
 create more types to further model this information .
 So , we will start with the innermost information ,
 and we will do that right after the `SearchResult` type — the main type :
 */

struct SearchResult {
    
     // ///////////////////
    //  MARK: NESTED TYPES
    
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
    }
    
    
    struct Author: Codable {
    // struct Author { // Not mentioning conformance to Codable will trigger an Error message in the Book struct .
        
        let id: Int
        let name: String
    }
    
    
    struct Book: Codable { // ERROR : Type 'SearchResult.Book' does not conform to protocol 'Decodable' when Author does not conform to Codable .
        
        let id: Int
        let title: String
        let author: Author
    }
    
    
    
     // /////////////////
    //  MARK: PROPERTIES
    
    let id: Int
    let booksCount: Int
    let ratingsCount: Int
    let textReviewsCount: Int
    let bestBook: Book
}

/**
 We model this new type as a struct .
 
 `struct Author: Codable {`
     
     let id: Int
     let name: String
 `}`
 
 We call it `Author` , and we make it conform to `Codable` ,
 and in it we have two properties
 — an `id` of type `Int` , and a `name` of type `String` .
 If you go up at the top to the JSON structure ,
 this is exactly what it is ,
 ☘️
 
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
             `"author" : { // ☘️`
                 `"id" : 589,`
                 `"name" : "Orson Scott Card"`
             `}`
         `}`
     `}`
 `}`
 `""".data(using: .utf8)!`
 
 so we have an `id` , and a `name` .
 There is nothing complicated about this type .
 The keys in the JSON map easily to the stored properties ,
 and the values are primitive types ,
 so we can add that `Codable` conformance with no additional work .
 Okay , so once we have an author we can model a `Book` :
 
 `struct Book: Codable {`
     
     let id: Int
     let title: String
     let author: Author
 `}`
 
 The only notable thing about the `Book` struct is
 the fact that it models the `Author` type as a stored property .
 Now , we can go ahead and add `Codable` conformance to this type .
 And you'll see that despite containing a non-primitive — a custom type —
 the compiler is not going to complain .
 Since the `Author` type already conforms to `Codable`
 we don't need to do any more work to decode it from within the `Book` type ,
 which is why the compiler is satisfied .
 
 `NOTE` :
 If we were to remove the `Codable` conformance from `Author`,
 then you will see that in `Book`
 we get a compilation error ,
 
 `// ERROR : Type 'SearchResult.Book' does not conform to protocol 'Decodable' when Author does not conform to Codable .`
 
 because now we need to define an `init()` method
 that handles how we decode `Author` .
 
 
 Okay ,
 so similar to how `Author` is contained inside `Book` ,
 let's go back to `SearchResult` ,
 and we'll model an instance of `Book` inside here :

 `struct SearchResult {`
 
    `...`

    `let id: Int`
    `let booksCount: Int`
    `let ratingsCount: Int`
    `let textReviewsCount: Int`
    `let bestBook: Book // 📙`
 `}`
 
 And when we add this
 — since we are providing a custom implementation for encoding and decoding —
 we need to refactor this implementation to decode `Book`
 and ultimately , `Author` as well .
 So , to start ,
 in our `CodingKeys enum` , we'll need a _coding key_ .
 
 `struct SearchResult {`
 
    `...`

 `enum InnerCodingKeys: String ,`
                       `CodingKey {`
        `case id`
        `case booksCount`
        `case ratingsCount`
        `case textReviewsCount`
        `case bestBook // 📙`
    `}`
 `}`
 
 Now , remember , we don't need to provide a raw value ,
 because the decoder and encoder pair are aware
 that the keys need to go from snake case to lower camelcase , and back .
 To finish up the decoding implementation , which is down here , we'll simply say
 */

 // /////////////////
//  MARK: EXTENSIONS

extension SearchResult: Decodable {
   
   init(from decoder: Decoder)
   throws {
       
       let outerContainer = try decoder.container(keyedBy : OuterCodingKeys.self)
       let innerContainer = try outerContainer.nestedContainer(keyedBy : InnerCodingKeys.self ,
                                                               forKey : OuterCodingKeys.work)
       
       self.id               = try innerContainer.decode(Int.self ,  forKey : InnerCodingKeys.id)
       self.booksCount       = try innerContainer.decode(Int.self ,  forKey : InnerCodingKeys.booksCount)
       self.ratingsCount     = try innerContainer.decode(Int.self ,  forKey : InnerCodingKeys.ratingsCount)
       self.textReviewsCount = try innerContainer.decode(Int.self ,  forKey : InnerCodingKeys.textReviewsCount)
       self.bestBook         = try innerContainer.decode(Book.self , forKey : InnerCodingKeys.bestBook) // 📙
   }
}

/**
 And then going over to the encoder at the bottom ,
 you will say ,
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
       try innerContainer.encode(bestBook , forKey : InnerCodingKeys.bestBook) // 📙
   }
}


extension Data {
    
    var stringDescription: String {
        
        return String(data : self ,
                      encoding : .utf8)!
    }
}

/**
 Okay , so from the decoding end ,
 let's see if this works by querying a few stored properties .
 So , where is our decoder , up here ,
 */

let decoder: JSONDecoder = JSONDecoder()
decoder.keyDecodingStrategy = .convertFromSnakeCase

let searchResult = try decoder.decode(SearchResult.self , from : json)
searchResult.bestBook

/**
 So , we have our result , we can say ,
 */

print(searchResult.bestBook.author.name) // prints Orson Scott Card
print(searchResult.bestBook.title) // prints Ender's Game (Ender's Saga, #1)

/**
 Cool .
 You'll see that this resolves to the correct information ,
 so it worked .
 You can inspect this further
 by examining the JSON string
 generated in the console .
 */

let encoder: JSONEncoder = JSONEncoder()
encoder.keyEncodingStrategy = .convertToSnakeCase

let encodedSearchResult = try encoder.encode(searchResult)

print(encodedSearchResult.stringDescription) // prints {"work":{"id":2422333,"text_reviews_count":37786,"ratings_count":860687,"best_book":{"id":375802,"title":"Ender's Game (Ender's Saga, #1)","author":{"id":589,"name":"Orson Scott Card"}},"books_count":222}}

/**
 The information for `"best_book"` and `"author"`
 are all presented in here ,
 nested correctly ,
 just like the sample we started with .
 So ,
 how was implementing this so much easier than we had to unwrap the key `"work"` ?
 How did everything just work ,
 and why did we have to do a lot less , you know , coding ?
 We didn't have to inform the decoder , so to speak ,
 that the information for the `Book` type was in a nested dictionary .
 And the same goes for the `Author` type ,
 and unlike the last time , we didn't have to create a nested key container .
 The magic happens
 because when we model this nested information as separate types ,
 the compiler can figure things out automatically .
 When we try to decode `Book` using the key ,
 so over here — `forKey : InnerCodingKeys.bestBook`,
 
 `extension SearchResult: Decodable {`
    
    `init(from decoder: Decoder)`
    `throws {`
        
        let outerContainer = try decoder.container(keyedBy : OuterCodingKeys.self)
        let innerContainer = try outerContainer.nestedContainer(keyedBy : InnerCodingKeys.self ,
                                                                forKey : OuterCodingKeys.work)
        
        self.id               = try innerContainer.decode(Int.self ,  forKey : InnerCodingKeys.id)
        self.booksCount       = try innerContainer.decode(Int.self ,  forKey : InnerCodingKeys.booksCount)
        self.ratingsCount     = try innerContainer.decode(Int.self ,  forKey : InnerCodingKeys.ratingsCount)
        self.textReviewsCount = try innerContainer.decode(Int.self ,  forKey : InnerCodingKeys.textReviewsCount)
        self.bestBook         = try innerContainer.decode(Book.self , forKey : InnerCodingKeys.bestBook)
    `}`
 `}`
 
 the compiler is aware of the fact that this is a type that implements `Codable` as well .
 And the information to be coded is present as a keyed container
 using the relevant key .
 The information is extracted ,
 so if we go up to the JSON ,
 right when the decoder gets here — `"best_book" : { ... }` , ...

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
 
 ... and looks at a key `"best_book"` ,
 it knows that the value needs to be decoded into a completely separate type .
 So what it does is ,
 it extracts its information and provides this dictionary
 
 `"id" : 375802,`
 `"title" : "Ender's Game (Ender's Saga, #1)",`
 `"author" : {`
     `"id" : 589,`
     `"name" : "Orson Scott Card"`
 `}`
 
 to the initialiser method on the `Book` type ,
 which handles it from there .
 Then inside of the `Book` type ,
 
 `struct Book: Codable {`
     
     let id: Int
     let title: String
     let author: Author
 `}`
 
 when it encounters the key `"author"` ,
 it does the same thing .
 It knows that this
 
 `"author" : {`
     `"id" : 589,`
     `"name" : "Orson Scott Card"`
 `}`
 
 is a separate type entirely , the value ,
 so it hands off the nested dictionary over to the value ,
 over to the `Author` type .
 
 `struct Author: Codable {`
     
     let id: Int
     let name: String
 `}`
 
 So this also applies in the opposite direction .
 When the `encoder` is doing its thing
 and sees a nested type ,
 it knows that this should be modelled
 as a nested dictionary
 within the encoded JSON .
    (`2`) Okay , so this was option number two :
 If you have information that is nested ,
 the easiest way to `encode` and `decode` that information , is ,
 to model it as a separate type ,
 and then conform those types to `Codable` .
 If these types have their own sort of complicated `Codable` implementation ,
 that is okay too ,
 because you can define your own `init()` from `decoder`
 and `encode` to encoder functions .
 
 
 
 In the next video ,
 let's talk about how we handle a situation
 where we have more than one book in the result set .
 */
