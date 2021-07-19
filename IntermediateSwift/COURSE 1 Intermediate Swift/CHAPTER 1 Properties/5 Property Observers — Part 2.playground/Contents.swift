import Foundation


// MARK: - PAUL HUDSON -

var score: Int = 0 {
    
    willSet(newScore) {
        // OLIVIER : newValue is the default name of the local binding .
        print("The old score was \(score) . It will change to \(newScore) .")
    }
    
    
    didSet {
        
        print("The new score is now \(score) . The old score was \(oldValue) .")
    }
}


score = 1
// The old score was 0 . It will change to 1 .
// The new score is now 1 . The old score was 0 .
score = 2
// prints The old score was 1 . It will change to 2 .
// prints The new score is now 2 . The old score was 1 .
score = 3
// prints The old score was 2 . It will change to 3 .
// prints The new score is now 3 . The old score was 2 .



// MARK: - APPLE DOCS -

/**
 `Property observers`
 observe and respond
 to changes
 in a property’s value .
 Property observers are called every time a property’s value is set ,
 even if the new value is the same as the property’s current value .
 
 You can add property observers in the following places :
 
 1. Stored properties that you define
 2. Stored properties that you inherit
 3. Computed properties that you inherit
 
 If you implement a `willSet` observer ,
 it is passed the _new property value_ as a constant parameter .
 You can specify a name for this parameter as part of your `willSet` implementation .
 If you don’t write the parameter name and parentheses within your implementation ,
 the parameter is made available with a default parameter name of `newValue` .
 
 Similarly , if you implement a `didSet` observer ,
 it is passed a constant parameter containing the _old property value_ .
 You can name the parameter
 or use the default parameter name of `oldValue` .
 If you assign a value to a property
 within its own didSet observer ,
 the new value that you assign
 replaces the one that was just set .
 */

class StepCounter {
    
    var totalSteps: Int = 0 {
        
        willSet(newValue) {
            
            print("Your total number of steps was \(totalSteps) . This has changed to \(newValue) .")
        }
        
        
        didSet {
            
            print("You have done \(totalSteps) steps today .")
            print("You have done \(oldValue) steps today .")
        }
    }
}


let stepCounter: StepCounter = StepCounter()
stepCounter.totalSteps = 10
// prints Your total number of steps was 0 . This has changed to 10 .
// prints You have done 10 steps today .
// prints You have done 0 steps today .
