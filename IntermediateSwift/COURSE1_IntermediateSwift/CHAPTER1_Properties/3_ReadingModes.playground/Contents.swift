import Foundation
import UIKit


/**
 `3 Reading modes`
 INTRO — In this video we take a look at
 how an enum
 and computed properties
 can simplify our code .
 */
/**
 In my free time ,
 I have been building an app that includes a reading mode ;
 blog post , web articles , that sort of thing .
 Most apps that include a reading component also includes a set of themes .
 Typically the themes are day , evening , and night mode
 to help you read better with less eye strain .
 Day modes have bright backgrounds with dark text ,
 night mode is the inverse ,
 and evening maybe somewhere in between .
 When a user switches from one mode to another ,
 there are lots of things that needs to be changed in the UI .
 Since there are a finite set of reading modes ,
 we can represent this as an enum of different cases :
 */
enum ReadingMode {
    case day
    case evening
    case night
    
    
    var statusBarStyle: UIStatusBarStyle {
        
        switch self {
        case .day , .evening : return .default
        case .night          : return .lightContent
        }
    }
    
    
    var headlineColor: UIColor {
        
        switch self {
        case .night : return UIColor(red : 1.0 ,
                                     green : 1.0 ,
                                     blue : 1.0 ,
                                     alpha : 1.0)
        case .day , .evening : return UIColor(red : 16/255.0 ,
                                              green : 16/255.0,
                                              blue : 16/255.0 ,
                                              alpha : 1.0)
        }
    }
    
    
    var dateColor: UIColor {
        switch self {
        case .day , .evening : return UIColor(red : 132/255.0 ,
                                              green : 132/255.0 ,
                                              blue : 132/255.0 ,
                                              alpha : 1.0)
        case .night : return UIColor(red : 151/255.0 ,
                                     green : 151/255.0 ,
                                     blue : 151/255.0 ,
                                     alpha : 1.0)
        }
    }
    
    
    var bodyTextColor: UIColor {
        
        switch self {
        case .day , .evening : return UIColor(red : 1 ,
                                              green : 1 ,
                                              blue : 1 ,
                                              alpha : 1)
        case .night : return UIColor(red : 151/255.0 ,
                                     green : 151/255.0 ,
                                     blue : 151/255.0 ,
                                     alpha : 1.0)
        }
    }
    
    
    var linkColor: UIColor {
        
        switch self {
        case .day , .evening : return UIColor(red : 132/255.0 ,
                                              green : 132/255.0 ,
                                              blue : 132/255.0 ,
                                              alpha : 1.0)
        case .night : return UIColor(red : 161/255.0 ,
                                     green : 161/255.0 ,
                                     blue : 161/255.0 ,
                                     alpha: 1.0 )
        }
    }
}
/**
 So here we have day , evening , and night :
 `case day`
 `case evening`
 `case night`
 If we go back to the three different modes ,
 you'll see that lots of things vary between each mode .
 And my way of encapsulating this , is ,
 to add computed properties for each thing that can change .
 So here we have a computed property for the statusBarStyle :
 */
/*
var statusBarStyle: UIStatusBarStyle {
    switch self {
    case .day, .evening: return .default
    case .night: return .lightContent
    }
}
*/
/**
 So for example
 if you look at a single computed property
 it returns a UIStatusBarStyle .
 It then switches on the mode that we are in .
 
 So if we are in night mode
 and we call the headlineColor property , ...
 */
/*
var headlineColor: UIColor {
    
    switch self {
    case .night : return UIColor(red : 1.0 ,
                                 green : 1.0 ,
                                 blue : 1.0 ,
                                 alpha : 1.0)
    case .day, .evening : return UIColor(red : 16/255.0 ,
                                         green : 16/255.0,
                                         blue : 16/255.0 ,
                                         alpha : 1.0)
    }
}
 */
/**
 ... it switches on that and returns the relevant value ,
 which for now these are just fake values .
 If it is day , and evening , it returns a different value .
 And we have done this for everything .
 
 So every time we call dateColor
 the property figures out what mode we're in ,
 and then returns the right value :
 */
/*
var dateColor: UIColor {
    switch self {
    case .day , .evening : return UIColor(red : 132/255.0 ,
                                          green : 132/255.0 ,
                                          blue : 132/255.0 ,
                                          alpha : 1.0)
    case .night : return UIColor(red : 151/255.0 ,
                                 green : 151/255.0 ,
                                 blue : 151/255.0 ,
                                 alpha : 1.0)
    }
}
 */
/**
 So in our app ,
 our view set of code could look something like this :
 */
let titleLabel = UILabel()


func setUpDisplay(with mode : ReadingMode) {
    
    titleLabel.textColor = mode.headlineColor
}


setUpDisplay(with : .night)
setUpDisplay(with : .day)
/**
 Now every time we call the method ,
 I don't have to worry about what color is being used .
 You'll see that the right color was returned up here
 in headlineColor :
 */
/*
var headlineColor: UIColor {
    
    switch self {
    case .night : return UIColor(red : 1.0 ,
                                 green : 1.0 ,
                                 blue : 1.0 ,
                                 alpha : 1.0)
    case .day, .evening : return UIColor(red : 16/255.0 ,
                                         green : 16/255.0,
                                         blue : 16/255.0 ,
                                         alpha : 1.0)
    }
}
 */
/**
 We don't have to assign different colour values every time
 and worry about
 which mode we are in at a particular point in our UI .
 We can just pass in the right mode to our setUpDisplay( ) function ,
 and it does the rest ,
 neat and simple .
 
 Computed properties and enums are one of my favourite pairings in Swift .
 
 
 Okay, on to the next topic .
 */
