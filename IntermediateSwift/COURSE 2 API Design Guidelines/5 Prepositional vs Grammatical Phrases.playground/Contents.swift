import Foundation


/**
 `5 Prepositional vs Grammatical Phrases`
 INTRO — The rules get a bit complicated here .
 We need to make a distinction between
 `prepositional` and `grammatical phrases`
 when writing fluent Swift method names .
 In this video
 we look at
 how the rules start to get more nuanced
 to make these distinctions .
 */
/**
 I have gone on about
 writing methods and functions
 to read as grammatical English phrases .
 And if you thought that was hard enough to decipher
 — perhaps if you are not a native speaker —
 then I am about to add an exception to that rule that you might not like .
 Hopefully , this distinction should clear up some confusion though .
 It did for me after a while at least .
 Let's take a break from Swift for a quick second
 to talk about the English language :
 In English ,
 a `preposition` is a word that describes
 a relationship between a noun or pronoun
 and another word in the sentence .
 This is an oversimplification of course ,
 but should get the idea across. For example ,
 in the sentence ,
 
 _the laptop on the desk_
 
 `on` is the `preposition` .
 It describes the relationship between the noun _laptop_ and the _desk_ .
 In this case , it describes _where_ the laptop is . Generally ,
 prepositions come after the noun or pronoun
 and describes temporal or spatial relationships ,
 or — in simpler English —
 they tell us when something happened ,
 or where something is .
 Let's take a look at a few more examples.
 So in this case ,
 
 _Susan arrived after the movie started ._
  
 `after` is the `preposition`
 because it describes the relationship between Susan's arrival and the movie .
 In this sentence ,
 
 _Nick went to the library ._
 
 `to` is the ``preposition`
 describing _where_ Nick went .
    Why does this matter ?
 Well , when writing out a method
 when the `first argument` forms
 part of a `prepositional phrase`
 with the `base name` ,
 then we give the argument a `label` . In contrast ,
 if it is not a `prepositional phrase`
 but only a `grammatical phrase` ,
 then we don’t . We'll get to that in a second .
    Let's look at an example .
 Suppose we were to define a `move()` function on a board game ,
 like a chess board that had a coordinate system :
 
 `func move(position: Int) { ... }`
 
 Assume this is an instance method that is called on a particular piece .
 So it says _move position_ here . But again ,
 this isn't how we would say it in English .
 We would say _move to position_ .
 _Move to position_ is a `prepositional phrase`
 and here , `to` is the `preposition` .
 Earlier , I kept saying that our goal was to write grammatical English phrases .
 This is still true . But we have to take it a small step further and distinguish between
 a `prepositional phrase` and a `grammatical phrase` .
 Here we have what is a `prepositional phrase` .
 👇
 So the rule is ,
 that we give it an `argument label` that begins at the `preposition` :
 
 `func move(toPosition position: Int) { ... }`
 
 So our function would have an `external argument name` that reads `toPosition` .
 Because the type here is `Int` , and it doesn't provide sufficient context ,
 we include the word `position` as part of the `external argument name` .
 So `move` is the `base name` ,
 `toPosition` is the `external argument label` .
 
 `NOTE` :
 If we had a type `Position` that did provide more context ,
 then we could simply say `moveTo` :
 
 `func moveTo(_ position: Position) { ... }` [ OLIVIER ]
 
 Because we want to omit that needless word `position`
 and allow the type to provide some context .
 Another example would be something like
 
 `x.removeBoxes(havingLength : 12)`
 
 `having` is the `preposition` .
 So the `external argument label` here
 begins at the `preposition` .
 There is an exception to this rule however .
 In both examples , we looked at
 only one argument
 form
 the abstraction governing the function .
 For example ,
 the `move()` function just takes a `single value` .
 `removeBoxes()` also takes a `single value` .
 Sometimes however ,
 more than the first argument can represent parts of a single abstraction .
 Let's modify our `move()` function
 
 `func move(toPosition position: Int) { ... }`
 
 iso that instead of taking a single integer value that corresponds to a `position` on our board ,
 it takes a standard x and y coordinate like a 2D map :
 
 `func move(toX x: Int , y: Int) { ... }`
 
 So here we have a function
 where we still have a `prepositional phrase` .
 So we try to do what we know , right ?
 We begin the `argument label` at the `prepositional phrase` ,
 so it says _move to X Y_ .
 Over here though ,
 both arguments are part of the abstraction
 that forms the `prepositional phrase` .
 We are moving to a spot that is determined by both x and y , not just x .
 So in this case ,
 we move the `preposition`
 out of the `argument label`
 and into the `base name` :
 
 `func moveTo(x: Int , y: Int) { ... }`
 
 So the function's `base name` is now `moveTo`
 and the `argument labels` are simply `x` and `y` .
 In these cases , we start the `argument labels` after the `preposition` .
 What about when there is no preposition ?
 Well in that case , we have a plain old grammatical phrase .
 And here is where we omit the `external label` entirely
 and append any preceding words to the `base name` ,
 just like we talked about when compensating for `weak type` information .
 For example ,
 here is a method from the `UIView class` in the iOS SDK
 that adds a subview to the main view :
 
 `view.addSubview(someOtherView)`
  
 Notice that because `addSubview` forms a `grammatical phrase` and not a `prepositional` one ,
 the `external label` _Subview_ has been added to the `base view`
 and omitted from the `argument label` .
 The implication with this rule , is ,
 that if the `first argument` forms
 neither a `prepositional phrase`
 nor a `grammatical one` ,
 then it should include the `argument label` .
 If we were to write a method on `UIView` to dismiss the view
 and at the use site ,
 we decide whether this dismissal from screen is animated ,
 we define the method like this :
 
 `func dismiss(animated: Bool)`
  
 `dismiss animated` isn't a `grammatical phrase` ,
 nor can we make it a `prepositional one` .
 Really , in English saying this properly , would mean ,
 asking a question like
 _should we animate this while dismissing_ .
 There is no way we can write either a `grammatical phrase` or a `prepositional` one
 that makes sense as a method name .
 Since it doesn't fit into those categories ,
 we include the `argument label` .
 Note that it is important that the phrase
 — the way we write out our method —
 conveys the correct meaning .
 Now dismissing on its own is grammatically correct .
 We can omit the `animated label`
 and you think hey , this reads well :
 
 `dismiss(false)`
 
 But without the `argument label` , the context is unclear .
 Here , are we saying don't dismiss , are we dismissing a Boolean value , who knows ?
 That applies to only the `first argument` of course , all of this .
 Remember that we always label all other arguments other than the first one
 regardless of any of these cases .
 This video was confusing.
 So let's take a short break
 and then recap in the next video
 to try and make some sense of everything we know about naming methods so far .
 */
