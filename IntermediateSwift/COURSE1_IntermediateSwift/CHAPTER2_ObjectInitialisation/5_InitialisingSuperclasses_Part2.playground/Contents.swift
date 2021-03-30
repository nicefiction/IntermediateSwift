import Foundation


/**
 `5 Initialising Superclasses` : PART 2 OF 2
 
 There were a lot of specific rules involved here ,
 so let's summarise them :
 
 `Rule number 1` ,
 ( 1 ) every class must have a `designated initialiser` .
 If this class inherits from another ,
 the `designated initialiser` is ( 2 ) responsible for
 calling the `designated initialiser `of its immediate `superclass` .
 
 `Rule number 2` ,
 classes can have ( 1 ) any number of `convenience initialisers` .
 A `convenience initialiser` must
 ( 2 ) call another initialiser from the same class ,
 whether it is a `designated initialiser `,
 or another `convenience initialiser` .
 
 `Rule number 3` ,
 `convenience initialisers` must eventually call a `designated initialiser` .
 Let's look at a quick example ,
 here we have a class with a single `designated initialiser` :
 `See image page 66 .`
 
 Next ,
 we create a subclass :
 `See image page 66 .`
 This subclass
 also contains a `designated initialiser`
 whose responsibility it is
 to call the `designated initialiser` of its `parent` .
 While it is typical to have mostly one `designated initialiser` ,
 you can have more than one ,
 so let's add another to our subclass :
 `See image page 67 .`
 
 Since this is
 a `designated initialiser` ,
 it also calls the initialiser of its `parent` .
 Let's add a new `convenience init()` method to the `superclass` now :
 `See image page 67 .`
 
 Remember
 that a `convenience initialiser` must ultimately call
 the classes `designated initialiser` .
 We can add another `convenience initialiser`
 which also calls the first `convenience initialiser` :
 `See image page 67 .`
  
 Since the first `convenience initialiser` ultimately calls a `designated initialiser` ,
 the second `convenience initialiser` ultimately does as well .
 And we can add a `convenience initialiser` to the subclass that calls
 either one of its `designated initialisers` :
 `See image page 68 .`
 
 By looking at this visual , a pattern should emerge .
 `Designated initialisers` always delegate instantiation _up the chain_ .
 `Convenience initialisers` always delegate _across the chain_ .
 
 Here is a quick look at a more complex example
 where we see a more complex inheritance chain :
 `See image page 68 .`
 Again ,
 we see that `designated init's` go _up the chain_
 and `convenience init's` go _across the chain_ .
 This might seem complicated , but in practice , you quickly internalise things ,
 if you follow our three simple rules :
 
 `RULE #1` :
 `•` Every class must have a `designated initialiser` .
 `•` Responsible for calling `superclass' designated initialiser `.
 `RULE #2` :
 `•` Any number of `convenience initialiser` .
 `• `Can call other initialisers in the same class .
 `RULE #3` :
 `•` `Convenience initialisers` must call a `designated initialiser` eventually .
 
 After working with these for a little while ,
 it will become second nature ,
 and even if it doesn’t ,
 the compiler will warn you .
 */
