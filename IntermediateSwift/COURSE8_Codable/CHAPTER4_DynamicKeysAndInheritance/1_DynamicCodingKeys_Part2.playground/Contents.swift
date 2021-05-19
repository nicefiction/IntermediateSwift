import Foundation


/**
 `CHAPTER 4`: PART 2 OF 2
 `Dynamic Keys and Inheritance`
 Okay ,
 so we did a bunch of new things here ,
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



struct Language {
    
    let name: String
    let designer: [String]
    let releaseDate: String
}



struct Library {
    
    // MARK: NESTED TYPES
    
    struct LibraryCodingKeys: CodingKey {
        
        static let languages = LibraryCodingKeys.init(stringValue : "languages")!
        var stringValue: String
        var intValue: Int? { return nil }
        
        init?(stringValue: String) { self.stringValue = stringValue }
        
        init?(intValue: Int) { return nil }
    }
    
    
    enum LanguageCodingKeys: String ,
                             CodingKey {
        case designer
        case released
    }
    
    
    // MARK: PROPERTIES
    
    let languages: [Language]
}



extension Library: Decodable {
    
    init(from decoder: Decoder)
    throws {
        
        let keyedDecodingContainer = try decoder.container(keyedBy : Library.LibraryCodingKeys.self)
        
        let languagesContainer = try keyedDecodingContainer.nestedContainer(keyedBy : Library.LibraryCodingKeys.self ,
                                                                            forKey : Library.LibraryCodingKeys.languages)
        
        self.languages = try languagesContainer.allKeys.map { (key: LibraryCodingKeys) in
            
            let languageContainer = try languagesContainer.nestedContainer(keyedBy : LanguageCodingKeys.self ,
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



let decoder = JSONDecoder()
decoder.keyDecodingStrategy = .convertFromSnakeCase

let library = try! decoder.decode(Library.self , from : json)


for language in library.languages {
    
    print(language)
}

/**
 To summarise ,
 using a struct as a `CodingKey` type
 with a very bare-bones implementation
 we were able to create and use keys that are dynamic
 — ones that we don't know beforehand :
 
 `struct LibraryCodingKeys: CodingKey {`
 
    `static let languages = LibraryCodingKeys.init(stringValue : "languages")!`
    `var stringValue: String`
    `var intValue: Int? { return nil }`
 
    `init?(stringValue: String) { self.stringValue = stringValue }`
 
    `init?(intValue: Int) { return nil }`
`}`
 
 We were also able to access information at different depths for a given type .
 For the` Language` type ,
 
 `struct Language {`
     
     let name: String
     let designer: [String]
     let releaseDate: String
 `}`
 
 the `name` property is one level deep in the `json` structure .
 
`"swift": { ... ]`
 
 While the remaining stored properties are initialised
 using values that are present in a dictionary two levels deep :

 `"designer": [ "Chris Lattner" , "Apple Inc" ] ,`
 `"released": "June 2, 2014"`
 
 So we were able to achieve all that
 by mapping over the keys that we didn't know beforehand ,
 
 `self.languages = try languagesContainer.allKeys.map { (key: LibraryCodingKeys) in ... }`
 
 and using the fact that this is a dynamic struct
 that has an initialiser
 that takes any string key ,
 and we use those keys to then access all the information we needed .
 
 `self.languages = try languagesContainer.allKeys.map { (key: LibraryCodingKeys) in`
     
     let languageContainer = try languagesContainer.nestedContainer(keyedBy : LanguageCodingKeys.self ,
                                                                    forKey : key)
     
     let languageName = key.stringValue
     let designer = try languageContainer.decode([String].self , forKey : LanguageCodingKeys.designer)
     let releaseDate = try languageContainer.decode(String.self , forKey: LanguageCodingKeys.released)
     
     return Language(name : languageName ,
                     designer : designer ,
                     releaseDate : releaseDate)
 `}`
 */
/**
 Okay , earlier I said that for the reason
 that these values
 that we need
 are in different depths of information ,
 I said that we couldn't initialise all of this directly inside the `Language` type .
 And maybe you can see _why_ over here .
 So typically ,
 when we initialise something in the `init() decoder `,
 we would get the dictionary that we need , right , using a `container` ,
 and then we would use it to access the values .
 But if we were to pass this `languageContainer` dictionary
 directly in the `init() decoder` to the `Language` type , well ,
 the `name` key is missing , right ,
 because that is encoded in a key that is outside .
 So , earlier I said that for this reason ,
 we couldn't initialise directly
 inside the `Language` type .
 That actually isn't technically true .
 There is a way to achieve this ,
 so let's check it out in the next video .
 */
