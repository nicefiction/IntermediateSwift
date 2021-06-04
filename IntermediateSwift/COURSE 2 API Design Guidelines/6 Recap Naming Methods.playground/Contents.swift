import Foundation


/**
 `6 Recap: Naming Methods`
 INTRO — Phew , we have covered quite a few different rules .
 In this video , let's take a small break from the new stuff
 to recap what we have learned so far .
 */
/**
 When naming methods ,
 we want them to read like grammatical English phrases .
 These methods' `base names` ,
 along with the `first argument label` ,
 can form one of three things :
 
 (`1`) a prepositional phrase ,
 (`2`) a grammatical phrase ,
 or (`3`) neither .
 
 (`1`) `Prepositional`
 With a `prepositional phrase` ,
 the `argument label` , or just the `first argument` ,
 should begin at the `preposition` .
 Creating a method that looks like this :
 
 `func move(toPosition position: Int) { }`
 
 An exception arises
 when more than the `first argument`
 represents part of the abstraction that governs the function .
 Here ,
 
 `view.fade(toRed : a , green : b , blue : c)`
 we have a function that fades a view’s background colour to a new colour .
 The background colour is determined by passing in RGB values .
 Since red , green , and blue are all part of the same abstraction
 split across different arguments ,
 having the `prepositional label` prepended
 to the first argument label , doesn't read well .
 So in this case ,
 we move the `preposition` to the `base name` ,
 and begin the `argument label`
 after the` preposition` to keep the abstraction clear .
 Our function therefore , reads like this :
 
 `view.fadeTo(red : a , green : b , blue : c)`
 
 
 (`2`) `Grammatical`
 Next up ,
 a method name along with the first argument can form a grammatical phrase .
 It is important to note here that we are only considering the `first argument`
 when deciding if the phase is grammatical .
 We'll get into that in just a second .
 With a `grammatical phrase` ,
 we omit the `first argument label` entirely
 and append any preceding words to the `base name` :
 
 `view.addSubview(y)`
 
 
 (`3`) `Neither Grammatical , nor Prepositional`
 Finally ,
 if the methods `base name` and `first argument label`
 do not form a `prepositional phrase`
 and can't be written in such a way that it is grammatically correct ,
 then we include a `default argument label` ,
 something like this :
 
 `func dismiss(animated: Bool)`
  
 `NOTE` that I have been focusing on the `first argument label` this entire time .
 And that is because regardless of what type of phrase it forms .
 We always label any arguments after the first one . Also ,
 we are only ever considering the `first argument`
 to determine whether we have a grammatical phrase
 because it is okay for fluency to degrade after the first argument or two
 when those arguments are not central to the cause meaning .
 There are some considerations we have to make along with these , however ,
 because remember , we have three main guidelines we established :
 
 (`A`) Omit needless words ,
 (`B`) include words to remove ambiguity ,
 and (`C`) compensate for weak type information .
 
 Take the example of the `addSubview()` method .
 The function signature looks like this :
 
 `func addSubview(_ view: UIView)`
  
 The method forms a `grammatical phrase` with the `first argument label` .
 So we have omitted the label and appended the label to the `base name` .
 Let's look at another example from the iOS SDK .
 Here ,
 
 `func activate(_ constraints: [NSLayoutConstraint])`
 
 we have a method, a type method on the NS layout constraint class that activates an array of constraints .
 The method reads _activate constraints_ , which is a `grammatical phrase` . However ,
 you'll notice here that while the `argument label` has been omitted
 much like we did with `addSubview()` ,
 the word `constraints` is not added to the method’s base name .
 Why ?
 This is because of the guideline to _omit needless words_ .
 The argument has a type of an array of NSLayoutConstraint ,
 which is a very specific type .
 We don't typically subclass constraints to make our own .
 So it is evident from our own signature
 that we are adding an array of constraints .
 We don't need to label constraints here ,
 because it is redundant ,
 and we can rely on the type information .
 
 
 (`4`) `No Arguments`
 There is one final edge case left . After this , I'll stop , I promise .
 What happens if we have a function where the arguments can't be usefully distinguished ?
 Here , ...
 
 `func max(_ x: Int , _ y: Int) -> Int`
 
 ... we have a function max that returns the maximum of two values that we provide as arguments .
 There is really no meaningful way to label these arguments in a `max()` function
 beyond value one and value two .
 In such cases , we just omit all labels altogether .
 It sounds like this goes against everything we have stated so far ,
 but in practice , if you choose your function `base name` well
 it is quite obvious what is going on .
 Now , I'll stress here that you don't have to adhere to all these rules on day one .
 In fact , take it one at a time until these come to you naturally .
 */
