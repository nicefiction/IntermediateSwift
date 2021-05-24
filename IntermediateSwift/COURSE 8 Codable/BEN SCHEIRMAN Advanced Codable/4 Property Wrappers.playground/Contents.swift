import Foundation


/**
 `4 Property Wrappers`
 
 `Advanced Codable youtube video` , [26:47 - 30:00]
 SOURCE :  https://youtu.be/LoRhAEf050E
 
 `JSON Basics` ,
 SOURCE : https://benscheirman.com/2017/06/swift-json/
 
 `Property Wrappers` ,
 SOURCE : https://www.swiftbysundell.com/articles/property-wrappers-in-swift/
 SOURCE : https://www.avanderlee.com/swift/property-wrappers/
 
 `Source code Github` ,
 SOURCE :  https://github.com/subdigital/advanced-codable-talk
 */

let json = """
{
    "name" : "Dorothy" ,
    "dob" : "1973-12-04" ,
    "joined_at" : "2021-05-23T22:01:00Z"
}
""".data(using : .utf8)!



protocol DateValueCodableStrategy {
    
    associatedtype RawValue: Codable
    static func decode(_ value: RawValue) throws -> Date
    static func encode(_ date: Date) -> RawValue
}


/**
 [27:41]
 A property wrapper is just a struct
 that is prefixed by this property wrapper enumeration
 
 `@propertyWrapper`
 
 and has a wrapped value
 in this case a date
 
` var wrappedValue: Date`
 */
@propertyWrapper
struct DateValue<Formatter: DateValueCodableStrategy>: Codable {
    
    private let value: Formatter.RawValue
    var wrappedValue: Date
    
    
    init(wrappedValue: Date) {
        
        self.wrappedValue = wrappedValue
        self.value        = Formatter.encode(wrappedValue)
    }
    
    
    init(from decoder: Decoder)
    throws {
        
        let container = try decoder.singleValueContainer()
        
        self.value        = try container.decode(Formatter.RawValue.self)
        self.wrappedValue = try Formatter.decode(value)
    }
}



struct ISO8601Strategy: DateValueCodableStrategy {
    
    typealias RawValue = String
    
    static func decode(_ value: String)
    throws -> Date {
        
        guard
            let date = ISO8601DateFormatter().date(from : value)
        else {
            throw DecodingError.dataCorrupted(.init(codingPath : [] ,
                                                    debugDescription : "Invalid date format: \(value)"))
        }
        return date
    }
    
    
    static func encode(_ date: Date)
    -> String {
        
        ISO8601DateFormatter().string(from : date)
    }
}



struct YearMonthDayStrategy: DateValueCodableStrategy {
    
    typealias RawValue = String
    
    private static let dateFormatter: DateFormatter = {
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "y-MM-dd"
        return dateFormatter
    }()
    
    
    static func decode(_ value: String)
    throws -> Date {
        
        guard
            let date = dateFormatter.date(from: value)
        else {
            throw DecodingError.dataCorrupted(
                .init(codingPath : [] ,
                      debugDescription : "Invalid date format: \(value)")
            )
        }
        return date
    }
    
    
    static func encode(_ date: Date)
    -> String {
        
        dateFormatter.string(from : date)
    }
}



struct Human: Decodable {
    
    let name: String
    // let dateOfBirth: Date
    /**
     [27:25] So imagine we had something like this
     where we have a property wrapper
     called `DateValue`
     that is generic over some sort of type
     that tells it how to decode these dates .
     Here we have a year month day strategy
     and an iso 8601 strategy :
     */
    @DateValue<YearMonthDayStrategy>
    var dob: Date
    
    // let joinedAt: Date
    @DateValue<ISO8601Strategy>
    var joinedAt: Date
}



let decoder = JSONDecoder()
decoder.keyDecodingStrategy = .convertFromSnakeCase

let dorothy = try decoder.decode(Human.self ,
                                 from : json)

dump(dorothy)

/* CONSOLE :
 
 ▿ __lldb_expr_83.Human
   - name: "Dorothy"
   ▿ _dob: __lldb_expr_83.DateValue<__lldb_expr_83.YearMonthDayStrategy>
     - value: "1973-12-04"
     ▿ wrappedValue: 1973-12-04 00:00:00 +0000
       - timeIntervalSinceReferenceDate: -854496000.0
   ▿ _joinedAt: __lldb_expr_83.DateValue<__lldb_expr_83.ISO8601Strategy>
     - value: "2021-05-23T22:01:00Z"
     ▿ wrappedValue: 2021-05-23 22:01:00 +0000
       - timeIntervalSinceReferenceDate: 643500060.0
 */
