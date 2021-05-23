import Foundation


/**
 `3 Decoding to a Class`: PART 2 of 3
 Let's look at one nuance situation .
 If we take a look at the `json` `String` in the console , ...
 */

let json = """
{
    "id" : "ABCD" ,
    "title" : "Some title" ,
    "isbn" : "978-3-16-148410-0"
}
""".data(using : .utf8)!



extension Data {
    
    var stringDescription: String {
        
        return String(data : self ,
                      encoding : .utf8)!
    }
}

/**
 ... even though we have a subclass and its parent class
 storing or modelling different bits of information ,
 the `json` `String` has flattened that down to one level of information .
 What if we wanted to encode this
 to represent the fact
 that the `Media` type — the parent —
 encapsulates part of the information
 and the `Book` encapsulates the other .
 So , what we will do , is , `// ☘️`
 */

class Media: Codable {
    
    let id: String
    let title: String
}


/*
class Book: Media {
    
    enum BookCodingKeys: String ,
                         CodingKey {
        case isbn
    }
    
    
    let isbn: String
    
    
    required init(from decoder: Decoder)
    throws {
        
        let jsonContainer = try decoder.container(keyedBy : BookCodingKeys.self)
        
        self.isbn = try jsonContainer.decode(String.self ,
                                             forKey : BookCodingKeys.isbn)
        
        try super.init(from : decoder)
    }
    
    
    override func encode(to encoder: Encoder)
    throws {
        
        // try super.encode(to: encoder) // ☘️
        
        var jsonContainer = encoder.container(keyedBy: BookCodingKeys.self)
        
        try jsonContainer.encode(isbn ,
                                 forKey : BookCodingKeys.isbn)
        
        try super.encode(to : jsonContainer.superEncoder()) // ☘️
    }
}
*/


let decoder = JSONDecoder()
let book = try decoder.decode(Book.self ,
                              from : json)

/**
 when calling `super.encode` here , at the very top ,
 
 `// try super.encode(to: encoder) // ☘️`
 
 instead of passing along the `encoder` as the argument ,
 we are going to call `super.encode()` on the `jsonContainer` .
 To do that ,
 we obviously need to do this
 after we have created the instance of the`jsonContainer` ,
 
 `try super.encode(to : jsonContainer.superEncoder())`
 
 `NOTICE` that instead of passing this `encoder` along ,
 I'll say , `jsonContainer.superEncoder()`
 So , what this does , is ,
 create a new `Encoder` instance
 and a nested container .
 The encoder is provided as an argument to the `super class` — the new one created .
 And the `super class` is encoded into the nested container , using a default key — `super` .
 You can see this reflected in the `json` `String`
 in the output ,
 */

let encoder = JSONEncoder()

let encodedBook = try encoder.encode(book)

// print(encodedBook.stringDescription)

/* Prints
 
 {
    "super" : {
        "id" : "ABCD",
        "title" : "Some title"
    },
 
    "isbn" : "978-3-16-148410-0"
 }
 */

/**
 The key value pairs that are defined in the parent class `Media`
 are now nested inside a container .
 
 `"super" : {`
     `"id" : "ABCD",`
     `"title" : "Some title"`
 `},`
 
 And by default ,
 this container is accessed using a key named `"super"`
 — since we are encoding the super class .
 But if we want ,
 we can change that key name
 So , let’s go back to our `BookCodingKeys enum` ,
 */

class Book: Media {
    
    enum BookCodingKeys: String ,
                         CodingKey {
        case isbn
        case media // ⭐️
    }
    
    
    let isbn: String
    
    
    required init(from decoder: Decoder)
    throws {
        
        let jsonContainer = try decoder.container(keyedBy : BookCodingKeys.self)
        
        self.isbn = try jsonContainer.decode(String.self ,
                                             forKey : BookCodingKeys.isbn)
        
        try super.init(from : decoder)
    }
    
    
    override func encode(to encoder: Encoder)
    throws {
        
        var jsonContainer = encoder.container(keyedBy: BookCodingKeys.self)
        
        try jsonContainer.encode(isbn ,
                                 forKey : BookCodingKeys.isbn)
        
        try super.encode(to : jsonContainer.superEncoder(forKey : BookCodingKeys.media)) // ⭐️
    }
}

/**
 When specifying a key
 that we want this super class nested under during encoding ,
 that key needs to be a value of the `CodingKey` conforming type we use .
 So , `BookCodingKeys` in this case ,
 which is why we added in another value .
 But now that we have a key in `BookCodingKeys` ,
 we can use that key ,
 and the only change we need to make , is ,
 to pass in a `forKey` argument here .
 
 `try super.encode(to : jsonContainer.superEncoder(forKey : BookCodingKeys.media)) // ⭐️`
 
 Okay ,
 now if we look at the JSON in the console ,
 you should see the change reflected . So now , everything that is defined in the Media type
 is inside this nested dictionary in the JSON :
 */

print(encodedBook.stringDescription)

/* Prints
 
 {
    "media" : {
        "id" : "ABCD",
        "title" : "Some title"
    },
 
    "isbn" : "978-3-16-148410-0"
 }
 */

/**
 And you get to that dictionary
 using a `"media"` key ,
 which we have specified here :
 
 `try super.encode(to : jsonContainer.superEncoder(forKey : BookCodingKeys.media)) // ⭐️`
 
 Obviously ,
 it is getting the raw value of this enum case
 and using that as a key :
 
 `enum BookCodingKeys: String ,`
                      `CodingKey {`
     `case isbn`
     `case media // ⭐️`
 `}`
 */
/**
👉 Continues in PART 3
*/
