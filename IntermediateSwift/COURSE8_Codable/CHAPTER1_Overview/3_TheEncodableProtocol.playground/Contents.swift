import Foundation


/**
 `3 The Encodable Protocol`
 INTRO — Where `Decodable` helps us parse data
 and obtain an instantiated data model ,
 `Encodable` takes us in the opposite direction .
 In this video ,
 let's convert the instance of `Employee` back to JSON
 using the `Encodable` protocol .
 */
/**
 Where `Decodable` helps us parse data
 and obtain and instantiate a data model ,
 `Encodable` takes us in the opposite direction .
 There are several use cases for this .
 You might want to send a `JSON response`
 to a web server
 as `POST data`
 or you might want to save a model to the disc .
 Remember that `JSON` is not the only format that `Codable` works with .
 You can encode your models into a `Plist` ,
 or any format that you care for .
 In this video ,
 let's take the `employee` instance we created in the last video
 and get a JSON representation of it .
 Since our type already conforms to `Codable`
 — which is a composition of both `Encodeable` and `Decodeable` ,
 we should already have an implementation for this .
 Just like we needed a `decoder`
 to handle the actual JSON destructuring earlier ,
 we need an `encoder` to work with .
 So let's create one :
 */

let json = """
{
    "name" : "Dorothy" ,
    "id" : 1 ,
    "role" : "designer"
}
""".data(using : .utf8)



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


let decoder = JSONDecoder()
let employee = try decoder.decode(Employee.self , from : json!)

let encoder = JSONEncoder()
/**
 Using this encoder , let's get some JSON from the model .
 Like decoding into a type , this is also a throwing operation ,
 so we need to use the `try` keyword :
 */
let encodedEmployee = try encoder.encode(employee)

/**
 This time , we pass in the instance we want to encode. 
 
 `NOTE` :
 For the rest of the series ,
 until we talk about error handling ,
 we are just going to ignore error handling all together .
 So we are going to use the force version of `try` wherever it applies .
 
 So here ,
 
 `let encodedEmployee = try encoder.encode(employee)`
 
 this `encode()` method
 takes an encodable instance of a type .
 And if it succeeds
 we get an instance of data back with the encoded data — which is what we expect .
 `JSON` is sent as a data object in a request response cycle ,
 not just as a plain String .
 To inspect the contents of this ,
 let's write a helper method
 so that it makes the rest of this series easier .
 And we want this to be shared code that is available in all playground pages .
 So , what you are going to do , is ,
 click on your navigator ,
 then under sources ,
 you're going to right click , new file ,
 let's add a swift file in there , we'll name this `Data+Extensions` .
 And then in here ,
 we'll write this as an `extension` to the `Data` type :
 */

/*
extension Data {
    
    var stringDescription: String {
        
        return String(data : self ,
                      encoding : .utf8)!
    }
}
 */

/**
 We are creating a computed property
 named `stringDescription` of type `String` .
 And in here , we are using the initialiser on the String type
 to return a String representation of our data ,
 and the encoding is `.utf8` .
 This returns an optional String , so I'm going to unwrap it .
 Okay , so once that is in there
 we can go back to our playground .
    To see what our `encodedEmployee` looks like , we'll print it out .
 And we'll use that helper method we just wrote :
 */

print(encodedEmployee.stringDescription)

/**
 Now , it doesn't show up . And that is , because ,
 technically what is in this file — A Quick Peek — is in a separate module ,
 so this needs to be a `public` computed property :
 */

extension Data {
    
    public var stringDescription: String {
        
        return String(data : self ,
                      encoding : .utf8)!
    }
}

/**
 Okay , now if you look at the console , ...
 */

// {"name":"Dorothy","id":1,"role":"designer"}

/**
 ... you'll see a JSON string representing our object ,
 and this matches the JSON string that we defined
 when we started off with the series :
 
 `let json = """`
 `{`
     `"name" : "Dorothy" ,`
     `"id" : 1 ,`
     `"role" : "designer"`
 `""".data(using : .utf8)`
 
 Okay ,
 so just like we did with `Decodable` ,
 in the next video ,
 let's write the implementation for this ourselves .
 */



/**
 `ASIDE` :
 As an aside ,
 I mentioned earlier ,
 that these protocols enable us to work
 with more than just the JSON format .
 If you are wondering how that works ,
 all you have to do , is ,
 select an `Encoder` or `Decoder` to work with .
 The `Decoder` and `Encoder` know about the format that we want to convert to ,
 so it handles the structure .
 So , let's say we wanted to write this object to
 a `property list file` ,
 we would simply say ,
 */

let plistEncoder = PropertyListEncoder( )

/**
 And now this would convert it to a property list .
 */


print("Debug")
