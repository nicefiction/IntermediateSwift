import Foundation


/**
 `3 Heterogeneous Arrays`PART 2 of 3
 
 `Advanced Codable youtube video` , [14:38 - 21:20]
 SOURCE :  https://youtu.be/LoRhAEf050E
 
 `JSON Basics` ,
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

    /**
     For the`Int`value initializer
     we are not necessarily going to use this
     but if you were using an `Array`
     and wanted to have positional indices
     then you would use a `CodingKey` for the index in the array .
     In our case I am just going to say
     that the String value equals the
     String conversion of whatever Int was passed in
     and that is good enough to get this working :
     */
    init?(intValue: Int) { stringValue = String(intValue) }
}



/**
 Then for flexibility
 I want to add an `extension` on `AnyCodingKey` :
 */
extension AnyCodingKey: ExpressibleByStringLiteral {
    
    init(stringLiteral value: StringLiteralType) {
        
        self.init(stringValue : value)!
        /**
         What that means is
         if we pass a `String`
         it will convert it to a `CodingKey` for us
         and make it a lot easier for us to work with .
         */
    }
}



struct Feed: Decodable {
    
    enum CodingKeys: String ,
                     CodingKey {
        case items
    }
    
    
    let items: [FeedItem]
    
    
    init(from decoder: Decoder)
    throws {
        
        let jsonContainer = try decoder.container(keyedBy : CodingKeys.self)
        
        var peekContainer = try jsonContainer.nestedUnkeyedContainer(forKey : CodingKeys.items)
        /**
         [16:44] I want to decode this first to peek into this type property
         and then i'll know what type i need to decode
         and i want to decode it again
         but there's no such thing
         as like rewinding or decoding in the same place again
         so what i actually need are
         two different containers pointing to the same one
         so i'm going to create a copy
         i'm going to use the first copy
         to decode and look at the text
         
         `"type" : "text" ,`
         
         `"type" : "image" ,`
         
         or look at the type rather
         and then the second one
         is going to decode
         the actual instance that we are interested in :
         */
        var itemsContainer = peekContainer
        
        var itemsArray = Array<FeedItem>()
        
        while !itemsContainer.isAtEnd {
            /**
             [17:42] Okay , so we first need to peek at the type .
             Now for the coding key
             normally we have a `CodingKeys enum`
             but this is a case
             where i want to have something a little bit more flexible
             and so I am going to create an `AnyCodingKey struct`.
             */
            // Peek at the type :
            let typeContainer = try peekContainer.nestedContainer(keyedBy : AnyCodingKey.self)
            
            let type = try typeContainer.decode(String.self , forKey : "type")
            
            
            switch type {
            
            case "text" :
                let textFeedItem = try itemsContainer.decode(TextFeedItem.self)
                itemsArray.append(textFeedItem)
                
            case "image" :
                let imageFeedItem = try itemsContainer.decode(ImageFeedItem.self)
                itemsArray.append(imageFeedItem)
                
            default : fatalError()
            }
        }
        
        self.items = itemsArray
    }
}



let decoder: JSONDecoder = JSONDecoder()
decoder.keyDecodingStrategy = .convertFromSnakeCase
decoder.dateDecodingStrategy = .iso8601

let feed = try decoder.decode(Feed.self ,
                              from : json)
dump(feed)

/* CONSOLE :
 
 ▿ __lldb_expr_9.Feed
   ▿ items: 2 elements
     ▿ __lldb_expr_9.TextFeedItem #0
       ▿ super: __lldb_expr_9.FeedItem
         - type: "text"
         - id: 55
         ▿ date: 2021-05-23 13:15:24 +0000
           - timeIntervalSinceReferenceDate: 643468524.0
       - text: "This is s text feed item"
     ▿ __lldb_expr_9.ImageFeedItem #1
       ▿ super: __lldb_expr_9.FeedItem
         - type: "image"
         - id: 56
         ▿ date: 2021-05-23 13:16:24 +0000
           - timeIntervalSinceReferenceDate: 643468584.0
       ▿ imageURL: http://placekitten.com/200/300
         - _url: http://placekitten.com/200/300 #2
           - super: NSObject
 */

/**
 If we run it
 now we should be able to see
 that the items in the `items array`
 are actually instances of `TextFeedItem`
 
 `▿ __lldb_expr_9.TextFeedItem #0`
 
 and `ImageFeedItem` here
 
 `▿ __lldb_expr_9.ImageFeedItem #1`
 
 and they have their other additional properties
 `text` here
 
 `- text: "This is s text feed item"`
 
 and `imageUrl` here .
 
 `▿ imageURL: http://placekitten.com/200/300`
 
 So this is enough to get this particular example working
 but it is quite a bit cumbersome to do this sort of thing
 and there is probably a way we can clean this up
 and make something a little bit more reusable .
 Okay let's talk about refactoring this example
 so that we could create something more reusable
 that represents the same pattern
 */
/**
👉 Continues in PART 3
*/
