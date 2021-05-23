import Foundation


/**
 `2 The Decodable Protocol`: PART 1 of 2
 INTRO — Let's peel back the magic in the previous video
 and understand how this was implemented
 using the `Decodable` and `CodkingKey protocols` .
 */
/**
 Much of the magic we saw in the previous video
 is handled by the `Codable` protocol .
 `Codable` is not a single protocol but a `composition type` .
 If you COMMAND click on the Codable type in the struct definition , ...
 */

let json = """
{
    "name" : "Dorothy" ,
    "id" : 1 ,
    "role" : "designer"
}
""".data(using : .utf8)

/*
 struct Employee: Codable {
 
    let name: String
    let id: Int
    let role: String
 }
 */

/**
 ... you'll see , once we jump there ,
 that the type is an alias for two underlying types ,
 `Decodable` and `Encodable` :
 */

// public typealias Codable = Decodable & Encodable

/**
 So, let's focus on `Decodable` here ,
 since what we did was decode some JSON into a type ,
 COMMAND click on the `Decodable` type
 */

/*
public protocol Decodable {

    /// Creates a new instance by decoding from the given decoder.
    ///
    /// This initializer throws an error if reading from the decoder fails, or
    /// if the data read is corrupted or otherwise invalid.
    ///
    /// - Parameter decoder: The decoder to read data from.
    init(from decoder: Decoder) throws
}
*/

/**
 As is evident , though ,
 from the code that we just wrote ,
 we didn't need to provide an implementation .
 A default implementation ,
 provided via an extension of the protocol ,
 handles everything for us .
 This is what makes `Codeable` , and the underlying types , a delight .
 In many cases , the default implementations will handle everything for you ,
 and the json parsing just happens .
 Of course , this magic doesn't teach us how it actually works
 so let's implement this initialiser and associated functionality from scratch .
    Now the first step isn't actually an initialiser ,
 but a nested type .
 Inside the `Employee` type ,
 we define an `enum` named `CodingKeys` with a raw value of type `String` ...
 */

/*
 struct Employee: Codable { // ERROR : Type 'Employee' does not conform to protocol 'Decodable'
    
    enum CodingKeys: String {} // ERROR : An enum with no cases cannot declare a raw type
    
    let name: String
    let id: Int
    let role: String
 }
 */

/**
 ... When we do that
 you will see an error in your playground .
 I'll explain why and how to fix that in just a second .
    In this enum ,
 we are going to define members
 where each member maps to a stored property
 and its raw value
 maps
 what the corresponding key is in the Json data .
 
 `let json = """`
 `{`
     `"name" : "Dorothy" ,`
     `"id" : 1 ,`
     `"role" : "designer"`
 `""".data(using : .utf8)`
 
 For example ,
 the first stored property is `name` ,
 
 `struct Employee: Codable {`
    
    `let name: String`
    `let id: Int`
    `let role: String`
 `}`
 
 to map for that ,
 you will add a new member with the exact same name ,
 and that is _name_ .
 This member now maps with the stored property inside the `Employee` type .
 When I say _maps_ ,
 again , I mean that it has to have the _exact same_ name
 as the stored property .
 This is how the `decoder` knows
 which property to look for
 when assigning it a value .
 _But how does the `decoder` know_
 _which json key contains a value_
 _that is going to end up inside of this property ?_
 That is what the `raw value` on these enum members are for .
 So next ,
 we need to provide a raw value for this enum member
 that lets us describe the JSON key
 that the `decoder` will have to parse .
 */

/*
struct Employee: Codable { // ERROR : Type 'Employee' does not conform to protocol 'Decodable'
    
    enum CodingKeys: String {
        
        case name
        case id
        case role
    }
    
    
    let name: String
    let id: Int
    let role: String
}
 */

/**
 So here , the key is also _"name"_ .
 [ OLIVIER : Well , let’s add "name" as the raw value for the name member . ]
 Okay , and to highlight this example even more ,
 let's do this for the remaining stored properties .
 So , the next stored property is `id` .
 We'll create an enum member with the same name — so `id` .
 And then , it has to map to the json key
 that we want to parse when looking for a value for this stored property .
 And here the json key is also called "id" so we'll set the raw value to that .
 And finally , we'll do the same for `role` .
    The reason we have an error here , is ,
 because , by default ,
 the `Codable` type provides an implementation for this enum already .
 To indicate that we want the type we just wrote
 — OLIVIER : this enum — to fulfill this role ,
 we are going to make it conform to another protocol , `CodingKey` :
 */

/*
 struct Employee: Codable {
    
    enum CodingKeys: String ,
                     CodingKey {
        case name = "name"
        case id = "id"
        case role = "role"
    }
    
    
    let name: String
    let id: Int
    let role: String
 }
 */

/**
 `NOTE` :
 Don't get too hung up on the naming of the protocol
 and the naming of the type .
 The protocol is `CodingKey` ,
 but you can name your enum type whatever you want .
 
 Okay , so no more errors ,
 and our code still executes correctly :
 */

/*
 let decoder = JSONDecoder()
 
 let employee = try decoder.decode(Employee.self ,
                                   from : json!)
 employee.name // "Dorothy"
 employee.id // 1
 employee.role // "designer"
 */

/**
 As you can see , we still get the values out ,
 which means that the `decoder`
 is able to use the enum we defined
 (`A`) to parse the JSON ,
 (`B`) figure out which key maps to which stored property ,
 and then (`C`) assign the value over .
    `CodingKeys` — our enum type —
 or any type that conforms to the `CodingKey` protocol
 function as this bridge between the decoded JSON
 and the properties on the model type .
 _But how does that last step happen ?_
 _Even if the decoder knows_
 _how to map keys to properties ,_
 _how does it do it ?_
 This final step happens in the initialiser .
 Let’s write a custom initialiser
 so we can see how it works .
 The initialiser we need takes a `Decoder` type ,
 and this is a _throwing initializer_ :
 */

// init(from decoder: Decoder) throws {}

/**
 Inside the initialiser ,
 the first thing we are going to do , is ,
 ask the `decoder` — that we are provided with —
 to create a `decoding container` .
 A decoding container coordinates
 between the decodable type — `Employee` in our case —
 and a `decoder`
 by making properties of the type accessible .
 There are several types of decoding containers
 depending on how that JSON that we want to parse is structured :
 
 (`1`)  A`SingleValueDecodingContainer`
 handles the decoding of a single unkeyed value .
 (`2`) An`UnkeyedDecodingContainer` coordinates
 decoding
 into a type
 sequentially
 without the use of keys .
 Think of it as if your JSON was an array of stuff that didn't have keys ,
 then we would use an `UnkeyedDecodingContainer` .
 We'll look at both of these situations later .

 Our JSON , if we go back to it ,
 
 `struct Employee: Codable {`
    
    `let name: String`
    `let id: Int`
    `let role: String`
 `}`
 
 resembles a _dictionary_
 and our decodable type also has keys ,
 so what we want is a `KeyedDecodingContainer` .
 We are going to ask the `decoder`
 to create an instance
 using the keys we have defined
 in the `CodingKeys enum` :
 */

/*
 struct Employee: Codable {
    
    enum CodingKeys: String ,
                     CodingKey {
        case name = "name"
        case id = "id"
        case role = "role"
    }
    
    
    let name: String
    let id: Int
    let role: String
    
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy : CodingKeys.self)
        
        // ERROR : Return from initializer without initializing all stored properties .
    }
 }
*/

/**
 When indicating what type defines the keys ,
 we provide the type itself as an argument
 
 `CodingKeys.self`
 
 just like we did when we passed in the model
 that we wanted to decode into ,
 So here
 
 `let container = try decoder.container(keyedBy : CodingKeys.self)`
 
 we are saying `CodingKeys.self`
 to represent the _type_
 and not an _instance_ .
 
 `NOTE` :
 Know that this is a throwing method ,
 so we are going to use `try` here .
 But , because the initialiser itself is throwing ,
 we don't need to handle errors here .
 
 So , this `container` now knows about our stored properties .
 Because we have defined the keys within this enum ,
 
 `enum CodingKeys: String ,`
                  `CodingKey {`
     `case name = "name"`
     `case id = "id"`
     `case role = "role"`
 `}`
 
 and we have passed the keys when creating the `container` ,
 
 `let container = try decoder.container(keyedBy : CodingKeys.self)`
 
 it — OLIVIER : the `container` — knows about the JSON as well .
 So it forms this bridge between the —OLIVIER : `CodingKeys`— type and the JSON .
 Once we have the `container` ,
 since it is a bridge ,
 we can ask it to turn JSON into values for each property .
    Now , there is still a chance that all of this can fail .
 A key that we specified in the `CodingKeys enum`
 might be missing from a JSON payload , for example .
 To take that into account ,
 each attempt at decoding a specific key-value pair is also a throwing operation ,
 so we need to call `try` :
 */

struct Employee: Codable {
    
     // ///////////////////
    //  MARK: NESTED TYPES
    
    enum CodingKeys: String ,
                     CodingKey {
        case name
        case id
        case role
    }
               
    
    
     // /////////////////
    //  MARK: PROPERTIES
    
    let name: String
    let id: Int
    let role: String
    
    
    
     // /////////////////////////
    //  MARK: INITIALZER METHODS
    
    init(from decoder: Decoder)
    throws {
        
        let keyedDecodingContainer = try decoder.container(keyedBy : CodingKeys.self)
        
        self.name = try keyedDecodingContainer.decode(String.self , forKey : CodingKeys.name)
        self.id   = try keyedDecodingContainer.decode(Int.self    , forKey : CodingKeys.id)
        self.role = try keyedDecodingContainer.decode(String.self , forKey : CodingKeys.role)
    }
}

/**
 Let's start by tackling the `name` stored property first .
 To the `name` stored property
 we are going to ask the `keyedDecodingContainer` to decode the JSON .
 To decode the JSON , we need to provide two pieces of information :
 (`1`) _What is the type of the value going to be ?_
 _What type are we trying to assign to the stored property that is ?_
 And (`2`) _what key do we need to use ?_
 
 `self.name = try keyedDecodingContainer.decode(String.self , forKey : CodingKeys.name)`
 
 (`1`) So here , the type is `String` .
 We say `String.self` to represent the type
 and not an instance .
 And (`2`) the key we want to use here to get to that value is `name` .
 We say `.name` for this key argument
 because the compiler can infer our enum type ,
 since we provided that information earlier .
 And again , since it is an enum ,
 we can use the short hand syntax to specify the key .
 Now , using this line of code , ...
 
 `self.name = try keyedDecodingContainer.decode(String.self , forKey : CodingKeys.name)`
 
 ... the container is going to inspect the JSON .
 Look for a key with the name `.name` ,
 
 `forKey : CodingKeys.name`
 
 access the value ,
 attempt to convert it to a `String` .
 
 `String.self`
 
 And if all that works , it is going to assign it to our stored property .
 
 `self.name`
 
 If it fails ,
 the error is thrown all the way to the call sign .
 So , we'll do this for the rest of our properties as well ,
 
 `self.id   = try keyedDecodingContainer.decode(Int.self    , forKey : CodingKeys.id)`
 `self.role = try keyedDecodingContainer.decode(String.self , forKey : CodingKeys.role)`
 
 Again ,
 the code compiles ,
 we are back to our working example .
 Except now ,
 we know to some degree how this works .
 */
/**
👉 Continues in PART 2
*/
