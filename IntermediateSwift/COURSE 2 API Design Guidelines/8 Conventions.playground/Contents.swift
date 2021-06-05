import Foundation


/**
 `8 Conventions`
 INTRO — Let's wrap this course up by talking about
 a few remaining conventions .
 */
/**
 While we are all done with our lists of rules and exceptions ,
 we have one small thing left to cover ,
 and that is a series of conventions .
 We'll treat this video more or less as a grab bag of different things .
 First up ,
 `1. Boolean Methods` .
 This one is simple . As we saw earlier ,
 with Boolean properties ,
 we want Boolean Methods to read as `assertions` .
 If you understood how to do this with properties ,
 methods aren't that much different ,
 and here is a simple example :
 
 `func isInRange(of point: Point)`
 
 The instance method returns `true` if a point in consideration is in range , `false` if not .
 Since this is a `Boolean Method` , we write it as an `assertion` _isInRange_ .
 
 Next up are
 `2. parameters` .
 We have covered a lot of ground with `argument labels` ,
 there is just a few random things in this set of guidelines :
    `2.1`  We always want to choose parameter names that serve `documentation` .
 So here `parameter name` refers to what we have been calling the `local argument name` .
 Even though this does not show up at the use site , at the point of definition
 the choice of name for the `parameter` should clearly document its role in the function .
 This is why earlier , we chose _index_ over using the letter _i_ .
    `2.2` In Swift , parameters can take `default values` ,
 and you are encouraged to use this feature where possible
 to simplify function signature
 and make it more readable .
 In Objective C — and in other languages —
 it is common to define method families
 where you have one version of a method
 that takes all your arguments ,
 and then successively simpler ones ,
 where each one provides a default value
 to the next method .
 In Swift ,
 `default arguments` are preferable to the use of `method families` .
 Here we have an example of a method name that provides
 either empty values or nil for the arguments past the first one :
 
 `let order = lastName.compare(royalFamilyName ,`
                              `options : [] ,`
                              `range : nil ,`
                              `locale : nil)`
 
 `let order = lastName.compare(royalFamilyName)`
  
 This method reads much better and reduces cognitive burden
 through the use of default values . Just remember ,
 if you do use `default arguments` ,
 to keep those `default arguments` at the end of the `function signature` .
    Speaking along the lines of method families ,
 it is okay for `free functions` to share the same `base name` ,
 as long as they do the same thing more or less .
 In the case of methods , same `base names` are fine
 if they operate within different domains .
 Here we have two methods named `contains()`:
 
 `extension Shape {`
 
    `func contains(_ other: Point) -> Bool`
 `}`
 
 
 `extension Collection {`
 
    `func contains(_ sought: Element) -> Bool`
 `}`
   
 One operates on a `Shape type` , one operates on a `Collection` .
 These are two `distinct domains`
 and there is not a lot of room for confusion .
 However two methods named `index()` on a `Collection type` for example ,
 would be a bad idea .
  
  
 Okay , with that , let’s wrap it up .
 We have learned a bunch of new guidelines here ,
 so it is probably best to let it sink in for a while .
 As I mentioned at the beginning of this course ,
 you really don't have to internalise all of this at once .
 In fact it is probably best to take a few of the base rules
 and spend time using them
 until you are quite familiar before moving on .
 Honestly ,
 I haven't fully implemented all these guidelines yet myself
 and often have to come back to this list to understand some exception or another .
 Okay , see you in the next course .
 */
