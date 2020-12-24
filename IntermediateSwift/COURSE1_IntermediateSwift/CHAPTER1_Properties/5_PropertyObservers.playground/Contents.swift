import Foundation
import UIKit
import PlaygroundSupport


/**
 `5 Property Observers`
 INTRO — One of the last things we are going to look at regarding properties ,
 are observers .
 A property observer allows you
 to execute some code
 any time a value is set
 or about to be set .
 */
/**
 The last thing we are going to learn about today , in relation to properties ,
 are property observers .
 Property observers allow us
 to observe
 and respond
 to changes in property values .
 This is a really useful feature that lets us change other parts of our code
 if a property's value changes . So ,
 let's look at a very simple example :
 */
class ViewController: UIViewController {
    
    let slider = UISlider()
    
    
    var value: Double = 0.00 {
        
        willSet {
            print("Old value: \(value)")
        }
        
        didSet {
            view.alpha = CGFloat(value)
            print("New value: \(value)")
        }
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = UIColor(red : 30/255.0 ,
                                       green : 36/255.0,
                                       blue : 40/255.0 ,
                                       alpha : 1.0)
        
        // Adds target-action pattern for value changed event :
        slider.addTarget(self ,
                         action : #selector(viewController.slide(sender:)) ,
                         for : .valueChanged)
    }
    
    
    override func viewWillLayoutSubviews() {
        
        super.viewWillLayoutSubviews()
        // Programmatically adds constraints to setup layout :
        view.addSubview(slider)
        
        slider.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            slider.centerXAnchor.constraint(equalTo : view.centerXAnchor) ,
            slider.centerYAnchor.constraint(equalTo : view.centerYAnchor) ,
            slider.heightAnchor.constraint(equalToConstant : 30) ,
            slider.widthAnchor.constraint(equalToConstant : 400)
        ])
    }
    
    // Method for target-action
    @objc func slide(sender: UISlider) {
        value = Double(sender.value)
    }
}


let viewController = ViewController()
PlaygroundPage.current.liveView = viewController.view
/**
 Now , here is a new trick .
 You can actually do UI code ,
 you can write UI code , inside of a playground page .
 So , here we have some iOS related code in the Swift playground
 where we are creating a ViewController that displays a view .
 At the top here I have imported this framework called PlaygroundSupport :
 `import PlaygroundSupport`
 PlaygroundSupport is a Swift playground framework that allows us to display views .
 So , at the bottom here ,
 I have gone ahead and created an instance of the ViewController ,
 as you can see right here :
 `let viewController = ViewController()`
 And then I have assigned the view from that ViewController to a property
 on this PlaygroundPage called liveView :
 `PlaygroundPage.current.liveView = viewController.view`
 Then when you click on the assistant editor ,
 you should see the view pop up right here .
 Now , it is a bit constrained , but this is our view that we have created , along with the slider .
 Let's go through this .
 So , the setup is really simple .
 When you move the slider back and forth ,
 the opacity of the view changes to fade the view in and out .
 So , up at the top we have a slider , which is what you saw , ( which I can't even see anymore ) .
 And then inside the viewDidLoad( ) method we are doing something simple .
 We are just setting the backgroundColor on the view :
 */
/*
view.backgroundColor = UIColor(red : 30/255.0 ,
                               green : 36/255.0,
                               blue : 40/255.0 ,
                               alpha : 1.0)
*/
/**
 `NOTE` : You don't really need to know any of this .
 
 And then
 when we move the slider
 we are executing the code inside this function slide( ) :
 */
/*
@objc func slide(sender: UISlider) {
    value = Double(sender.value)
}
*/
/**
 This code is related to setting up the view programmatically ,
 we are positioning that slider and so on :
 */
/*
NSLayoutConstraint.activate([
    slider.centerXAnchor.constraint(equalTo : view.centerXAnchor) ,
    slider.centerYAnchor.constraint(equalTo : view.centerYAnchor) ,
    slider.heightAnchor.constraint(equalToConstant : 30) ,
    slider.widthAnchor.constraint(equalToConstant : 400)
])
 */
/**
 Again , nothing important .
 The interesting part is this value property that we have created over here :
 */
/*
var value: Double = 0.0 {
    
    willSet {
        print("Old value: \(value)")
    }
    
    didSet {
        view.alpha = CGFloat(value)
        print("New value: \(value)")
    }
}
*/
/**
 So, this is a variable stored property
 named
 value
 of type Double .
 Just like a computed property ,
 the declaration is followed by a set of braces .
 Now , inside the braces
 we have something new ,
 these — willSet and didSet — are property observers .
 Remember , we said that a property observer
 allows us
 to observe
 and respond to
 changes in a property's values .
 There are two kinds of observers ,
 didSet and willSet .
 `didSet` is called immediately after we assign a value to the stored property right here .
 Any code that we put inside the didSet clause
 is executed
 every time after the value has been assigned .
 The opposite of that is willSet .
 `willSet` is called right before we change the underlying value .
 In our case , every time we assign a value to the stored property ,
 `var value: Double = 0.00 { ... }`
 `@objc func slide(sender: UISlider) { value = Double(sender.value) }`
 we are using that value
 to change the alpha property on our background view :
 */
/*
didSet {
    view.alpha = CGFloat(value)
    print("New value: \(value)")
}
*/
/**
 Alpha controls the view's opacity , where 0 is hidden , and 1 is fully visible .
 So , here when we set the value on the slider ,
 `view.alpha = CGFloat(value)`
 what we are doing , is ,
 calling this method at the bottom :
 `@objc func slide(sender: UISlider) { value = Double(sender.value) }`
 And then we are assigning these sliders’ value to that value stored property ,
 which fluctuates between 1 and 0 .
 And when we do that ,
 when the underlying value on that value stored property changes using the didSet property observer ,
 we can effect other parts of our code .
 And here , we are choosing to effect the `view.alpha` property :
 */
/*
didSet {
    view.alpha = CGFloat(value)
    print("New value: \(value)")
}
*/
/**
 Property observers are really simple ,
 but they allow us
 to write code
 that is dependent on a property being changed .
 In addition to didSet ,
 which is called immediately after the property's value has been set ,
 we also have willSet , which is called right before the property value is set .
 And you can see how these two differ
 by inspecting the output of the print statements .
 So , down here you can see , we'll go up to the very top ,
 (...) and you'll see that the Old value ,
 which was on willSet the first time we called was 0 ,
 and then the second we start sliding the slider around ,
 a New value is assigned in didSet .
 And then again , when we move it ,
 Old value reflects the New value ,
 and so on .
 
 It is important to note that willSet and didSet are not called
 when setting properties during the initialisation process in an init( ) method , only after .
 `NOTE` : This ...
 `var value: Double = 0.00 { ... }`
 ... is an actual stored property .
 You can assign it values ,
 just like any other stored property .
 All we are doing here ,
 `willSet {  print("Old value: \(value)") }`
 `didSet {`
    `view.alpha = CGFloat(value)`
    `print("New value: \(value)")`
 `}`
 is ,
 observing these property value changes
 and then affecting other parts of our code .
 
 `Note` : You can add property observers to any stored property
 except ones that are lazily loaded .
 So , you cannot add it to a lazy stored property ,
 nor can you add it to a computed property .
 
 Also `NOTE` , the usage here is purely for the sake of teaching .
 We could have easily changed the view's alpha property right here ...
 `didSet {`
    `view.alpha = CGFloat(value)`
    `print("New value: \(value)")`
 `}`
 ... inside the slide( ) method ,
 `@objc func slide(sender: UISlider) { value = Double(sender.value) }`
 rather than going through the property observer .
 But now you get what it does . In the future ,
 you’ll see that property observers allow us to do interesting things .
 */
 


/**
 These variations on stored properties , and properties in general ,
 aren't concepts you need to utilise in every Class , Struct , or Enum ,
 but they are good to be familiar with .
 Some good use cases will emerge as we work through the rest of the examples .
 And I bet you'll find plenty of opportunities to use these in your own code .
 Computed properties are a big one .
 In past courses we have written many simple functions that just returned a value .
 Those are good candidates for computed properties .
 
 
 On to the next topic .
 */


/* PAUL HUDSON */
var score: Int = 0 {
    willSet(newScore) { // OLIVIER : newValue is the default name of the local binding .
        print("The old score was \(score) . It will change to \(newScore) .")
    }
    
    didSet {
        print("The new score is now \(score) . The old score was \(oldValue) .")
    }
}

score = 1
score = 2
score = 3


/**
 `APPLE DOCS`
 Property observers observe and respond to changes in a property’s value .
 Property observers are called every time a property’s value is set ,
 even if the new value is the same as the property’s current value .
 
 You can add property observers in the following places :
 
 1. Stored properties that you define
 2. Stored properties that you inherit
 3. `Computed properties that you inherit`
 
 If you implement a `willSet observer` ,
 it is passed the new property value as a constant parameter .
 You can specify a name for this parameter as part of your willSet implementation .
 If you don’t write the parameter name and parentheses within your implementation ,
 the parameter is made available with a default parameter name of `newValue` .
 
 Similarly , if you implement a `didSet observer` ,
 it is passed a constant parameter containing the old property value .
 You can name the parameter or use the default parameter name of `oldValue` .
 If you assign a value to a property within its own didSet observer ,
 the new value that you assign replaces the one that was just set .
 */
class StepCounter {
    var totalSteps: Int = 0 {
        willSet(newValue) {
            print("Your total number of steps was \(totalSteps) . This has changed to \(newValue) .")
        }
        
        didSet {
            print("You have done \(totalSteps) steps today .")
        }
    }
}

let stepCounter: StepCounter = StepCounter()
stepCounter.totalSteps = 10
