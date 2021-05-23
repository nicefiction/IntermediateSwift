import Foundation


/**
 `1 Recap`PART 1 of 2
 
 Advanced Codable youtube video , [0:00 - 2:45]
 SOURCE :  https://youtu.be/LoRhAEf050E
 
 JSON Basics ,
 SOURCE : https://benscheirman.com/2017/06/swift-json/
 */

let json = """
{
    "id" : 123 ,
    "name" : "Evening bread" ,
    "bakery" : "Bioplanet"
}
""".data(using : .utf8)!


struct Bread: Codable {
    
    let id: Int
    let name: String
    let bakery: String
}


let decoder: JSONDecoder = JSONDecoder()
let bread = try decoder.decode(Bread.self , from : json)


do {
    try decoder.decode(Bread.self , from : json)
    
} catch DecodingError.keyNotFound(let key,
                                  let context) {
    print(key)
    print(context.debugDescription)
}

/**
👉 Continues in PART 2
*/
