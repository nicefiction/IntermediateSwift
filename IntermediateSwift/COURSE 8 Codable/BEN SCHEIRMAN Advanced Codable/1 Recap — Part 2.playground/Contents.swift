import Foundation


/**
 `1 Recap`PART 2 of 2
 
 `Advanced Codable youtube video` , [0:00 - 2:45]
 SOURCE :  https://youtu.be/LoRhAEf050E
 
 `JSON Basics` ,
 SOURCE : https://benscheirman.com/2017/06/swift-json/
 */
/**
 There are 3 steps of customizing Codable "
 */

let json = """
{
    "id" : 123 ,
    "name" : "avond brood" ,
    "bakery" : "BioPlanet"
}
""".data(using: .utf8)!


struct Bread: Codable {
    
    let id: Int
    let name: String
    let bakery: String
    
    // STEP 1 of 3 , CodingKeys :
    enum CodingKeys: String ,
                     CodingKey {
        case id
        case name
        case bakery
    }
    
    // STEP 2 of 3 , init(decoder) :
    init(from decoder: Decoder)
    throws {
        
        let jsonContainer = try decoder.container(keyedBy : CodingKeys.self)
        
        self.id     = try jsonContainer.decode(Int.self ,    forKey : CodingKeys.id)
        self.name   = try jsonContainer.decode(String.self , forKey : CodingKeys.name)
        self.bakery = try jsonContainer.decode(String.self , forKey : CodingKeys.bakery)
    }
    
    // STEP 3 of 3 , encode(to) :
    func encode(to encoder: Encoder)
    throws {
        
        var jsonContainer = encoder.container(keyedBy : CodingKeys.self)
        
        try jsonContainer.encode(id , forKey : CodingKeys.id)
        try jsonContainer.encode(name , forKey : CodingKeys.name)
        try jsonContainer.encode(bakery , forKey : CodingKeys.bakery)
    }
}
