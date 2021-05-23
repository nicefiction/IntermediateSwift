import Foundation


/**
 `2 The Decodable Protocol`: PART 2 of 2
 So , before we switch tracks here , and look at the counterpart to Decodable ,
 I'll show you how we know that this enum is what serves as sort of the key container .
 How the container is going to look inside this enum ,
 and then parse the JSON :
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
        /**
         Here we have a case `name` ,
         we have said that in the JSON
         the key that has the value for the stored property also has the name , "name" .
         If I change this here , and remove the _e_ ...
         */
        // case nam
        /**
         ... everything should crash . And if you look at the error , ...
         */
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
        
        self.name = try keyedDecodingContainer.decode(String.self , forKey : CodingKeys.name) // ERROR : Type 'Employee.CodingKeys' has no member 'name'
        /**
         ... you can immediately see that there is no value associated with this key .
         So , this is how the container knows to look ,
         or what to look for rather , inside of the JSON . Okay , so let's switch that back .
         All right , let's switch tracks for a second , and look at the counter part to Decodable .
         */
        self.id   = try keyedDecodingContainer.decode(Int.self    , forKey : CodingKeys.id)
        self.role = try keyedDecodingContainer.decode(String.self , forKey : CodingKeys.role)
    }
}
