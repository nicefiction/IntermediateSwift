import Foundation


/**
 `4 Implementing Encodable`
 INTRO — Just like we provided an explicit implementation for `Decodable` ,
 let's write one out for `Encodable` conformance
 so you can understand what is being provided for us .
 */
/**
 Just like we provided an explicit implementation for `Decodable` ,
 let’s write one out for `Encodable` conformance
 so you can understand what is being provided .
 Our struct currently conforms to `Codable` ,
 */

let json = """
{
    "name" : "Dorothy" ,
    "id" : 1 ,
    "role" : "designer"
}
""".data(using : .utf8)


// struct Employee: Codable {
struct Employee: Decodable {
    
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



extension Data {
    
    public var stringDescription: String {
        
        return String(data : self ,
                      encoding : .utf8)!
    }
}



let decoder = JSONDecoder()
let employee = try decoder.decode(Employee.self , from : json!)

// let encoder = JSONEncoder()
// let encodedEmployee = try encoder.encode(employee) // ERROR : Instance method 'encode' requires that 'Employee' conform to 'Encodable' .

/**
 Let's change this to `Decodable` .
 
 `struct Employee: Decodable { ... }`
 
 And when you do this
 our decoding should pass
 but now any encoding related code will fail .
 Our job is to get it working again .

 Right before we instantiate the encoder ,
 let's create an `extension` of `Employee`
 and add `Encodable` conformance :
 */

// extension Employee: Encodable {}

let encoder = JSONEncoder()
let encodedEmployee = try encoder.encode(employee)
print(encodedEmployee.stringDescription) // {"name":"Dorothy","id":1,"role":"designer"}

/**
 `Encodable` works in much the same way as `Decodable`
 in that both protocols rely on an implementation for `CodingKey`
 either having been provided
 or automatically synthesised for the time .
 Since we have a set of `CodingKeys`
 `Encodable` does more or less the same work as `Decodable`
 except in the opposite direction .
 Conforming to `Encodable` requires
 providing an implementation of an `encode() function` .
 Remember , we use an instance of the type for this .
 So , the encoders — `JSONEncoder` here —
 
 `let encoder = JSONEncoder()`
 
 when we pass in the `employee` instance ,
 
 `let encodedEmployee = try encoder.encode(employee)`
 
 it is simply going to call the `encode()` function we define .
 Similar to how decoding takes a Decoder —
 
 `init(from decoder: Decoder) throws { ... }`
 
 — the `encode()` function is passed in an Encoder to handle the job .
 And so , this is again where a `JSON` or `Plist encoder` plays its role .
 (`1`) The first step in the `encode()` function is
 to create a container .
 Now , this might seem like a mirror image of the implementation for Decodable —
 
 `init(from decoder: Decoder)`
 `throws {`
 
    `let keyedDecodingContainer = try decoder.container(keyedBy : CodingKeys.self)`
 
    `self.name = try keyedDecodingContainer.decode(String.self , forKey : CodingKeys.name)`
    `self.id   = try keyedDecodingContainer.decode(Int.self    , forKey : CodingKeys.id)`
    `self.role = try keyedDecodingContainer.decode(String.self , forKey : CodingKeys.role)`
 `}`
 
 — but there are some small differences .
 (`1.1`) When creating a container using a decoder ,
 the container is provided the `JSON` by the `decoder` ,
 as well as the `CodingKeys` as an argument .
 It then decodes each value given a specified key .
 So , all we are doing there when decoding , is ,
 reading values .
 Now , with `Encodable` ,
 we are going to create a container that writes up a JSON string .
 This is a mutable operation ,
 so , the first difference is ,
 that the encoding container is a _mutating type_ stored in a `variable` :
 */

extension Employee: Encodable {
    
    func encode(to encoder: Encoder)
    throws {
        
        var keyedEncodingContainer = encoder.container(keyedBy : CodingKeys.self)
        
        try keyedEncodingContainer.encode(name , forKey : CodingKeys.name)
        try keyedEncodingContainer.encode(id , forKey : CodingKeys.id)
        try keyedEncodingContainer.encode(role , forKey : CodingKeys.role)
    }
}

/**
 ( 1.2 ) The second difference is
 that creating an encoding container is _not_ a throwing operation .
 With `Decodable` ,
 remember that we are specifying whether we want a keyed , unkeyed , or a single value container .
 If the one we request does not match up with the underlying JSON
 — let’s say that the JSON is unkeyed —
 and is a list of objects ,
 and we request a keyed container ,
 this operation will fail
 and throws a type mismatch error .
 Now , with `Encodable` , there is no JSON .
 We are specifying how we want the JSON to be structured .
 So , if we say we want to keep container ,
 that is how we are going to do it .
 There can't be a type mismatch ,
 so this operation is not throwing .
 Now , once we have the container ,
 we can encode each key value pair
 using the values from the instances' stored properties .
 And this operation is a throwing operation however ,
 because the value can be invalid .
 — We'll talk more about this in the error segment .
 So all that means , is ,
 we are going to use `try` here ,
 since the outer function is _throwing_ ,
 we don't have to handle the `try` ,
 we'll just pass it through .
 So here we'll say
 
 `try keyedEncodingContainer.encode(name , forKey : CodingKeys.name)`
 `try keyedEncodingContainer.encode(id , forKey : CodingKeys.id)`
 `try keyedEncodingContainer.encode(role , forKey : CodingKeys.role)`
 
 We are first going to encode the `name` stored property
 and when it shows up in the JSON , we want it to have the key made .
 Again , this is a `CodingKeys enum` ,
 so we can use the shorthand syntax to refer to the keys .
    That is all we need to do ,
 now the rest of our code compiles
 and we are back to a JSON string in the console .
 
 `NOTICE` that with decoding we used an initialiser :
 
 `init(from decoder: Decoder)`
 `throws {`
 
    `let keyedDecodingContainer = try decoder.container(keyedBy : CodingKeys.self)`
 
    `self.name = try keyedDecodingContainer.decode(String.self , forKey : CodingKeys.name)`
    `self.id   = try keyedDecodingContainer.decode(Int.self    , forKey : CodingKeys.id)`
    `self.role = try keyedDecodingContainer.decode(String.self , forKey : CodingKeys.role)`
 `}`
 
 Which means
 that we need to assign a value to every single stored property .
 `NOTE` : There are different cases where we may not have a value ,
 we'll reserve that for a later discussion .
 But the basic part , is , that
 when decoding ,
 you need the JSON over here
 
 `let json = """`
 `{`
     `"name" : "Dorothy" ,`
     `"id" : 1 ,`
     `"role" : "designer"`
 `""".data(using : .utf8)`
 
 to have all the values that your model defines .
    With encoding ,
 it is not an initialiser ,
 there is no such requirement .
 So , in encoding
 I can choose to omit certain keys ,
 so I may store something in my model
 that I don't need to send to a server ...
 
 `func encode(to encoder: Encoder)`
 `throws {`
 
    `var keyedEncodingContainer = encoder.container(keyedBy : CodingKeys.self)`
 
    `try keyedEncodingContainer.encode(name , forKey : CodingKeys.name)`
    `try keyedEncodingContainer.encode(id , forKey : CodingKeys.id)`
    `// try keyedEncodingContainer.encode(role , forKey : CodingKeys.role)`
 `}`
 
 ... and I don't need to encode that . It is up to me .
 
 `// try keyedEncodingContainer.encode(role , forKey : CodingKeys.role)`
 
 I do want the role
 so I'll put that back in there ,
 
 `try keyedEncodingContainer.encode(role , forKey : CodingKeys.role)`
 */
/**
 So , that was a quick look at how encoding and decoding works ,
 at least in the context of JSON .
 Although other formats are not much different .
 While the `Codable` type automatically handles and provides an implementation
 for everything we did in the last few videos ,
 it really isn't some obscure magic .
 And the logic is relatively straightforward .
 For the most part ,
 unless you run into special cases ,
 you can let `Codable` do the work for you .
 Now , we are going to look at all the variations of these special cases ,
 and when you need to worry
 (`A`) about providing an implementation yourself
 or (`B`) how you should structure your code
 so that you can let `Codable` keep doing the work for you
 as your JSON gets more complex .
 But before we get into any of that ,
 let's take a quick minute to talk about `CodingKey`
 in the next video .
 */
