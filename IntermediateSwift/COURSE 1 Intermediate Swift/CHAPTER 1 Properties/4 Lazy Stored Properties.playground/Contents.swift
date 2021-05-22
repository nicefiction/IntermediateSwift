import Foundation


/**
 `4 Lazy Stored Properties`
 INTRO — A computed property allowed us
 to compute a value after initialisation was complete
 but we couldn't store the value .
 In this video
 we take a look at lazy stored properties
 that allow us to defer creation
 until after the class has been initialised .
 */
/**
 We just learned about computed properties which allow you to compute
 some value based on external values in other properties ,
 or some part of the app that is dependent on initialisation .
 The downside to computed properties however , is , that they cannot store values .
 We have seen how adding a getter and a setter to a computed property
 made it look like we could assign a value to it to store
 but that is not the case , right ?
 We were just using backing variables
 to modify values
 and return something after a computation .
 What if we wanted a stored property
 whose value also depended on initialisation being complete ?
 Or what if we wanted a property
 but we didn't necessarily want to assign it a value unless we used it ?
 For that ,
 we have a new kind of property , sort of .
 When writing a stored property ,
 you can add the lazy keyword to a property declaration to make it a lazy stored property .
 So what does this mean ?
 A lazy stored property is one whose initial value is not calculated
 until the first time that we call it on an instance . The first time that we use it .
 So in our reading app example ,
 let’s say we have a client that interacts with the articles that we have saved .
 When we asked for an article
 it makes a networking request and downloads it .
 So we could have a class , for example ,
 */
class ReadItLaterNetworkingClient {
    
    lazy var session: URLSession = URLSession(configuration : .default)
    
    // Do other things .
}
/**
 In here ,
 we could have a session variable that creates a network session and then does some work when we need to .
 Let's define the session variable as a lazy var property .
 `NOTE` : You don't need to know what this code is actually doing .
 But just know that until we actually use this class to make a request .
 Let's say down here we have a request method ,
 Do other things ,
 Until we make an actual request ,
 there is no value assigned to the session variable .
 We don't initialise it .
 When we do call it
 then it is assigned to the value that we have specified over here
 `lazy var session: URLSession = URLSession(configuration : .default)`
 which could be a value that depends on initialisation of the class being complete .
 
 Now why does this matter ?
 Because essentially ,
 this is just a stored property that we are deferring the creation of .
 Well , some objects are expensive to create .
 They perform a lot of logic and their initialisation process is quite complex .
 With such objects , we don't want to create it until you really need to use it .
 Lazy loading properties ensure that you don't waste computational power needlessly .
 A good example of this is the NSDateFormatter class .
 NSDateFormatter is a class we used in Swift 2.
 It was part of the Foundation framework
 that helps convert between time stamps and String representations of dates .
 Depending on your locale and display preference .
 Creating this object was computationally expensive .
 So oftentimes we deferred the creation of it right up until when we needed it
 by using the lazy stored property . After that , once it is created ,
 a lazy stored property always uses that same instance without creating more needlessly .
 Then , in Swift 3 , we have a new class ,
 DateFormatter
 that does the same job ,
 but has different memory characteristics .
 So it is not necessarily as expensive anymore .
 However there are plenty of other cases to use lazy properties .
 We may not use lazy properties as much in our code ,
 but it is good to be aware of why we are doing it when we do .
 The syntax is trivial really
 all we are doing is adding the lazy keyword to a regular stored property .
 Because a lazy property is not immediately initialised when the instance is created ,
 it cannot be a constant or a let property .
 Like a computed property
 it needs to be a variable .
 Think of it this way ,
 if you are not going to use the stored property
 when you immediately create the object ,
 but you do need it as a stored property so you can reference it throughout the class ,
 then it might make sense to lazy load it to save resources .
 */
