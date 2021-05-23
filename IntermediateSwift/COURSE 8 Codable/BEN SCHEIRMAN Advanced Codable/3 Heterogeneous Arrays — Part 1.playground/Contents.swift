import Foundation


/**
 `3 Heterogeneous Arrays`PART 1 of 3
 
 Advanced Codable youtube video , [12:58 - 14:38]
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



class FeedItem: Decodable {
    
    let type: String
    let id: Int
    let date: Date
}



//class TextFeedItem: FeedItem {
//
//    let text: String
//}
//
//
//
//class ImageFeedItem: FeedItem {
//
//    let imageURL: URL
//}



struct Feed: Decodable {
    
    let items: [FeedItem]
}



let decoder: JSONDecoder = JSONDecoder()
decoder.keyDecodingStrategy = .convertFromSnakeCase
decoder.dateDecodingStrategy = .iso8601

let feed = try decoder.decode(Feed.self ,
                              from : json)

/**
 So if i run this ...
 */
dump(feed)

/**
 ... it does work ...
 */

/* CONSOLE :
 
 ▿ __lldb_expr_43.Feed
   ▿ items: 2 elements
     ▿ __lldb_expr_43.FeedItem #0
       - type: "text"
       - id: 55
       ▿ date: 2021-05-23 13:15:24 +0000
         - timeIntervalSinceReferenceDate: 643468524.0
     ▿ __lldb_expr_43.FeedItem #1
       - type: "image"
       - id: 56
       ▿ date: 2021-05-23 13:16:24 +0000
         - timeIntervalSinceReferenceDate: 643468584.0
 */

/**
 ... however
 the problem is
 that each one of these items
 is an instance of the base class
 —`FeedItem`—
 not the specific subclass that i want
 —`TextFeedItem` and `ImageFeedItem`—
 so it is missing the actual `text` property from this one
 
 `▿ __lldb_expr_43.FeedItem #0`
   `- type: "text"`
   `- id: 55`
   `▿ date: 2021-05-23 13:15:24 +0000`
     `- timeIntervalSinceReferenceDate: 643468524.0`
 
 and this one is missing the `imageUrl`
 
 `▿ __lldb_expr_43.FeedItem #1`
   `- type: "image"`
   `- id: 56`
   `▿ date: 2021-05-23 13:16:24 +0000`
     `- timeIntervalSinceReferenceDate: 643468584.0`

 so that is not what we want .
 */
/**
👉 Continues in PART 2
*/
