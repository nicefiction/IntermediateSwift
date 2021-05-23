import Foundation


/**
 `5 The CodingKey Protocol`: PART 2 of 2
 Well , you'll remember that I said wherever possible ,
 we want to let `Codable` do all the work for us .
 There is really no need to provide an implementation ,
 like we have over here ,
 when the compiler can handle all of this for us .
 So ,
 I am going to get rid of all the code I wrote
 other than just the base type :
 */

let json = """
{
    "name" : "Dorothy" ,
    "id" : 1 ,
    "role" : "designer" ,
    "start_date" : "May 2021"
}
""".data(using : .utf8)


// struct Employee: Decodable {
struct Employee: Codable {
    
//    enum CodingKeys: String ,
//                     CodingKey {
//        case name
//        case id
//        case role
//        case startDate = "start_date"
//    }
    
    
    var name: String
    var id: Int
    var role: String
    var startDate: String
    
    
//    init(from decoder: Decoder)
//    throws {
//
//        let keyedDecodingContainer = try decoder.container(keyedBy : CodingKeys.self)
//
//        self.name      = try keyedDecodingContainer.decode(String.self , forKey : CodingKeys.name)
//        self.id        = try keyedDecodingContainer.decode(Int.self    , forKey : CodingKeys.id)
//        self.role      = try keyedDecodingContainer.decode(String.self , forKey : CodingKeys.role)
//        self.startDate = try keyedDecodingContainer.decode(String.self , forKey : CodingKeys.startDate)
//    }
}



//extension Employee: Encodable {
//
//    func encode(to encoder: Encoder)
//    throws {
//
//        var keyedEncodingContainer = encoder.container(keyedBy : CodingKeys.self)
//
//        try keyedEncodingContainer.encode(name , forKey : CodingKeys.name)
//        try keyedEncodingContainer.encode(id , forKey : CodingKeys.id)
//        try keyedEncodingContainer.encode(role , forKey : CodingKeys.role)
//        try keyedEncodingContainer.encode(startDate , forKey : CodingKeys.startDate)
//    }
//}

/**
 Let's get rid of all this .
 We'll just leave the decoder and encoder stuff in here .
 */


extension Data {
    
    var stringDescription: String {
        
        return String(data : self ,
                      encoding : .utf8)!
    }
}

let decoder = JSONDecoder()
// let employee = try decoder.decode(Employee.self , from : json!)

// let encoder = JSONEncoder()
// let encodedEmployee = try encoder.encode(employee)

// print(encodedEmployee.stringDescription) // {"id":1,"name":"Dorothy","role":"designer","start_date":"May 2021"}

/**
 So now , we just have the base type ,
 and we have conformed to `Codable` ,
 allowing the compiler to provide an implementation
 using defaults for a protocol extension :
 Again , we should have an error because the enum key won't match up .
 Again , if you look at the console , you'll notice that we are back having the error :

 */

/* ERROR :
 
 Playground execution terminated: An error was thrown and was not caught:
 ▿ DecodingError
   ▿ keyNotFound : 2 elements
     - .0 : CodingKeys(stringValue: "startDate", intValue: nil)
     ▿ .1 : Context
       - codingPath : 0 elements
       - debugDescription : "No value associated with key CodingKeys(stringValue: \"startDate\", intValue: nil) (\"startDate\")."
       - underlyingError : nil

 */

/**
 If you read what the log says ,
 you'll see that this is a DecodingError .
 The key is not found ,
 and that is the key that the compiler is looking for .
 So you know what is happening .
 In this situation ,
 where we are not defining custom CodingKeys ,
 we are going to ask the encoder and decoder types to do the work for us instead .
 We'll tell the decoder that when it is decoding ,
 it needs to convert the keys from _snake case_ wherever possible .
 Okay, so our solution here is ,
 instead to tell the decoder that when it is decoding ,
 it needs to convert keys from snake case .
 So , here we say ...
 */

decoder.keyDecodingStrategy = .convertFromSnakeCase // ⭐️
let employee = try decoder.decode(Employee.self , from : json!)

let encoder = JSONEncoder()
let encodedEmployee = try encoder.encode(employee)

print(encodedEmployee.stringDescription) // {"id":1,"startDate":"May 2021","name":"Dorothy","role":"designer"}

/**
 Okay , and decoding should work ,
 but encoding will still fail
 — and by fail I mean it will encode the wrong key .

 `"startDate":"May 2021"`
 
 So again ,
 we are going to tell the encoder when it is encoding ,
 to convert to _snake case_ :
 */

let encoder2 = JSONEncoder()
encoder2.keyEncodingStrategy = .convertToSnakeCase  // ⭐️
let encodedEmployee2 = try encoder2.encode(employee)

print(encodedEmployee2.stringDescription) // {"id":1,"name":"Dorothy","role":"designer","start_date":"May 2021"}

/**
 And now , you'll see that decoding works ,
 and we have the right key in our JSON string
 
 `"start_date":"May 2021"`
 
 once we have encoded the type .
 In this way , we are able to allow `Codable` to do all the work ,
 while still accounting for the mismatch between our stored properties and JSON keys .
 Okay , let's take a break here and test some of our knowledge .
 Over the next few videos ,
 we are going to learn how we can handle encoding and decoding ,
 a few more complicated situations and types .
 */
