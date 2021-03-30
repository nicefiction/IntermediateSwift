import Foundation


/**
 `COURSE 2`
 `API Design Guidelines in Swift`
 What does writing good Swift code mean ?
 Since the release of Swift ,
 there hasn't been consensus ,
 from Apple or the community ,
 on how types and methods should be named .
 In this course
 we go over the new set of guidelines
 established with Swift 3
 and how we can make the changes in our code .

 What you'll learn :
 `•` Naming types
 `•` Naming methods
 */



/**
 `CHAPTER 1`
 `Writing Great Swift`
 With the open sourcing of Swift in 2015 ,
 the Swift team released a document detailing guidelines
 for designing API and writing code .
 Over the next few videos ,
 we are going to examine
 some of the major sections of this document
 to understand how we should name our types and methods .
 */



/**
 `1 Why Do We Need Guidelines ?`
 INTRO — In this video we talk about the why of all this .
 Why does everyone need to write Swift the same way to begin with ?
 Over the next two videos
 we are going to learn
 how to write `idiomatic Swift` ,
 that is Swift that reads well , promotes clarity ,
 and is consistent with how the Swift community structures its code .
 Before we start however ,
 I should say that this course might seem overwhelming .
 And full of rules that seem way too strict .
 Don't worry about internalising any of this ,
 right off the bat or memorising the rules .
 These videos are mostly meant to give you a good sense of the scope of changes ,
 rather than to force you to change your style immediately .
 Particularly for those of you that are new ,
 a set of videos on naming things might seem a bit much .
 Don't worry . You'll get used to all of these rules as you write more code .
 Until eventually this is all second nature .
 There are two big goals driving the choices that we'll talk about throughout these videos
 that are important to keep in mind :
 
 (`1` ) First , the most important goal when writing Swift is ,
 `clarity at the point of use` .
 */

/* Point of use :
 * Readibility at call site
 * is more important than
 * point of definition .
 */

/**
 What is _at point of use_ mean ?
 It means that
 when we write methods or functions ,
 how they read
 when we call those methods ,
 is far more important
 than when we define them .
 Methods and properties are written once ,
 but called and used many times .
 So the focus should be on the latter .
 Keep this in mind .

 (`2`) Second ,
 `clarity` is more important than brevity .
 */

/* Clarity over brevity :
 * It is a non goal
 * to enable
 * the smallest possible code .
 */

/**
 Swift was introduced as a successor more or less to Objective C .
 With Objective C , we had been writing
 verbose
 or long method names , variables , and properties .
 They were extremely clear about their intent , often redundantly .
 So with the arrival of Swift , the pendulum swung in the opposite direction ,
 and people started writing the least amount of code they possibly could .
 Often taking inspiration from sources like Python , with its list comprehension .
 Well that works well in other languages ,
 that is not what we want in Swift .
 In Swift ,
 we want to understand the code well
 even if that means writing more .
 Again , `clarity` is more important than brevity .
 To quote the guidelines ,
 _it is a non goal to enable the smallest possible code ._
 _Instead when Brevity occurs ,_
 _it is as a side effect of using some of Swift's great features ._
 
 So , keep these goals in mind
 they are pretty important .
 For the rest of these videos
 we are going to break it up into two main sections .
 (`A`) Naming types , properties , and variables as our first section .
 (`B`) Naming methods as our second section .
 Let's start with naming types.
 */
