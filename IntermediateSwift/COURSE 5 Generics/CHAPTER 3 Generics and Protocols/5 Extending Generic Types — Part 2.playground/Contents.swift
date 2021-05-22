import Foundation


/**
 `5 Extending Generic Types` PART 2 of 2
 */
/**
 ... and then comment out the Array extension :
 */

struct Weather {
    
    let temperature: Double
    let humidity: Double
    let chanceOfRain: Double
    let icon: String
    let highTemperature: Double
    let lowTemperature: Double
    let sunrise: Date
    let sunset: Date
}

let currentWeather = Weather(temperature : 63 ,
                             humidity : 0.36 ,
                             chanceOfRain : 0.04 ,
                             icon : "Cloudy" ,
                             highTemperature : 67 ,
                             lowTemperature : 50 ,
                             sunrise : Date() ,
                             sunset : Date())
                      
// print(current)


extension Weather: PrettyPrintable {
    
    var prettyDescription: String {
        
        return """
            Temperature : \(temperature)\nHumidity : \(humidity)\nChance of Rain : \(chanceOfRain) \nIcon : \(icon)\nHigh Temperature : \(highTemperature)\nLow Temperature : \(lowTemperature)\nSunrise time : \(sunrise)\nSunset time : \(sunset)
            """
    }
}

// print(current.prettyDescription)


protocol PrettyPrintable {
    
    var prettyDescription: String { get }
}
    

let tuesdayWeather = Weather(temperature : 63 ,
                             humidity : 0.36 ,
                             chanceOfRain : 0.04 ,
                             icon : "Cloudy" ,
                             highTemperature : 67 ,
                             lowTemperature : 50 ,
                             sunrise : Date() ,
                             sunset : Date())

let wednesdayWeather = Weather(temperature : 63 ,
                               humidity : 0.36 ,
                               chanceOfRain : 0.04 ,
                               icon : "Cloudy" ,
                               highTemperature : 67 ,
                               lowTemperature : 50 ,
                               sunrise : Date() ,
                               sunset: Date())

let thursdayWeather = Weather(temperature : 63 ,
                              humidity : 0.36 ,
                              chanceOfRain : 0.04 ,
                              icon: "Cloudy" ,
                              highTemperature : 67 ,
                              lowTemperature : 50 ,
                              sunrise : Date() ,
                              sunset: Date())
    

let weeklyWeather = [
    currentWeather , tuesdayWeather , wednesdayWeather , thursdayWeather
]

let array = [ 1 , 2 ]


//extension Array
//where Element: PrettyPrintable {
//
//    var prettyDescription: String {
//        var output = ""
//
//        for (index, element) in self.enumerated() {
//
//            output += "\n\n********\n\nIndex:\(index)\n\n\(element.prettyDescription)"
//        }
//
//        return output
//    }
//}
    

extension Sequence
where Iterator.Element == Weather {
    
    var prettyDescription: String {
        
        var output = ""
        
        
        for (index , element) in self.enumerated() {
            
            output += "\n\n********\n\nIndex:\(index)\n\n\(element.prettyDescription)"
        }
        
        return output
    }
}


/**
 Down here — right at the bottom — we can call
 */

print(weeklyWeather.prettyDescription)

/**
 And you'll get the exact same console log statements as we designed earlier .
 So here we have the same line of `prettyDescription` of `Weather`
 but it is far more specific .
 
 Being able to add extensions to generic and protocol types with constraints
 is a very powerful feature .
 And although you might not use it often
 it is important to know how this is done .
 */
/**
 `ASIDE`
 Now , real quick . We have never talked about this function before ,
 but there is actually a function that returns a very nicely formatted console log of any object
 and it is called `dump( )` . So if I were to call
 */

dump(currentWeather)

/**
 Look at that [ OLIVIER : in the console ] , much nicer .
 It even displays it like tabbed ,
 with like indentation to show underlying properties of underlying type .
 So if you go back and inspect `Sunrise` [ OLIVIER : in the results area of the console ? ]
 you'll see that it is a `foundation type date`
 and it has an underlying property
 and we get that value as well .
 
 
 
 
 Okay , and with that , let’s wrap up this course .
 You have learned a ton of new stuff , so as always , great job .
 Pretty soon we are going to use all of this to write safer , more robust code
 that helps us solve problems more elegantly . Until then though
 write more code , experiment with everything we have just learned here ,
 go back to any other code you have written , and see if you can streamline
 that make it more safe by using generics in certain places ,
 but don't go overboard .
 Most importantly have fun .
 */
