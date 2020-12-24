import Foundation


/**
 `CHAPTER 2`
 `Object Initialisation`
 Initialising an object in Swift ,
 whether a value or reference type ,
 can be both quite strict and flexible at the same time .
 In this stage we take a peek under the hood at
 how initialisation works in Swift
 and the different ways we can create an instance .
 */
/**
 `1 Initialisation Recap`
 INTRO — Before we learn anything new about initialisation ,
 let's recap what we know so far .
 */
/**
 Over the course of several different videos ,
 we learned about initialisation .
 And while we touched on the basics of it ,
 we didn't learn every single nuance .
 This allowed us to keep it simple
 and use value and reference types in our code
 without getting too complicated .
 Now the time has come to augment that knowledge .
 Before we do that though ,
 let’s quickly recap what we know about initialisation :
 Initialisation , as we know , is
 ( 1 ) the process of preparing an instance of
 a Class , Structure , or Enumeration
 for use by
 ( 2 ) setting up initial values to all stored properties
 and performing any other set up .
 
 Initialisation is carried out in a special method ,
 an init( ) method :
 `unit() {}`
 which like a regular method
 can take parameters to assign values to our stored properties .
 These parameters follow all the standard rules as regular function parameters
 which includes local and external parameter names .
 
 What else do we know ?
 
 ( 1 ) We know that we can assign default values to stored properties ,
 or mark them optional if they are  variables
 which allows us to defer setting any values inside an init( ) method .
 Aside from those two cases
 by the time we are done with initialisation
 all stored properties must have initial values .
 Finally ,
 ( 2 ) we also know that a Struct gets a default initialiser
 known as a member-wise initialiser
 and Enums with raw values
 also get a default initialiser
 that accepts a raw value .
 
 Okay , so far so good .
 In the next video we look at a minor variation on an init( ) method .
 We have encountered these before , but we never fully talked about them .
 */
