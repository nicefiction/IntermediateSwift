import Foundation


/**
 `CHAPTER 5`
 `Memory Management in Swift`
 When people first started programming ,
 paying explicit attention to
 how you used computer memory
 was very important .
 Nowadays
 much of this knowledge has been abstracted away from us ,
 but this doesn't mean it is not a concern or unimportant .
 In the next set of videos
 we take a look at
 the memory management model in Swift .
 We start with a bit of history ,
 followed by a brief overview of the current state .
 After that ,
 we conclude by looking at
 some of the mistakes we can make in our code .
 */
/**
 `1 Manual Retain Release`
 INTRO — In today's iOS landscape ,
 you most likely won't have to deal with manually retaining or releasing ,
 but it is still a topic you should be familiar with .
 Not only will it flesh out your understanding of iOS history ,
 but you may one day find yourself sifting through pre-ARC code .
 */
/**
 In the next set of videos ,
 we are going to look at
 a topic we really haven't bothered to talk about so far at all ,
 but it is quite important programming ,
 and that is `memory management` .
 When you write code
 and create an instance of an object
 every single instance takes up space in memory
 by that I mean
 actual physical space on your device's RAM .
 Memory is a precious commodity in a mobile device
 and if you end up writing code that consumes too much memory
 the system , that is iOS , will automatically kill your apps process .
 For the most part , for simple apps like we have written
 and will be writing in the near future ,
 the memory footprint is barely anything
 and we haven't even considered the cost of our code .
 However , it is good to understand
 how the system manages memory ,
 both from a historical perspective
 and a look at how it is handled today .
 Even with the system managing much of the memory for you today ,
 there are still some considerations you need to make
 and information you have to provide
 depending on the code you write .
 But don't worry , we'll get to that in just a bit .
 Prior to iOS 5 in 2011 ,
 all memory management was done manually
 using a `Manual-Retain-Release` or `MRR model` .
 Under the MRR model ,
 the programmer was responsible for memory management
 and did so by keeping track of the objects you used .
 This was handled by carefully managing object ownership relationships
 and making sure an object existed just as long as it needed to .
 But not any longer . In terms of the nitty gritty ,
 a `reference counting system`
 internally kept track of
 the number of owners an object had .
 For example ,
 when you created an instance of an object ,
 you allocated space in memory
 and increased its reference count .
 When you were done with the object
 you decrease the reference count .
 If an object had a reference count greater than zero ,
 the system kept it alive ,
 otherwise it de-allocated the object .
 It was both a cumbersome approach ,
 but one that allowed you to finely control
 how much memory your application used .
 This allowed Apps to work well
 on the early iPhone models that had low memory .
 You could carefully ensure that your memory footprint was quite small .
 If you _claimed ownership_ of an object more times than you released it ,
 you'd end up with a `memory leak` that can crash your app .
 On the other hand ,
 if you _release the object_ too many times
 you end up with what was called
 a `dangling pointer` ,
 where accessing the object
 caused a crash
 because they didn't exist .
 If all this sounds like a pain ,
 many people thought so as well ,
 which is why , in iOS 5 ,
 Apple introduced a new model for memory management
 called `Automatic Reference Counting` , or `ARC` .
 Let's head over to the next video to talk about it .
 */
