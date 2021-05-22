import Foundation


/**
 `3 Decoding to a Class`: PART 3 OF 3
 To wrap this up ,
 let's look at how we could decode a string of JSON that
 where the response looks like this
 — what we have in the console —
 so just grab this , _copy_
 
 {
    "media" : {
        "id" : "ABCD",
        "title" : "Some title"
    },
 
    "isbn" : "978-3-16-148410-0"
 }
 */

// let json = """
// {
//     "id" : "ABCD" ,
//     "title" : "Some title" ,
//     "isbn" : "978-3-16-148410-0"
// }
// """.data(using : .utf8)

/**
 _paste_ this `String` in here , for our `json` :
 */

let json = """
{
    "media" : {
        "id" : "ABCD",
        "title" : "Some title"
    },
     
    "isbn" : "978-3-16-148410-0"
}
""".data(using : .utf8)!

/**
 When we do that , ...
 */

extension Data {
    
    var stringDescription: String {
        
        return String(data : self , encoding : .utf8)!
    }
}



class Media: Codable {
    
    let id: String
    let title: String
}


/*
class Book: Media {
    
    enum BookCodingKeys: String ,
                         CodingKey {
        case isbn
        case media
    }
    
    
    let isbn: String
    
    
    required init(from decoder: Decoder)
    throws {
        
        let jsonContainer = try decoder.container(keyedBy : BookCodingKeys.self)
        
        self.isbn = try jsonContainer.decode(String.self ,
                                             forKey: BookCodingKeys.isbn)
        
        try super.init(from : decoder)
    }
    
    
    override func encode(to encoder: Encoder)
    throws {
        
        var jsonContainer = encoder.container(keyedBy : BookCodingKeys.self)
        
        try jsonContainer.encode(isbn ,
                                 forKey : BookCodingKeys.isbn)
        
        try super.encode(to: jsonContainer.superEncoder(forKey : BookCodingKeys.media))
    }
}
 */

let decoder = JSONDecoder()
let book = try decoder.decode(Book.self , from : json)

let encoder = JSONEncoder()

// let encodedBook = try encoder.encode(book)
// print(encodedBook.stringDescription)

/**
 ... it is going to fail
 for a couple different reasons ,
 we now won't be able
 to decode straight to the `Media` type
 without it being too complicated .
 We are going to go straight to the `Book` type ,
 and decode the whole thing from there .
 But we'll take care of the superclass along the way ,
 like we did earlier .
 And again , the change here is simply
 how we call initialisation on the superclass .
 So , right now ,
 
 `required init(from decoder: Decoder)`
 `throws {`
     
     let jsonContainer = try decoder.container(keyedBy : BookCodingKeys.self) // 1
     
     self.isbn = try jsonContainer.decode(String.self ,
                                          forKey: BookCodingKeys.isbn) // 2
     
     try super.init(from : decoder) // 3
 `}`
 
 (`1`) we are accessing the container , defined by the decoder
 (`2`) then we are initialising the isbn property
 and then (`3`) we call `super.init()`
 and we hand over the `decoder` ,
 and the parent class takes it from there
 — the parent classes implementation of `init() decoder` .
 The change is simple here ,
 instead of calling `super init() from decoder`
 and passing the `decoder` from `Book` to `Media` ,
 we a are going to call ,
 */

class Book: Media {
    
    enum BookCodingKeys: String ,
                         CodingKey {
        case isbn
        case media
    }
    
    
    let isbn: String
    
    
    required init(from decoder: Decoder)
    throws {
        
        let jsonContainer = try decoder.container(keyedBy : BookCodingKeys.self)
        
        self.isbn = try jsonContainer.decode(String.self ,
                                             forKey: BookCodingKeys.isbn)
        
        // try super.init(from : decoder)
        try super.init(from : jsonContainer.superDecoder(forKey : BookCodingKeys.media)) // ⭐️
    }
    
    
    override func encode(to encoder: Encoder)
    throws {
        
        var jsonContainer = encoder.container(keyedBy : BookCodingKeys.self)
        
        try jsonContainer.encode(isbn ,
                                 forKey : BookCodingKeys.isbn)
        
        try super.encode(to: jsonContainer.superEncoder(forKey : BookCodingKeys.media))
    }
}

/**
 So , the `Book` type first initialises its stored properties
 using the `isbn` key ,
 
 `self.isbn = try jsonContainer.decode(String.self ,`
                                      `forKey: BookCodingKeys.isbn)`
 
 then it grabs the nested container using the key `.media`
 and passes that on to the parent classes initialiser to handle its stored properties .
 
 `try super.init(from : jsonContainer.superDecoder(forKey : BookCodingKeys.media)) // ⭐️`
 */

let encodedBook = try encoder.encode(book)
print(encodedBook.stringDescription)

/*
{
    "media" : {
        "id" : "ABCD",
        "title" : "Some title"
    },
    
    "isbn" : "978-3-16-148410-0"
}
 */

/**
 Okay , so just like we encode into the `String`
 we can now decode _from this String_ .
 So , this line of code here ,
 
 `try super.init(from : jsonContainer.superDecoder(forKey : BookCodingKeys.media)) // ⭐️`
 
 it grabs this nested dictionary
 
 `{`
    `"id" : "ABCD",`
    `"title" : "Some title"`
 `},`
 
 and passes that on to the parent classes decode initialiser .
 */
/**
 Okay , let's wrap this up .
 The main difference compared to structs , is , that
 when encoding or decoding with classes ,
 we need to consider the inheritance chain
 in how we want to handle that .
 
 
 
 We have one more small topic to cover before we finish ,
 and that is error handling ,
 so on to the next video .
 */
