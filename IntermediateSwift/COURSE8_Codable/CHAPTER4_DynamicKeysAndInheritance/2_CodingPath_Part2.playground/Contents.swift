import Foundation


/**
 `2 Coding Path`: PART 2 OF 2
 So instead of assigning here
 we'll get rid of that
 and what we can do , is ,
 we can say ☘️
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



struct Library {
    
    struct LibraryCodingKeys: CodingKey {
        
        static var languages = LibraryCodingKeys.init(stringValue : "languages")
        var stringValue: String
        var intValue: Int? { return nil }
        
        
        init?(stringValue: String) { self.stringValue = stringValue }
        
        init?(intValue: Int) { return nil }
    }
    
    
    let languages: [Language]
}



extension Library: Decodable {
    
    init(from decoder: Decoder)
    throws {
        
        let outerContainer = try decoder.container(keyedBy : LibraryCodingKeys.self)
        let languagesContainer = try outerContainer.nestedContainer(keyedBy : LibraryCodingKeys.self ,
                                                                    forKey : LibraryCodingKeys.languages!)
        
        self.languages = try languagesContainer.allKeys.map { (key: Library.LibraryCodingKeys) in
            
            return try languagesContainer.decodeIfPresent(Language.self ,
                                                          forKey: key)!
        }
    }
}



struct Language: Decodable {
    
    enum LanguageCodingKeys: String ,
                             CodingKey {
        case name // ☘️
        case designer
        case released
    }
    
    
    let name: String
    let designer: [String]
    let releaseDate: String
    
    
    init(from decoder: Decoder)
    throws {
        
        let languageContainer = try decoder.container(keyedBy : LanguageCodingKeys.self)
        
//        self.name = languageContainer.codingPath.first!.stringValue // ☘️
        guard
            let _name = languageContainer.codingPath.first
        else {
            let context = DecodingError.Context.init(codingPath : languageContainer.codingPath ,
                                                     debugDescription : "Dynamic language key not found .")
            
            throw DecodingError.keyNotFound(Language.LanguageCodingKeys.name ,
                                            context)
        } // ☘️
        
        self.name        = _name.stringValue // ☘️
        self.designer    = try languageContainer.decode([String].self , forKey : Language.LanguageCodingKeys.designer)
        self.releaseDate = try languageContainer.decode(String.self   , forKey : Language.LanguageCodingKeys.released)
    }
}

/**
 Inside the `else` clause
 we throw a `keyNotFound error` defined on `DecodingError` ,
 But the only issue now is that we can't specify this key — `CodingKey` —
 
 `throw DecodingError.keyNotFound(CodingKey , DecodingError.Context)`
 
 in the first place ,
 since we don't have one .
 A work around solution we could do , is ,
 define a placeholder inside the `LanguageCodingKeys enum`
 that we can pass through :
 
 `case name // ☘️`
 
 And then in here
 — when throwing a `keyNotFound error` —
 we can say
 
 `throw DecodingError.keyNotFound(Language.LanguageCodingKeys.name ,`
                                 `context)`
 
 This ...
 
 `Language.LanguageCodingKeys.name`
 
 ... is the key that was not found .
 When throwing a `keyNotFound error` ,
 we need to provide two pieces of information ,
 both the key — which we just did — and a context .
 
 `let context = DecodingError.Context.init(codingPath : languageContainer.codingPath ,`
                                          `debugDescription : "Dynamic language key not found .")`
 
 The context describes ( A ) the codingPath we have taken so far ,
 as well as ( B ) a debugging description ,
 so let's define one :
 
 `codingPath : languageContainer.codingPath`
 
 And for the `debugDescription`
 we can say something like _Dynamic language key not found_ .
 
 `debugDescription : "Dynamic language key not found ."`

 And then we can pass this context through ,
 
 `throw DecodingError.keyNotFound(Language.LanguageCodingKeys.name ,`
                                 `context)`
 
 So now we managed to throw a decoding error ,
 we have a guard statement that unwraps this .
 And then we can say
 
 `self.name = _name.stringValue // ☘️`
 
 So , it is a bit better . But again ,
 this is not great ,
 because we now have this placeholder here
 
 `case name // ☘️`
 
 that doesn’t refer to the actual key .
 So , the error here ...
 
 `let context = DecodingError.Context.init(codingPath : languageContainer.codingPath ,`
                                          `debugDescription : "Dynamic language key not found .")`
 
 `throw DecodingError.keyNotFound(Language.LanguageCodingKeys.name ,`
                                 `context)`
 
 ... is not very useful ,
 we don't know particularly what key we would fail at ,
 we just know that the `name` key failed .
 And it may fail for some of these instances ,
 it may not fail at others .
 So it is not a very good approach ,
 either way
 these are two approaches to solving the same problem ,
 and it is your call on how to structure this.
 */
