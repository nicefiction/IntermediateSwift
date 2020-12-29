import Foundation
import UIKit


/**
 `6. Required Initialisers`
 INTRO — Sometimes we want a user of our type
 whether a subclass
 or value type — conforming to a protocol — ,
 to provide an implementation for a certain initialiser .
 Swift allows us to do this through required initialisers .
 */
/**
 Let's spend some time talking about
 the last topic in initialisation .
 And that is required initialisers .
 Sometimes we want all subclasses of a particular superclass
 to implement a certain initialiser .
 For that we have another keyword , `required` .
 By adding required to an init( ) method ,
 we are indicating that all subclasses must provide
 an implementation for this particular init( ) method .
 For example ,
 */
class SomeClass {
    
    required init() {}
}


class AnotherClass: SomeClass {
    
    init(test: String) {}
    
    
    required init() {
        fatalError("init() has not been implemented")
    }
}


//let anotherClass = AnotherClass(test : "TEST") // OLIVIER
//print(anotherClass) // OLIVIER
/**
 We'll get an error . And if we hit enter , it goes ahead and puts
 `required init() {`
    `fatalError("init() has not been implemented")`
 `}`
 In here ,
 we really need to provide an implementation
 but , automatically , a fatalError statement is added .
 So that if we do go through this route
 but haven't provided an implementation ,
 the app will crash , or our code crashes .
 
 So where does this kind of initialiser come into play
 and why is it necessary ?
 It can be hard to imagine without any context
 but a good example is the UIViewController class from the UIKit framework in iOS :
 */
/*
class ViewController: UIViewController {
    
    init() {}
    
    // ERROR : 'required' initializer 'init(coder:)' must be provided by subclass of 'UIViewController' .
}
 */
/**
 The moment we add a custom init( ) method ,
 we again get a compiler error
 saying that the required initialiser has not been implemented .
 Let's click that automatic fix this time ,
 and see what that required initialiser is :
 */
class ViewController: UIViewController {
    
    // init() {} // ERROR : 'super.init' isn't called on all paths before returning from initializer .
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
/**
 UIViewController's required initialiser
 accepts an instance of NSCoder
 to set up the class :
 `required init?(coder: NSCoder) { ... }`
 Why is it required though ?
 When you use your app in iOS ,
 the system saves its state at different points .
 To handle this archiving and unarchiving ,
 UIViewController conforms to an NSCoder protocol that determines
 how it is saved and retrieved .
 The required init coder initialiser
 allows an archived ViewController
 to be unarchived
 by providing an object — aDecoder — that will handle the process :
 `required init?(coder: NSCoder) { ... }`
 When our ViewController doesn't have any stored properties ,
 the archiving and unarchiving process is easy .
 Because our view components are handled in a UI file or a storyboard file .
 And all that is handled for us .
 When we add a stored property ,
 which is what adding a custom initialiser indicates ,
 `init() {} // ERROR : 'super.init' isn't called on all paths before returning from initializer .`
 this triggers the required initialiser requirement :
 `required init?(coder: NSCoder) { ... }`
 Now inside this required init( ) method , we have an issue .
 This required init( ) method is intended for unarchiving the class
 and assigning values to properties that were archived .
 But we may not want to do that ,
 so we don't necessarily need this initialiser .
 If we define this class all in code for example rather than from a UI file ,
 this initialiser is completely unnecessary .
 Unfortunately there is no way around this , because it is a required initialiser .
 If you add stored properties to a ViewController ,
 you need to add the required init coder initialiser method :
 `required init?(coder: NSCoder) {`
    `fatalError("init(coder:) has not been implemented")`
 `}`
 But because we cannot customise this init( ) method
 and cannot accept arguments for our properties .
 We have to either assign dummy values ,
 or fake values in this ,
 or crash the app if this initialiser is invoked .
 
 All you need to do
 to take away from this lesson , is ,
 that a required initialiser is one that needs to be implemented by all subclasses .
 And you do that when you have a very specific reason for doing so . Also ,
 you should NOTE that if you define an initialiser method in a Protocol .
 When your conforming types implement it , it is also marked as a required initialiser .
 
 Let’s get rid of the error
 `init() {} // ERROR : 'super.init' isn't called on all paths before returning from initializer .`
 by calling super.init ,
 */
class ViewController2: UIViewController {
    
    init() {
        super.init(nibName : nil ,
                   bundle : nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
/**
 so you see here that ,
 because init( ) that I have defined for the ViewController subclass
 is a designated initialiser ,
 I need to go ahead
 and call a designated initialiser in the base class — UIViewController . So , I call
 super.init with nibName — one of the designated initialisers in the UIViewController class :
 `init() {`
    `super.init(nibName : nil , bundle : nil)`
`}`
 And now we should get rid of our warnings .
 The initialisers we have added
 — both the custom one
 `init() {`
    `super.init(nibName : nil , bundle : nil)`
`}`
 and the required init coder — ...
 `required init?(coder: NSCoder) {`
    `fatalError("init(coder:) has not been implemented")`
 `}`
 ... are designated initialisers for the ViewController subclass .
 Remember that a class can contain more than one designated initialiser .
 In your case , you'll mostly run into it
 when creating a custom initialiser for UIKit classes that you subclass .
 Since these are both designated initialisers ,
 they have the responsibility of also initialising their superclasses . So in here ,
 rather than the fatalError( ) ,
 we could initialise a superclass by calling super.init coder ,
 and passing that same decoder through :
 */
class ViewController3: UIViewController {
    
    init() {
        super.init(nibName : nil ,
                   bundle : nil)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        // fatalError("init(coder:) has not been implemented")
        super.init(coder : aDecoder)
    }
}



/**
 And that was a deep dive
 into the world of Swift initialisers .
 Why is this important ? Well ,
 as we tried to make custom ViewController subclasses
 or custom subclasses of any kind .
 We are going to run into the challenge of implementing required initialisers
 that call the relevant superclass' designated initialiser .
 So now you know why it happens and how you should handle it .
 `NOTE` : The topic of required initialisers returns in
 Course 4 — Build an Interactive Story App with Swift 
    CHAPTER 3 — Creating the User Interface Programmatically
        -> 1 Page Controllers
 */
