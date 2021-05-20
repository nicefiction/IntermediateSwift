import Foundation


/**
 `2 Coding Path`: PART 1 OF 2
 INTRO — In the last video we looked at a situation
 where a dynamic key meant
 we had to use a wrapper object to decode to our underlying type .
 In this video
 let's look at
 a different solution to the same problem
 using a property on containers .
 `[ NOT RECOMMENDED by Pasan ]`
 */
/**
 In the last video ,
 we worked through an example where we initialised
 a series of types where the information necessary for the type was present
 at different depths in the JSON structure .
 Because of this , we took a different approach to solving the problem .
 We used a struct as the `CodingKey` conforming type to define our keys .
 And we did all of the decoding and initialisation in a wrapper object ,
 rather than the `Language` type itself .
 There is a way we can do it inside the `Language` type ,
 so let's refactor this code .
 Okay ,
 let's go down to the `Language` type ,
 and in here
 let’s define our coding keys .
 Now ,
 we already defined an enum inside the `Library` type to handle this ,
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

/*
struct Language {
    
    enum LanguageCodingKeys: String ,
                             CodingKey {
        case designer
        case releaseDate
    }
 
 
    let name: String
    let designer: [String]
    let releaseDate: String
}
*/


struct Library {
    
    struct LibraryCodingKeys: CodingKey {
        
        static let languages = LibraryCodingKeys.init(stringValue : "languages")!
        var stringValue: String
        var intValue: Int? { return nil }
        
        
        init?(stringValue: String) { self.stringValue = stringValue }
        
        init?(intValue: Int) { return nil }
    }
    
    
//    enum LanguageCodingKeys: String ,
//                     CodingKey {
//        case designer
//        case releaseDate
//    }
    
    
    let languages: [Language]
}

/**
 `NOTE`:
 I am still not going to define the `name` key
 inside the `LanguageCodingKeys enum`
 and we’ll see why .
 
 Okay , now we have a bunch of errors , we'll get to that .
 Next ,
 let's make this type conform to `Decodable` ,
 and implement an `init() decoder` .
 I will do that in the type itself rather than in an `extension` :
 So first we define a `keyedDecodingContainer` .
 Using this container along with the `LanguageCodingKeys` ,
 let's initialise the `designer` and `releaseDate` properties ,
 */

/*
struct Language: Decodable {
    
    enum LanguageCodingKeys: String ,
                             CodingKey {
        case designer
        case releaseDate
    }
    
    
    let name: String
    let designer: [String]
    let releaseDate: String
    
    
    init(from decoder: Decoder)
    throws {
        
        let keyedDecodingContainer = try decoder.container(keyedBy : LanguageCodingKeys.self)
        
        self.designer    = try keyedDecodingContainer.decode([String].self , forKey : LanguageCodingKeys.designer)
        self.releaseDate = try keyedDecodingContainer.decode(String.self ,   forKey : LanguageCodingKeys.releaseDate)
    }
}
*/

/**
 Okay , so we all ready knew how to do this , nothing new .
 The issue , again , is ,
 _how to decode the value needed for the name property ?_
 The `json` snippet that is given to the `Language` type ,
 — when using the `decoder` — is , this right here ,
 
 `"swift": {`
     `"designer": [ "Chris Lattner" , "Apple Inc" ] ,`
     `"released": "June 2, 2014"`
 `},`
 
 So , the `decoder` is going to grab using this key
 
 `"swift"`
 
 — whatever value we have —
 and then pass it in a `decoder` inside `Language` .
 As you can see ,
 
 `"designer": [ "Chris Lattner" , "Apple Inc" ] ,`
 `"released": "June 2, 2014"`
 
 there is no `"language"` key here ,
 we don't know a `"swift"` key ,
 we have talked about this , these are dynamic .
 Instead of using the key ,
 we can actually rely on the property of the container itself .
 So , going back down to the `Language` struct ,
 here we would say ,
 */

struct Language: Decodable {
    
    enum LanguageCodingKeys: String ,
                             CodingKey {
        case designer
        case released
    }
    
    
    let name: String
    let designer: [String]
    let releaseDate: String
    
    
    init(from decoder: Decoder)
    throws {
        
        let keyedDecodingContainer = try decoder.container(keyedBy : LanguageCodingKeys.self)
        
        self.name        = keyedDecodingContainer.codingPath.first!.stringValue
        self.designer    = try keyedDecodingContainer.decode([String].self , forKey : LanguageCodingKeys.designer)
        self.releaseDate = try keyedDecodingContainer.decode(String.self ,   forKey : LanguageCodingKeys.released)
    }
}

/**
 Decoders and containers have a property named `codingPath`
 that is an array of types conforming to `CodingKey` .
 The values in this array represent the path the decoder took to get to the `json` ,
 that we are working with inside the initialiser . So here ,
 
 `self.name = keyedDecodingContainer.codingPath.first!.stringValue`
 
 we are going to grab the first value in the array .
 And since this
 
 `first!`
 
 is a key
 — it conforms to `CodingKey` [OLIVIER : OPTION click on first!] —
 we can call `stringValue` to get the actual value .
 
 `NOTE`:
 The `first` property — on any array that you call it on — returns an optional ,
 but we are force unwrapping it now to see if this works .
 
 Okay ,
 since the decoding happens in the `Language` type
 we can refactor `init() decoder` in the `Library` type to be much more concise .
 So ,
 going back to that closure ,
 we can eliminate everything inside here :
 */

extension Library: Decodable {
    
    init(from decoder: Decoder)
    throws {
        
        let keyedDecodingContainer = try decoder.container(keyedBy : Library.LibraryCodingKeys.self)
        
        let languagesContainer = try keyedDecodingContainer.nestedContainer(keyedBy : Library.LibraryCodingKeys.self ,
                                                                            forKey : Library.LibraryCodingKeys.languages)
        
        self.languages = try languagesContainer.allKeys.map { (key: LibraryCodingKeys) in
            
//            let languageContainer = try languagesContainer.nestedContainer(keyedBy : LanguageCodingKeys.self , forKey : key)
//
//            let languageName = key.stringValue
//            let designer = try languageContainer.decode([String].self , forKey : LanguageCodingKeys.designer)
//            let releaseDate = try languageContainer.decode(String.self , forKey: LanguageCodingKeys.released)
            
//            return Language(name : languageName ,
//                            designer : designer ,
//                            releaseDate : releaseDate)
            
            return try languagesContainer.decodeIfPresent(Language.self , forKey : key)!
        }
    }
}

/**
 So now , once we get to that container
 using the `key` ,
 we are just going to pass it into the` Language` type to handle it from there :
 */

let decoder: JSONDecoder = JSONDecoder()

let library = try decoder.decode(Library.self , from : json)


for language in library.languages {
    
    print(language.name)
}

/* Prints :
 
 java
 swift
 python
 ruby
 */

/**
 Okay , the code compiles ,
 and we are back to a working example .
 So , what we did here , is still the same as we did in the last video .
 You should understand everything else that is going on here .
 But instead of manually parsing each key value pair ,
 what we did , was ,
 rely on the fact that the container keeps track of
 the path we took to arrive at the container .
 I honestly don't know if I am okay with this approach though .
 Because if you go back up to the top here ,
 
 `struct Language: Decodable {`
 
    `...`
 
    `init(from decoder: Decoder)`
    `throws {`
 
        let keyedDecodingContainer = try decoder.container(keyedBy : LanguageCodingKeys.self)

        self.name        = keyedDecodingContainer.codingPath.first!.stringValue
        self.designer    = try keyedDecodingContainer.decode([String].self , forKey : LanguageCodingKeys.designer)
        self.releaseDate = try keyedDecodingContainer.decode(String.self ,   forKey : LanguageCodingKeys.released)
    `}`
 `}`
 
 you'll see that I am force unwrapping , first of all ,
 
 `self.name = keyedDecodingContainer.codingPath.first!.stringValue`
 
 and that is a bad sign .
 A better approach would be to use a `guard` statement
 to check and throw an error
 if the key doesn't exist in the array .
 Now , let's do that in a second
 but before we do , another thing to point out , is ,
 that there is no indication
 that the container ,
 that where it contains the key that we want .
 In the documentation it doesn't say it is , like , the first or the last .
 And if you inspect all of the values here ,
 
 `self.name = keyedDecodingContainer.codingPath.first!.stringValue`
 
 `codingPath` first of all ,
 only contains one value inside this decoder .
 
 `.first!`
 
 Even though we accessed two keys to get here ,
 
 `"languages": {`
     `...`
 
     `"swift": {`
         `"designer": [ "Chris Lattner" , "Apple Inc" ] ,`
         `"released": "June 2, 2014"`
     `},`

     `...`
 `}`
 
 we got the `"languages"` key
 and then an individual language key .
 
 `"swift":`
 
 It does not hold on to this one — `"languages"` — though ,
 which is okay
 we don't need that
 but these are not documented things necessarily .
 So , I don’t feel great relying on this approach ,

 `self.name = keyedDecodingContainer.codingPath.first!.stringValue`
 
 Let's refactor this a tiny bit .
 */
/**
👉 Continues in PART 2
*/









print("Debug")
