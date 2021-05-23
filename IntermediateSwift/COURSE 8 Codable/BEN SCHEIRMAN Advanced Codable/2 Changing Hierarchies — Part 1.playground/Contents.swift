import Foundation


/**
 `2 Changing Hierarchies`PART 1 of 2
 
 Advanced Codable youtube video , [6:30 - 10:29]
 SOURCE :  https://youtu.be/LoRhAEf050E
 
 JSON Basics ,
 SOURCE : https://benscheirman.com/2017/06/swift-json/
 */
/**
 An example of
 taking an extra hierarchy that we don't need in the `json`
 and flattening it out into one object on our side :
 */

let json = """
{
    "id" : 123 ,
    "name" : "avond brood" ,
    "bakery" : {
        "id" : "BioP123" ,
        "name" : "BioPlanet"
    }
}
""".data(using: .utf8)!


struct Bread: Decodable {
    
    let id: Int
    let name: String
    let bakeryID: String
    let bakeryName: String
    
    
    enum CodingKeys: String ,
                     CodingKey {
        case id
        case name
        case bakery
    }
    
    
    enum BakeryCodingKeys: String ,
                           CodingKey {
        case id
        case name
    }
    
    
    init(from decoder: Decoder)
    throws {
        
        let jsonContainer = try decoder.container(keyedBy : CodingKeys.self)
        
        self.id   = try jsonContainer.decode(Int.self ,    forKey: CodingKeys.id)
        self.name = try jsonContainer.decode(String.self , forKey: CodingKeys.name)
        
        let bakeryContainer = try jsonContainer.nestedContainer(keyedBy : BakeryCodingKeys.self ,
                                                                forKey : CodingKeys.bakery)
        
        self.bakeryID   = try bakeryContainer.decode(String.self , forKey : BakeryCodingKeys.id)
        self.bakeryName = try bakeryContainer.decode(String.self , forKey : BakeryCodingKeys.name)
    }
}


let decoder: JSONDecoder = JSONDecoder()

let bread = try decoder.decode(Bread.self , from : json)

dump(bread)

/* CONSOLE :
 
 __lldb_expr_31.Bread
   - id: 123
   - name: "avond brood"
   - bakeryID: "BioP123"
   - bakeryName: "BioPlanet"
 */
/**
👉 Continues in PART 2
*/
