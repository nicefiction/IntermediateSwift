import Foundation


/**
 `2 Changing Hierarchies`PART 2 of 2
 
 Advanced Codable youtube video , [10:30 - 10:29]
 SOURCE :  https://youtu.be/LoRhAEf050E
 
 JSON Basics ,
 SOURCE : https://benscheirman.com/2017/06/swift-json/
 */
/**
 Okay ,
 in this example I want to take a look at
 a `json` structure that  is representing a flattened structure
 and let's say we wanted to nest these two things
 in their own object :
 */

let json = """
{
    "id" : 123 ,
    "name" : "avond brood" ,
    "bakery_id" : "BIO123" ,
    "bakery_name" : "BioPlanet"
}
""".data(using: .utf8)!



struct Bread: Decodable {
    
    let id: Int
    let name: String
    let bakery: Bakery
    
    
    enum CodingKeys: String ,
                     CodingKey {
        case id
        case name
    }
    
    
    init(from decoder: Decoder)
    throws {
        
        let jsonContainer = try decoder.container(keyedBy : CodingKeys.self)
        
        self.id   = try jsonContainer.decode(Int.self ,    forKey : CodingKeys.id)
        self.name = try jsonContainer.decode(String.self , forKey : CodingKeys.name)
        self.bakery = try Bakery(from : decoder)
    }
}



struct Bakery: Decodable {
    
    let id: String
    let name: String
    
    
    enum CodingKeys: String ,
                     CodingKey {
        
        case id = "bakery_id"
        case name = "bakery_name"
    }
}



let decoder: JSONDecoder = JSONDecoder()

let bread = try decoder.decode(Bread.self ,
                               from : json)
dump(bread)

/* CONSOLE :
 
 __lldb_expr_41.Bread
  - id: 123
  - name: "avond brood"
  ▿ bakery: __lldb_expr_41.Bakery
    - id: "BIO123"
    - name: "BioPlanet"
 */
/**
 We have taken the flattened `json`
 and we have introduced our own hierarchy
 so we can organize these things into
 types however we see fit .
 */
