import Foundation


/**
 `CHAPTER 4`: PART 1 of 2
 `Dynamic Keys and Inheritance`
 So far we have been working with the assumption
 that we know
 what the keys are in a JSON structure .
 In this video ,
 let's explore a situation
 where the keys are not determined beforehand .
 In addition ,
 we have only worked with structures in our examples .
 Let's spend some time with classes
 to see how they affect the decoding process .
 */



/**
 `1 Dynamic Coding Keys`
 INTRO — We have made an assumption so far
 that every time we parse some JSON
 we know about the keys it will contain .
 This won't always be the case
 and in this video
 we take a look at
 how we parse JSON
 that contains dynamic keys .
 */
/**
 In every example we have looked at so far , one thing was consistent .
 All the keys we used to decode values were defined beforehand .
 So , I have a new playground page here ,
 Now , just for a second , let's go back to our previous example , Wrapper Keys ,
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

/**
 And in here , when we were parsing this , 
 we knew that each search result was wrapped in a key named `"work"` .
 That the best result was accessed using the key name , `"best_book"` , and so on .
 So , we knew the keys beforehand .
 This won't always be the case however .
 So , in this playground page , you'll find a new JSON sample :
 */

let json = """
{
    "languages": {
        "python": {
            "designer": [ "Guido van Rossum" ] ,
            "released": "20 February 1991"
        },

        "java": {
            "designer": [ "James Gosling" ] ,
            "released": "May 23, 1995"
        },

        "swift": {
            "designer": [ "Chris Lattner" , "Apple Inc" ] ,
            "released": "June 2, 2014"
        },

        "ruby": {
            "designer": [ "Yukihiro Matsumoto" ] ,
            "released": "1995"
        }
    }
}
""".data(using: .utf8)!

/**
 So , what is so different about this `json` ?
 Let's say you could query a Treehouse API
 to see what languages we offered content in ,
 and we send back a JSON response with a series of languages
 and some information about each language .
 In this JSON response ,
 the language name
 
 `"swift": { ... } ,`
 
 is the key itself for any of the underlining information .
 So , at the top , we have a `wrapper key` named `"languages"` ,
 
 `"languages": { ... }`
 
 but then , each subsequent key is the language name itself .
 
 `"python": { ... } ,`
 `"java": { ... } ,`
 `"swift": { ... } ,`
 `"ruby": { ... } `
 
 And again , there is no way to know these keys beforehand , they are not predefined .
 If you were to implement `init() decoder` to look for these specific keys ,
 and let's say we decided to stop teaching Python and we removed the python key ,
 then that would break your implementation .
 
 `NOTE` :
 As an aside , before we go down the path of parsing this ,
 I should tell you that this JSON structure here
 — with dynamic keys , and the way this specific sample is structured —
 is purely a choice made by the authors of the API .
 
 Now ,
 we could have designed a JSON object for each value
 with a `"name"` key
 that tells you the name of the language as a value .
 But you will run into these situations ,
 so we need to figure out how to work with JSON like this .
 We can't do it with any of the knowledge that we have at hand .
 Everything we have written so far
 has depended on the keys being statically defined in the `CodingKeys`
 but these keys ( we have now ) are dynamic . For that ,
 we have to change our approach as to how we define keys .
 In the playground , we also have two simple types to model this data :
 */

struct Language {
    
    let name: String
    let designer: [String]
    let releaseDate: String
}

/**
 First , is a `Language` struct
 that models information about the programming language .
 */

/*
struct Library {
    
    let languages: [Language]
}
*/

/**
 And second , we have a `Library` struct
 that is just a wrapper around an array of `languages` .
 Before we get to defining keys ,
 I should point out that
 nearly all the information modelled by `Language`
 exist inside each nested dictionary .
 So , bringing this JSON snippet up on screen ,

 `"swift": {`
     `"designer": [ "Chris Lattner" , "Apple Inc" ] ,`
     `"released": "June 2, 2014"`
 `},`
 
 you can see that you have a key `"swift"` ,
 but then the keys inside this nested dictionary that we get as a value ,
 are `"designer"` and `"released"` .
 So , `designer `and `released` are modelled in the `Language` type ,
 but so is the `name` :
 
 `struct Language {`
     
     let name: String
     let designer: [String]
     let releaseDate: String
 `}`
 
 So what we have here ,
 aside from dynamic keys , is ,
 that our `Language` type ,
 models data that is stored at different depths in the `json` structure .
 So , `"swift"` is at a given level of depth .
 
 `"swift": { ... }`
 
 That is a name value for the `name` stored property .
 
 `let name: String`
 
 And then , the rest of the information that the `Language` type needs

 `let designer: [String]`
 `let releaseDate: String`
 
 is one level deeper :
 
 `"designer": [ "Chris Lattner" , "Apple Inc" ] ,`
 `"released": "June 2, 2014"`
 
 For this reason ,
 it is tricky to initialise the `Language` type in a `decoder` in the type .
 The key — that is also the `name` stored property value
 
 `struct Language {`
     
     let name: String
     let designer: [String]
     let releaseDate: String
 `}`
 
 — is in an outer container ,
 
 `"python": { ... } ,`
 `"java": { ... } ,`
 `"swift": { ... } ,`
 `"ruby": { ... } `
 
 so , we can't safely access it from the initialiser .
 Instead , we are going to focus on initialising `Language` from the `Library` type .
 You will see what I mean as we actually implement these things .
 Okay , first things first .
 We need a key type ,
 and we are going to define this inside the `Library` struct :
 This time , we are going to define two `CodingKey` conforming types ,
 and I'll handle the easy one first :
 */

/*
struct Library {
    
    // MARK: NESTED TYPES
    
    enum LanguageCodingKeys: String ,
                             CodingKey {
        case designer
        case releaseDate
    }
    
    
    
    // MARK: PROPERTIES

    let languages: [Language]
}
*/

/**
 The `LanguageCodingKeys` enum has `String` raw values ,
 and it conforms to the `CodingKey` protocol .
 This type is going to model the values that we get
 from inside of each of these nested dictionaries :
 
 `"swift": {`
     `"designer": [ "Chris Lattner" , "Apple Inc" ] ,`
     `"released": "June 2, 2014"`
 `},`
 
 So , the keys here are
 `"designer"` and `"released"` .
 
 `NOTE` the absence of the `name` key here .
 
 `case designer`
 `case releaseDate`
 
 We won't need it since that nested dictionary
 
 `"designer": [ "Chris Lattner" , "Apple Inc" ] ,`
 `"released": "June 2, 2014"`
 
 doesn't actually contain the name of the programming language .
 */
/**
 For the second — technically the first — `CodingKey` conforming type ,
 instead of defining an `enum`
 we are going to use a `struct` :
 */

/*
struct Library {
    
    struct LibraryCodingKeys: CodingKey {}
    
    
    enum LanguageCodingKeys: String ,
                             CodingKey {
        case designer
        case releaseDate
    }
    
    
    let languages: [Language]
}
 */

/**
 The `LibraryCodingKeys` struct conforms to `CodingKey` .
 Previously , when we defined an enum to act as our `CodingKey` type ,
 we didn't provide an implementation for the `CodingKey` protocol , and instead ,
 relied on the protocol's default implementation .
 Here — in the `LibraryCodingKeys` struct —
 we are going to provide an implementation that allows us to handle dynamic keys .
 If we COMMAND click on on the `CodingKey` type
 to jump to the protocol definition ,
 
 `public protocol CodingKey : CustomDebugStringConvertible ,`
                             `CustomStringConvertible {`
 
    `var stringValue: String { get } // 1`
    `init?(stringValue: String) // 2`
 
    `var intValue: Int? { get } // 3`
    `init?(intValue: Int) // 4`
 `}`
 
 (`1`) The first is a property
 named `stringValue` .
 This property represents the `String` to use as a key in a name or a keyed collection .
 Our enum raw values that we have been defining so far
 served as the `stringValue` . So , using the `stringValue` property ,
 the type was able to figure out what `String` to use as a key when searching for values .
 (`2`) Next is an initialiser . This protocol defines an initialiser
 that creates a new instance of the type from a given `String` .
 This is the bit that is relevant to us . It allows us to define a key type dynamically
 by passing it as a `String` .
 ( `3` & `4 `) The rest of the protocol defines similar requirements ,
 except for keys that are defined by integers .
 Integer-indexed collections , to be specific . So , we are just going to ignore this , and say `nil` .
 
 Let's go back to the `LibraryCodingKeys` struct ,
 and add these requirements :
 */

/*
struct Library {
    
    struct LibraryCodingKeys: CodingKey {
        
        var stringValue: String
        
        var intValue: Int? { return nil }
   
 
        init?(stringValue: String) { self.stringValue = stringValue }
        
        init?(intValue: Int) { return nil }
    }
    
    
    enum LanguageCodingKeys: String ,
                             CodingKey {
        case designer
        case releaseDate
    }
    
    
    let languages: [Language]
}
 */

/**
 So , first is that `stringValue` property .
 Next , is the initialiser that takes a `stringValue` , and does something with it .
 And here , we are simply going to assign it to the stored property .
 For both the integer related requirements ,
 since we don't care about these for this example
 — we have a named collection , not an integer index collection —
 we are going to return `nil` . So we'll say
 
 `var intValue: Int? { return nil }`
 
 because this is an optional `Int?` .
 And then , the initialiser that takes an `intValue` is also a failable one ,
 so we can return `nil` :
 
 `init?(intValue: Int) { return nil }`
 
 Okay , and that is all we need for the type — the `LibraryCodingKeys` struct .
 Now , we can define both static and dynamic keys .
 We have one key that we can statically define .
 If we go back to the `json` at the top ,
 
 `let json = """`
 `{`
     `"languages": {`
         `"python": {`
             `"designer": [ "Guido van Rossum" ] ,`
             `"released": "20 February 1991"`
         `},`

         `"java": {`
             `"designer": [ "James Gosling" ] ,`
             `"released": "May 23, 1995"`
         `},`

         `"swift": {`
             `"designer": [ "Chris Lattner" , "Apple Inc" ] ,`
             `"released": "June 2, 2014"`
         `},`

         `"ruby": {`
             `"designer": [ "Yukihiro Matsumoto" ] ,`
             `"released": "1995"`
         `}`
     `}`
 `}`
 `""".data(using: .utf8)!`
 
 we know that all the information we care about
 is going to be nested inside this `"languages"` key . So ,
 let's add that in as a statically defined key :
 */

struct Library {
    
    // MARK: NESTED TYPES
    
    struct LibraryCodingKeys: CodingKey {
        
        // MARK: PROPERTIES
        
        static let languages = LibraryCodingKeys.init(stringValue : "languages")!
        var stringValue: String
        
        
        
        // MARK: COMPUTED PROPERTIES
        
        var intValue: Int? { return nil }
        
        
        
        // MARK: INITIALIZER METHODS
        
        init?(stringValue: String) {
            
            self.stringValue = stringValue
        }
        
        
        init?(intValue: Int) {
            
            return nil
        }
    }
    
    
    enum LanguageCodingKeys: String ,
                             CodingKey {
        case designer
        case released
    }
    
    
    
    // MARK: PROPERTIES
    
    let languages: [Language]
}

/**
 We use the failable initialiser
 that takes a `stringValue`
 to pass in a `String`
 that describes the key .
 And this creates an optional type , remember ,
 because our initialiser is failable , so I unwrap it here :

 `static let languages = LibraryCodingKeys.init(stringValue : "languages")!`
 
 Okay , now , let's use this in an implementation of `decodable` .
 So after the `decoder` , I'll say
 */

let decoder = JSONDecoder()

/*
extension Library: Decodable {
    
    init(from decoder: Decoder)
    throws {
        
        let outerContainer = try decoder.container(keyedBy : LibraryCodingKeys.self)
        
        let innerContainer = try container.nestedContainer(keyedBy : LibraryCodingKeys.self ,
                                                           forKey : LibraryCodingKeys.languages)
    }
}
*/

/**
 So like before ,
 we create a `KeyedDecodingContainer` using our struct as the key type :
 
 `let outerContainer = try decoder.container(keyedBy : LibraryCodingKeys.self)`
 
 This defines a container that wraps the entire `json` structure .
 Now , all the data we want . is nested inside a dictionary
 that we access using the `"languages"` key , so let's get that :
 
 `let innerContainer = try container.nestedContainer(keyedBy : LibraryCodingKeys.self ,`
                                                    `forKey : LibraryCodingKeys.languages)`
 So just to recap ,
 we are creating an innernested container .
 
 `NOTE` that for the `keyedBy` argument ,
 we are going to provide the same type `LibraryCodingKeys` .
 But the key to access this inner container , is , `.languages` .
 
 So here ,
 when we created that `static` propriety earlier ,
 it is of the same type that it is defined in :
 
 `struct Library {`
     
     struct LibraryCodingKeys: CodingKey {
         
         static let languages = LibraryCodingKeys.init(stringValue : "languages")!
 
        ...
    }
    ...
 `}`
 
 So , inside this `innerContainer` ,
 
 `let innerContainer = try container.nestedContainer(keyedBy : LibraryCodingKeys.self ,`
                                                    `forKey : LibraryCodingKeys.languages)`
 each key is the name of a programming language .
 But we don't know what these keys are .
 What we are going to do , is ,
 iterate over a property on the container — named `allKeys` —
 that gives us access to every key .
 The compiler will handle
 converting each key
 to an instance of `LibraryCodingKeys`
 using that `stringValue` initialiser we defined .
 
 `init?(stringValue: String) { self.stringValue = stringValue }`
 
 Since all the initialiser does , is ,
 assign the `String` to the internal stored property `stringValue` ,
 we can use the property to get the actual value of the key
 and assign it back to the language's main stored property on the instance
 we are trying to create .
 
 `static let languages = LibraryCodingKeys.init(stringValue : "languages")!`
 
 So , we say ,
 */

/*
extension Library: Decodable {
    
    init(from decoder: Decoder)
    throws {
        
        let outerContainer = try decoder.container(keyedBy : LibraryCodingKeys.self)
        
        let innerContainer = outerContainer.nestedContainer(keyedBy : LibraryCodingKeys.self ,
                                                            forKey : LibraryCodingKeys.languages)
        
        self.languages = try innerContainer.allKeys.map { key in }
    }
}
 */

/**
 `self.languages` , that is the only property we need to initialise .
 And here , we say `languagesContainer` . So , that is all of this information ,

 `"python": {`
     `"designer": [ "Guido van Rossum" ] ,`
     `"released": "20 February 1991"`
 `},`

 `"java": {`
     `"designer": [ "James Gosling" ] ,`
     `"released": "May 23, 1995"`
 `},`

 `"swift": {`
     `"designer": [ "Chris Lattner" , "Apple Inc" ] ,`
     `"released": "June 2, 2014"`
 `},`

 `"ruby": {`
     `"designer": [ "Yukihiro Matsumoto" ] ,`
     `"released": "1995"`
 `}`
 
 that is encoded inside the `innerContainer` . And here ,
 instead of saying `decode` , this time we are going to call `allKeys` .
 This returns all the keys that are defined
 inside the `innerContainer` .
 And we don't know what these keys are , we don't care .
 We are going to map over them , and do something with each key .
 With each key ,
 we are going to create an instance of `Language`
 and assign it to our stored property .
 We can do all this at once by mapping over ,
 which is what we are doing here :
 
 `self.languages = try innerContainer.allKeys.map { key in }`
 
 So we don't know what each key is ,
 but we can access it
 using the `key` variable we have defined .
 This `key` is of type of `LibraryCodingKeys` .
 Each `key` has , as a value , a dictionary ,
 which you can inspect .
 Or you can wrap your mind around by looking at the `json` :

 `"swift": {`
     `"designer": [ "Chris Lattner" , "Apple Inc" ] ,`
     `"released": "June 2, 2014"`
 `},`
 
 So . this ...
 
 `"swift"`
 
 ... is a `key` ,
 that ...
 
 `"designer": [ "Chris Lattner" , "Apple Inc" ] ,`
 `"released": "June 2, 2014"`
 
 ... is the dictionary ,
 To access the data that is in this dictionary ,
 we are going to use each `key` , defined here in the closure .
 
 `self.languages = try innerContainer.allKeys.map { key in }`
 
 We don't know what the key is ,
 but we can use it
 to create another keyed container
 to represent that final inner dictionary .
 So we'll say ,
 */

extension Library: Decodable {
    
    init(from decoder: Decoder)
    throws {
        
        let outerContainer = try decoder.container(keyedBy : Library.LibraryCodingKeys.self)
        
        let innerContainer = try outerContainer.nestedContainer(keyedBy : Library.LibraryCodingKeys.self ,
                                                                forKey : Library.LibraryCodingKeys.languages)
        
        
        self.languages = try innerContainer.allKeys.map { (key: LibraryCodingKeys) in
            
            let languageContainer = try innerContainer.nestedContainer(keyedBy : LanguageCodingKeys.self ,
                                                                       forKey : key)
            
            let languageName = key.stringValue
            let designer = try languageContainer.decode([String].self , forKey : LanguageCodingKeys.designer)
            let releaseDate = try languageContainer.decode(String.self , forKey: LanguageCodingKeys.released)
            
            return Language(name : languageName ,
                            designer : designer ,
                            releaseDate : releaseDate)
        }
    }
}

/**
 We are saying `LanguageCodingKeys.self` ,
 because we are in that inner dictionary .
 So this time , for the `CodingKey` conforming type ,
 we are going to pass in the `LanguageCodingKeys enum`
 and the key to get to this inner dictionary .
 
 `struct Library {`
    `...`
    `enum LanguageCodingKeys: String ,`
                             `CodingKey {`
        `case designer`
        `case released`
 `}`
 
 From there , the rest is straightforward .
 First ,
 we'll get the `languageName` by accessing the `stringValue` property on the `key`
 since the type is the struct that we have defined :
 
 `let languageName = key.stringValue`
 
 Okay , so we have a value for the `languageName` stored property .
 For the `designer` stored property — that will contain an array of strings —
 we can ask the `decoder` to `decode()` to that type directly :
 
 `let designer = try languageContainer.decode([String].self , forKey : LanguageCodingKeys.designer)`
 
 And then , for the `releaseDate` , we'll decode into a `String` :
 
 `let releaseDate = try languageContainer.decode(String.self , forKey: LanguageCodingKeys.released)`
 
 Using these values that we have obtained ,
 we can create and return an instance of `Language` :
 
 `return Language(name : languageName ,`
                 `designer : designer ,`
                 `releaseDate : releaseDate)`

 Okay , and that should wrap up our `init() decoder` .
 So , what we are doing here , is ,
 we are mapping over each key .
 And for each key ,
 we are grabbing the inner container ,
 grabbing the values ,
 creating an instance of language ,
 and returning it in the closure
 so that when we map through all of it ,
 
 `self.languages = try languagesContainer.allKeys.map { ... }`
 
 `self.languages` contains
 an array of `Language` .
    Okay , let's give this a try .
 So , we have a `decoder` ,

 `let decoder = JSONDecoder()`
 
 At the bottom , we can say
 */

decoder.keyDecodingStrategy = .convertFromSnakeCase

let library = try! decoder.decode(Library.self , from : json)


for language in library.languages {
    
    print(language)
}

/* Prints
 
 Language(name: "swift", designer: ["Chris Lattner", "Apple Inc"], releaseDate: "June 2, 2014")
 Language(name: "java", designer: ["James Gosling"], releaseDate: "May 23, 1995")
 Language(name: "ruby", designer: ["Yukihiro Matsumoto"], releaseDate: "1995")
 Language(name: "python", designer: ["Guido van Rossum"], releaseDate: "20 February 1991")
 */

/**
 And if we do something like
 */

for language in library.languages {
    
    print(language.name)
}

/* Prints
 
 ruby
 java
 python
 swift
 */

/**
 In the console ,
 you should see each language name printed out ,
 which should match the key as defined .
 */
/**
👉 Continues in PART 2
*/



print("Debug")
