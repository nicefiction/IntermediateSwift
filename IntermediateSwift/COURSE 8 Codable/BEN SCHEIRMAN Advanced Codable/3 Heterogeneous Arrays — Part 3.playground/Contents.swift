import Foundation


/**
 `3 Heterogeneous Arrays`PART 3 of 3
 
 Advanced Codable youtube video , [21:21 - 26:46]
 SOURCE :  https://youtu.be/LoRhAEf050E
 
 JSON Basics ,
 SOURCE : https://benscheirman.com/2017/06/swift-json/
 */

let json = """
{
    "items" : [
        {
            "type" : "text" ,
            "id" : 55 ,
            "date" : "2021-05-23T13:15:24Z" ,
            "text" : "This is s text feed item"
        } ,
        {
            "type" : "image" ,
            "id" : 56 ,
            "date" : "2021-05-23T13:16:24Z" ,
            "image_url" : "http://placekitten.com/200/300"
        }
    ]
}
""".data(using : .utf8)!


// ⭐️
protocol DecodableClassFamily: Decodable {
    
    associatedtype BaseType: Decodable
    static var discriminator: AnyCodingKey { get }
    func getType() -> BaseType.Type
}


// ⭐️
enum FeedItemClassFamily: String ,
                          DecodableClassFamily {
    case text
    case image
    
    typealias BaseType = FeedItem
    static var discriminator: AnyCodingKey = "type"
    
    func getType()
    -> FeedItem.Type {
        
        switch self {
        case .text  : return TextFeedItem.self
        case .image : return ImageFeedItem.self
        }
    }
}


// ⭐️
extension KeyedDecodingContainer {
    
    func decodeHeterogeneousArray<Family: DecodableClassFamily>(family: Family.Type ,
                                                                forKey key: K)
    throws -> [Family.BaseType] {
        
        var peekContainer = try nestedUnkeyedContainer(forKey : key)
        var itemsContainer = peekContainer
        
        var itemsArray = Array<Family.BaseType>()
        
        while !itemsContainer.isAtEnd {
            
            // Peek at the type :
            let typeContainer = try peekContainer.nestedContainer(keyedBy : AnyCodingKey.self)
            
            let family = try typeContainer.decode(Family.self ,
                                                  forKey : Family.discriminator)
            let type = family.getType()
            let item = try itemsContainer.decode(type)
            
            itemsArray.append(item)
        }
        
        return itemsArray
    }
}



class FeedItem: Decodable {
    
    let type: String
    let id: Int
    let date: Date
}



class TextFeedItem: FeedItem {
    
    enum CodingKeys: String ,
                     CodingKey {
        case text
    }

    
    let text: String
    
    
    required init(from decoder: Decoder)
    throws {
        
        let jsonContainer = try decoder.container(keyedBy: CodingKeys.self)
        
        self.text = try jsonContainer.decode(String.self , forKey : CodingKeys.text)
        
        
        try super.init(from : decoder)
    }
}



class ImageFeedItem: FeedItem {
    
    enum CodingKeys: String ,
                     CodingKey {
        case imageUrl
    }

    
    let imageURL: URL
    
    
    required init(from decoder: Decoder)
    throws {
        
        let jsonContainer = try decoder.container(keyedBy : CodingKeys.self)
        
        self.imageURL = try jsonContainer.decode(URL.self ,
                                                 forKey : CodingKeys.imageUrl)
        
        try super.init(from: decoder)
    }
}



struct AnyCodingKey: CodingKey {
    
    var stringValue: String
    var intValue: Int?
    
    init?(stringValue: String) { self.stringValue = stringValue }
    
    init?(intValue: Int) { stringValue = String(intValue) }
}



/**
 Then for flexibility
 I want to add an extension on AnyCodingKey :
 */
extension AnyCodingKey: ExpressibleByStringLiteral {
    
    init(stringLiteral value: StringLiteralType) {
        
        self.init(stringValue : value)!
    }
}


// ⭐️
struct Feed: Decodable {
    
    enum CodingKeys: String ,
                     CodingKey {
        case items
    }
    
    
    let items: [FeedItem]
    
    
    init(from decoder: Decoder)
    throws {
        
        let jsonContainer = try decoder.container(keyedBy : CodingKeys.self)
        
        items = try jsonContainer.decodeHeterogeneousArray(family : FeedItemClassFamily.self ,
                                                           forKey : CodingKeys.items) // ⭐️
        
//        var peekContainer = try jsonContainer.nestedUnkeyedContainer(forKey : CodingKeys.items)
//        var itemsContainer = peekContainer
//
//        var itemsArray = Array<FeedItem>()
//
//        while !itemsContainer.isAtEnd {
//
//            // Peek at the type :
//            let typeContainer = try peekContainer.nestedContainer(keyedBy : AnyCodingKey.self)
//
//            let type = try typeContainer.decode(String.self , forKey : "type")
//
//
//            switch type {
//
//            case "text" :
//                let textFeedItem = try itemsContainer.decode(TextFeedItem.self)
//                itemsArray.append(textFeedItem)
//
//            case "image" :
//                let imageFeedItem = try itemsContainer.decode(ImageFeedItem.self)
//                itemsArray.append(imageFeedItem)
//
//            default : fatalError()
//            }
//        }
//
//        self.items = itemsArray
    }
}



let decoder: JSONDecoder = JSONDecoder()
decoder.keyDecodingStrategy = .convertFromSnakeCase
decoder.dateDecodingStrategy = .iso8601

let feed = try decoder.decode(Feed.self ,
                              from : json)
dump(feed)

/* CONSOLE :
 
 ▿ __lldb_expr_13.Feed
   ▿ items: 2 elements
     ▿ __lldb_expr_13.TextFeedItem #0
       ▿ super: __lldb_expr_13.FeedItem
         - type: "text"
         - id: 55
         ▿ date: 2021-05-23 13:15:24 +0000
           - timeIntervalSinceReferenceDate: 643468524.0
       - text: "This is s text feed item"
     ▿ __lldb_expr_13.ImageFeedItem #1
       ▿ super: __lldb_expr_13.FeedItem
         - type: "image"
         - id: 56
         ▿ date: 2021-05-23 13:16:24 +0000
           - timeIntervalSinceReferenceDate: 643468584.0
       ▿ imageURL: http://placekitten.com/200/300
         - _url: http://placekitten.com/200/300 #2
           - super: NSObject
 */
