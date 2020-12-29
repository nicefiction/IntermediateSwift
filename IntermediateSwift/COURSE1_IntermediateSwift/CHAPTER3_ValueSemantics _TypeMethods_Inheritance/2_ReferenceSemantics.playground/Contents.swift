import Foundation


/**
 `2 Reference Semantics`
 INTRO — In contrast to value types ,
 reference types aren't copied
 and this leads to some very interesting behaviour .
 In this video , we examine
 why constants don't really mean immutable for a reference type .
 */
/**
 Reference types are simpler to understand
 but can lead to some headaches as well , which we'll see .
 We'll start with the basics by writing a very simple class :
 */
class Robot {
    
    var model: String
    
    
    init(model: String) {
        
        self.model = model
    }
}


var someRobot = Robot(model: "T1_999")
let anotherRobot = someRobot

someRobot.model = "T2_000"
/**
 So now ,
 if we change the model value for someRobot
 and inspect the model value in anotherRobot .
 */
print("someRobot : \(someRobot.model)")
print("anotherRobot : \(anotherRobot.model)")
/**
 You'll see that the value of model here has changed as well .
 Now this makes sense based on what we know about reference types .
 Assigning the instance
 assigned to one variable
 to another,
 assigns that same object
 because the variable is holding a reference to an object in memory
 rather than the object itself .
 
 Okay ,
 now let's create another instance of robot :
 */
let thirdRobot = Robot(model: "T3_000")
/**
 Again based on what we know , since this is a constant ,
 we shouldn't be able to mess with thirdRobot , right ?
 Unfortunately not here .
 Here I can easily assign a new String to the model property of the instance ,
 even though we are doing it through a let constant .
 So if I say
 */
thirdRobot.model = "T4_000"
/**
 I shouldn't have any issues .
 How is this possible ? Well ,
 remember how we said
 that the variable doesn't contain the actual object
 but a reference to the object in memory ?
 When we are assigning
 an instance of a reference type
 to a constant ,
 the thing that is constant
 again
 isn't the object ,
 it is the reference
 to the object .
 This means that
 we can't assign another instance of robot to thirdRobot .
 But
 we can change the underlying object as much as we want .
 Unlike value types where the object is copied ,
 assigned a new value
 and then reassigned to the variable or a constant when we mutate the stored properties .
 None of that happens with a reference type .
 You can change the underlying properties on a constant here
 because we are working with that same object . Meaning
 the reference to the object doesn't change
 but the stored properties can be changed pretty easily .
 You have got to be careful about this .
 When we started learning about Swift ,
 the very first lesson we learned was that variables can change , constants don't change .
 As you can see now , this isn't as cut and dry
 and it really depends on whether your object is a value or a reference type .
 There is one more minor variation on this .
 We are going to look at in the next video .
 Join me there .
 */
