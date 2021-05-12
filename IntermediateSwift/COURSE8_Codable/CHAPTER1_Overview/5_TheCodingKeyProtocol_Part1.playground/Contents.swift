import Foundation


/**
 `5 The CodingKey Protocol`: PART 1 OF 2
 INTRO — Both decoding and encoding rely on information about
 the key to stored property mapping being provided . By default
 `Codable` provides this information through a separate type —`CodingKey` .
 In this video , let’s take a look at some edge cases
 to this mapping strategy .
 */
/**
 As we saw in the last few videos ,
 the `CodingKey` protocol
 and the type we provide that conforms to it
 is key — pun intended — to how most of the encoding and decoding logic works .
 So , let’s recap what we know so far .
 Any type that conforms to the `CodingKey` protocol
 needs to map from stored property to JSON key .
 The most common way of representing this
 — if you need to provide a custom implementation — is ,
 an `enum` with `String raw values`
 where each enum member maps to a stored property ,
 and its corresponding raw value maps to a `JSON key` :
 */

/*
let json = """
{
    "name" : "Dorothy" ,
    "id" : 1 ,
    "role" : "designer"
}
""".data(using : .utf8)


struct Employee: Decodable {
    
     // ///////////////////
    //  MARK: NESTED TYPES
    
    enum CodingKeys: String ,
                     CodingKey {
        case name = "name"
        case id = "id"
        case role = "role"
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
 */

/**
 Taking a look at the enum we defined ,
 we have a `name` member
 
 `case name`
 
 that maps the `name` stored property ,
 
 `let name: String`
 
 and a `"name"` raw value that maps to the JSON key .
 
 `"name" : "Dorothy" ,`
 
 It is very important that the JSON key representation
 — that is the raw value of the enum —
 be the same value
 in case so that is not mismatch ...
 */

struct EmployeeWithChangedNameCase: Decodable {
    
     // ///////////////////
    //  MARK: NESTED TYPES
    
    enum CodingKeys: String ,
                     CodingKey {
        /**
         ... So right here , if we change this to `names` , ...
         */
        case names = "name" // ⭐️
        case id = "id"
        case role = "role"
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
        
        /**
         ... that won't be an issue in this specific instance .
         Since we are manually decoding and specifying the key ,
         we can indicate to the key right here
         so it works with the names value .
         */
        self.name = try keyedDecodingContainer.decode(String.self , forKey : CodingKeys.names) // ⭐️
        self.id   = try keyedDecodingContainer.decode(Int.self    , forKey : CodingKeys.id)
        self.role = try keyedDecodingContainer.decode(String.self , forKey : CodingKeys.role)
    }
}

/**
 So , it is more important that you get the `JSON key` right , than the `enum case` ,
 which maps to the stored property
 because the compiler can't figure that out .
 You'll notice , though , that we are being redundant .
 
 `enum CodingKeys: String ,`
                  `CodingKey {`
 
    `case names = "name"`
    `case id = "id"`
    `case role = "role"`
 `}`
 
 When an enum specifies raw values as `String` ,
 if we don't provide a raw value ,
 the compiler can synthesise one
 by creating a String to match the enum member .
 In fact , if we get rid of all these raw values :
 */

/*
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
 */

/**
 ... nothing happens to our code , and everything still compiles .
 This is because there is no difference
 between the key name in the enum
 and the corresponding JSON key .
 
 `let json = """`
 `{`
     `"name" : "Dorothy" ,`
     `"id" : 1 ,`
     `"role" : "designer"`
 `""".data(using : .utf8)`
 
 So
 what is automatically given to us by the compiler
 works .
 But this isn't always the case .
 So let's make a slight tweak here .
 In addition to the data defined earlier ,
 let's add something to the JSON string
 to now include a fourth key value pair ,
 and we'll describe when the employee started .
 For now , I'll just include this date as a String :
 */

let json = """
{
    "name" : "Dorothy" ,
    "id" : 1 ,
    "role" : "designer" ,
    "start_date" : "May 2021"
}
""".data(using : .utf8)

/**
 `GOTCHA` : Do not forget to add the comma !
 
 Once you add this pair to the JSON ,
 what do you notice ?
 Nothing , right ?
 No errors .
 Even though the JSON has additional data ,
 since our type does not model it ,
 the decoder simply discards this information .
    So keep this in mind :
 If you are decoding JSON using the `Codable` protocol ,
 and don't need all the information ,
 don't model that information as stored properties ,
 and the decoder will simply ignore it .
 But let's say we do want to model it .
 What do we do ?
 (`1`) First we need a stored property .
 (`2`) The next thing we need is a value in the enum to map to this property .
 Remember , this value has to be the same name as the property .
 (`3`) To complete the implementation for Decodable ,
 let's add a line of code to the `init()` method
 to decode the JSON into a value for this new stored property .
 The moment I do this , ...
 */

/*
struct Employee: Decodable {
    
     // ///////////////////
    //  MARK: NESTED TYPES
    
    enum CodingKeys: String ,
                     CodingKey {
        case name
        case id
        case role
        case startDate
    }
               
    
    
     // /////////////////
    //  MARK: PROPERTIES
    
    let name: String
    let id: Int
    let role: String
    let startDate: String
    
    
    
     // /////////////////////////
    //  MARK: INITIALZER METHODS
    
    init(from decoder: Decoder)
    throws {
        
        let keyedDecodingContainer = try decoder.container(keyedBy : CodingKeys.self)
        
        self.name      = try keyedDecodingContainer.decode(String.self , forKey : CodingKeys.name)
        self.id        = try keyedDecodingContainer.decode(Int.self    , forKey : CodingKeys.id)
        self.role      = try keyedDecodingContainer.decode(String.self , forKey : CodingKeys.role)
        self.startDate = try keyedDecodingContainer.decode(String.self , forKey : CodingKeys.startDate)
    }
}
*/

extension Employee: Encodable {
    
    func encode(to encoder: Encoder) throws {
        
        var keyedEncodingContainer = encoder.container(keyedBy : CodingKeys.self)
        
        try keyedEncodingContainer.encode(name , forKey : CodingKeys.name)
        try keyedEncodingContainer.encode(id , forKey : CodingKeys.id)
        try keyedEncodingContainer.encode(role , forKey : CodingKeys.role)
        try keyedEncodingContainer.encode(startDate , forKey : CodingKeys.startDate)
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

let encoder = JSONEncoder()
let encodedEmployee = try encoder.encode(employee)
print(encodedEmployee.stringDescription)

/**
 ... the playground should crash .
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
 The reason it is crashing , is ,
 because earlier ,
 we got rid of the raw value strings
 we defined earlier .
 Since the compiler is automatically synthesising
 the raw values for each member ,
 
 `enum CodingKeys: String ,`
                  `CodingKey {`
     `case name`
     `case id`
     `case role`
     `case startDate`
 `}`
 
 we end up with the raw value for `startDate`
 that looks like this :
 
 `"startDate"`
 
 This is , however ,
 not what the key looks like in the JSON string ,
 
 `let json = """`
 `{`
     `"name" : "Dorothy" ,`
     `"id" : 1 ,`
     `"role" : "designer" ,`
     `"start_date" : "May 2021"`
 `}`
 `""".data(using : .utf8)`
 
 In the JSON string ,
 the key is defined using what is called _snake case_ ,
 
 `"start_date"`
 
 Rather than using lower camel case syntax that Swift uses ,
 JSON conventions specify snake case ,
 which means using an underscore between words , which are all in lowercase .
 So what you are running into here , is a fairly common issue .
 Following the Swift conventions means
 that our stored properties — and thereby enum members — must be in lower camel case .
 And this does not match up with potential keys in JSON that would use snake case
 for names longer than one word .
 There are two ways we can solve this :
 (`1`) In this case ,
 since we are providing our own implementations for `CodingKey` in `Codable` and `Decodable` ,
 we can specify the raw value to match up with the correct JSON key :
 */

struct Employee: Decodable {
    
     // ///////////////////
    //  MARK: NESTED TYPES
    
    enum CodingKeys: String ,
                     CodingKey {
        case name
        case id
        case role
        case startDate = "start_date" // ⭐️
    }
               
    
    
     // /////////////////
    //  MARK: PROPERTIES
    
    let name: String
    let id: Int
    let role: String
    let startDate: String
    
    
    
     // /////////////////////////
    //  MARK: INITIALZER METHODS
    
    init(from decoder: Decoder)
    throws {
        
        let keyedDecodingContainer = try decoder.container(keyedBy : CodingKeys.self)
        
        self.name      = try keyedDecodingContainer.decode(String.self , forKey : CodingKeys.name)
        self.id        = try keyedDecodingContainer.decode(Int.self    , forKey : CodingKeys.id)
        self.role      = try keyedDecodingContainer.decode(String.self , forKey : CodingKeys.role)
        self.startDate = try keyedDecodingContainer.decode(String.self , forKey : CodingKeys.startDate)
    }
}

/**
 And now everything works :
 */

// {"id":1,"name":"Dorothy","role":"designer","start_date":"May 2021"}

/**
 This allows us to satisfy Swift's conventions when defining stored properties ,
 while also ensuring that the decoder can find the right JSON key .
 */
/**
👉 Continues in PART 2
*/
