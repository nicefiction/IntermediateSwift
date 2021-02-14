import Foundation
import UIKit


/**
 `2 Protocol Conformance Using Extensions`
 INTRO — One of the most useful aspects of extensions is
 that we can add protocol conformance to any existing types .
 This allows us to not only add
 conformance of native protocols to custom types
 but the other way around as well
 — where we extend native types
 to conform
 to our custom protocols .
 */
/**
 Just like we can add computed properties , instance methods , and so on ,
 we can also add protocol conformance to an existing type through an extension .
 Let's assume I really want to uniquely identify my views .
 Views — or `UIView` instances — from the iOS SDK already have a tag property .
 But I want a unique identifier auto generated . So let's define a protocol for this :
 */

protocol CanDoUniqueIdentify {
    
    var uuid: Int { get }
}

/**
 `NOTE` : `uuid` stands for _universally unique identifier_ .
 It is a standard way to define a unique ID for an object . Even your iPhone has a `UUID` .

 We want all our views — all instances of `UIView` — to have this `uuid` property .
 One way we could do this , is ,
 to create a subclass of `UIView`
 and make it conform to the `CanDoUniqueIdentify` protocol ,
 then provide an implementation .
 We could call the subclass `UniquelyIdentifiableView` .
 From there , we could treat `UniquelyIdentifiableView` as the superclass
 for all the views that we want to create ,
 and then subclass it for further use .
 Now this works , of course , but that is not the point of inheritance ,
 and we have created a subclass that adds very little . Instead ,
 we are going to use `composition`
 along with an `extension`
 to add `protocol conformance`
 to an existing type .
 */

extension UIView: CanDoUniqueIdentify {
    
    var uuid: Int {
        
        return hash
    }
}

/**
 STEP 1 — To get UIView , I need to `import UIKit` .
 STEP 2 — We start with the keyword `extension` ,
 followed by the type we want to extend , which is `UIView` .
 STEP 3 — Then in this extension ,
 we specify which protocol we are conforming to — `CanDoUniqueIdentify`.
 STEP 4 — We conform to the `CanDoUniqueIdentify` protocol ,
 by adding a computed property .
 All objects that inherit from `NSObject`
 — which is the base class in Objective C for all classes —
 contain a property called `hash` that uniquely identifies data .
 Here , we are exposing that hash value to act as a uuid .
 Now that we have a `uuid` property on every instance of `UIView` that we create ,
 let’s create an instance of `UIView` :
 */

let view = UIView()
view.hash
view.uuid

view is CanDoUniqueIdentify

/**
 So this is a class that was part of a SDK that we had no part in writing , right ?
 This is Apple's code , but through an `extension` ,
 we were able to make that type conform to a protocol of ours .
 Extensions used this way are really useful
 and allow us
 to add common functionality to native types
 as we need in our code base .
 */
