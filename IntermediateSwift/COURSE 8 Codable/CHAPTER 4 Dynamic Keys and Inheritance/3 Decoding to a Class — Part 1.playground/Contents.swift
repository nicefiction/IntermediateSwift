import Foundation


/**
 `3 Decoding to a Class`: PART 1 of 3
 INTRO — When we use structs as our `Codable` conforming types ,
 we only have to worry about the type itself .
 When we use classes to model data
 there is some additional work we need to do .
 In this video ,
 lets take a look at
 how we can decode into a class
 and initialise super classes along the way .
 */
/**
 One thing you may have noticed this entire time , is ,
 that I only use structs to model data when parsing JSON .
 _What about classes ?_
 Let's start with something simple using a simple example
 to highlight how classes and JSON parsing work together ,
 both decoding and encoding .
 */

/*
let json = """
{
    "id" : "ABCD" ,
    "title" : "Some title"
}
""".data(using : .utf8)!


class Media: Codable {
    
    let id: String
    let title: String
}



let decoder: JSONDecoder = JSONDecoder()
let encoder: JSONEncoder = JSONEncoder()

encoder.outputFormatting = .prettyPrinted
 */

/**
 We have some `json` at the top ,
 a `Media` class below that .

 `NOTE` an interesting thing here ,
 I have not defined an initialiser on `Media` ,
 but we don't seem to have any errors .
 Recall that with Swift classes ,
 reference types need to have an initialiser defined
 because the compiler does not automatically synthesise one for you .
 The reason this works , is ,
 because the type also conforms to `Codable`
 — which provides an initialiser .
 This means
 if you were to create an instance of `Media` ,
 you can only do it by decoding using a `decoder`
 since there isn't any other initialiser .
 `TIP` : In practice , this probably isn't a good idea
 since allowing for the standard initialiser
 allows us to test our models .
 
 Let's go ahead
 and create an instance of `Media`
 using that simple `json` :
 */

// let media = try decoder.decode(Media.self , from : json) // Media

/**
 Okay , so that works .
 All right , now for the new stuff .
 Let's define a new class `Book` that inherits from `Media` :
 */

// class Book: Media {}

/**
 Before we do anything else with the `Book` type ,
 let's see if we can decode it using the sample `json` :
 */

// let book = try decoder.decode(Book.self , from : json) // Book

/**
 Surprisingly enough , this works .
 The `Book` type inherits the initialiser from its parent type ,
 much like any other subclass inherits the designated initialisers of its super class .
 Okay , let's go ahead and add a stored property to `Book` :
 */

/*
class Book: Media {
    
    var isbn: String?
}
 */

/**
 `NOTE` that I made this property an optional `String?`
 purely for the sake of avoiding an `innit()` method for now .
 
 Okay , and let's go ahead
 and add some corresponding json data as well ,
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



class Media: Codable {
    
    let id: String
    let title: String
}


/*
class Book: Media {
    
    var isbn: String?
}
*/


let decoder: JSONDecoder = JSONDecoder()
let encoder: JSONEncoder = JSONEncoder()

encoder.outputFormatting = .prettyPrinted

/**
 Okay , the rest of the code should compile
 but now , if we go back down to our `Book` instance
 that we have here
 and we inspect these properties :
 */

/*
let book = try decoder.decode(Book.self , from : json)

book.isbn // nil
book.title // "Some title"
book.id // "ABCD"
 */

/**
 You'll see that both of these have values ,
 but — `book.isbn` — you'll see that this is `nil` .
 So , while the subclass —`Book`—
 inherits the decodable initialiser from its super class —`Media`,
 it only handles encoding and decoding of properties
 defined in the super class .
 Now to highlight this point further ,
 the subclass can only encode and decode properties
 that are defined in the parent class
 when using the inherited initialiser and `encode()` function .
 Let's try encoding this .
 So , we can assign a value to `book` , since it is a variable property .
 We just add a random `String` _abcdef_ ...
 */

// book.isbn = "abcdef"

/**
 ... and now it has a value .
 Now , using our `encoder` ,
 let's encode this instance back to `json` :
 */

// let encodedBook = try encoder.encode(book)

// print(encodedBook.stringDescription)

/* Prints
 
 {
   "id" : "ABCD",
   "title" : "Some title"
 }
 */

/**
 And in the console
 you can see
 that there is no `"ISBN"` key or value .
 So , what we are seeing here again , is , that
 even though the sub class `Book` conforms to `Codable`
 by inheriting its parent’s initialiser and `encode()` function .
 Only the properties defined in the parent class are encoded and decoded
 when using the default initialiser and `encode()` function .
 To accurately reflect the properties in our subclass ,
 we need to implement encodable and decodable requirements in the subclass as well .
 So , we can't rely on that automatically provided implementation
 using the protocol extension .
 Now the difference here though , is , that
 unlike structs ,
 we are overriding an implementation defined in the parent class .
 So , we need to take care to call `super` when relevant
 and there is some nuance there .
 So all in due time , let's start simple .
 First , we'll go back to `Book` ,
 and we'll change this to be a regular `String`
 and we'll make this a constant stored property :
 */

/*
class Book: Media {
    
    let isbn: String
} // ERROR : Class 'Book' has no initializers .
 */

/**
 Now . let's provide an implementation for `Decodable` .
 This is a `required init()` method , so we need indicate this :
 */

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
                                             forKey : BookCodingKeys.isbn) // ERROR : 'super.init' isn't called on all paths before returning from initializer .
        
        try super.init(from : decoder)
    }
}
*/

/**
 If you start typing `init() from decoder` ,
 know that it contains the `required` keyword .
 When adding a `required` keyword `init()` method in a subclass ,
 the override — the aspect that it is override
 is implied .
 So , we don't need to add the `override` keyword here ,
 `required` is basically `override` .
 Okay , before we can actually use this initialiser ,
 we need a `CodingKey` conforming type . So we'll say
 
 `enum BookCodingKeys: String ,`
                      `CodingKey {`
     `case isbn`
 `}`
 
 Okay , from here ,
 initialising the `isbn` property in the subclass is straightforward .
 We'll start as always with a `container` ,
 
 `let jsonContainer = try decoder.container(keyedBy : BookCodingKeys.self)`
 
 And then we can say
 
 `self.isbn = try jsonContainer.decode(String.self ,`
                                      `forKey : BookCodingKeys.isbn)`
 
 Now ,
 because the `Book` class is a subclass , however ,
 this isn't all we need to do .
 You can see that there is an error that says
 
 `'super.init' isn't called on all paths before returning from initializer`
 
 So we need to initialise a super class ,
 and to do that we'll say
 
 `try super.init(from : decoder)`
 
 Okay , this should work now ,
 */

/*
let book = try decoder.decode(Book.self , from : json)

book.isbn // "978-3-16-14841"
book.title // "Some title"
book.id // "ABCD"
 */

/**
 you'll see that `id` and `title`
 — which are defined on the parent class — ...
 
 `class Media: Codable {`
     
     let id: String
     let title: String
 `}`
 
 ... do have values in the sub class instance as well :
 
 `book.title // "Some title"`
 `book.id // "ABCD"`
 
 And you can check out `book.isbn`
 and it should have that `String` we added to the `json` ,

 `book.isbn // "978-3-16-14841"`
 
 There we go .
 But if you keep inspecting , ...
 */

/*
let encodedBook = try encoder.encode(book)

print(encodedBook.stringDescription)
 */

/* Prints
 
 {
   "id" : "ABCD",
   "title" : "Some title"
 }
 */

/**
 ... you will notice that the String printed in the console isn't right .
 And that is
 because we have not provided a custom implementation
 for the `encode()` function .
 Let's do that :
 */

class Book: Media {
    
    enum BookCodingkeys: String ,
                         CodingKey {
        case isbn
    }
    
    
    let isbn: String
    
    
    required init(from decoder: Decoder)
    throws {
        
        let jsonContainer = try decoder.container(keyedBy: BookCodingkeys.self)
        
        self.isbn = try jsonContainer.decode(String.self ,
                                             forKey : BookCodingkeys.isbn)
        try super.init(from : decoder)
    }
    
    
    override func encode(to encoder: Encoder)
    throws {
        
        try super.encode(to : encoder)
        
        var jsonContainer = encoder.container(keyedBy: BookCodingkeys.self)
        
        try jsonContainer.encode(isbn ,
                                 forKey : BookCodingkeys.isbn)
    }
}

/**
 `NOTICE` it has the `override` keyword
 
 `override func encode(to encoder: Encoder)`
 `throws { ... }`
 
 because we are overriding the implementation
 in the parent class .
 So , the first thing we need to do , is ,
 We call the parent classes `encode()` function ,
 
 `try super.encode(to : encoder)`
 
 and then we'll take care of the subclass .
 We do this by calling `super.encode` ,
 and this is a _throwing_ method , so we say `try` ,
 and pass the `encoder` along .
 And from here
 the rest of the stuff is stuff you know .
 So we'll create a container ,
 
 `var jsonContainer = encoder.container(keyedBy: BookCodingkeys.self)`
 
 And we have a single property to encode in the subclass ,
 
 `try jsonContainer.encode(isbn ,`
                          `forKey : BookCodingkeys.isbn)`
 
 Now , when we
 encode from
 or decode to
 the subclass type ,
 we should have information that is represented
 both in the sub class and its parent class :
 */

let book = try decoder.decode(Book.self , from : json)

book.isbn // "978-3-16-14841"
book.title // "Some title"
book.id // "ABCD"

let encodedBook = try encoder.encode(book)

print(encodedBook.stringDescription)

/* Prints
 
 {
   "id" : "ABCD",
   "title" : "Some title",
   "isbn" : "978-3-16-148410-0"
 }
 */

/**
 This really covers the basics
 and for the most part ,
 this is what you need to know
 when working with classes .
 */
/**
👉 Continues in PART 2
*/
