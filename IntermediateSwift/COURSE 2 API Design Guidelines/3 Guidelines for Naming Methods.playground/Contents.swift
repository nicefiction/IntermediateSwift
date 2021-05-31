import Foundation


/**
 `3 Guidelines for Naming Methods`
 INTRO — There are far more rules for naming methods
 than types
 so
 let's start simple
 by establishing
 a few high level guidelines .
 */
/**
 We are going to spend a bit more time
 talking about the guidelines for naming functions and methods
 than anything else .
 Just because this is useful for both beginners , new to the language ,
 and for those of us who have been writing Swift for a while .
 Let's start simple by breaking down component parts of a function
 to make sure we are on the same page . 
 Here we have a function from the Swift standard library
 that is part of the collection protocol :
 
 `func index(_ i : Self.Index ,`
            `offsetBy n : Self.IndexDistance)`
 `-> Self.Index { ... }`
 
 Let's get some standard labelling in place
 so you know what I am referring to .
 `index` — the function name — we call the `base name` .
 The `base name` is the name of the function that is outside of the argument list .
 Because you can _overload methods_ in Swift , that is ,
 you can have methods with the same `base name`
 but a different set of arguments .
 We consider function names to be the `base name` ,
 plus
 the `argument list` .
 So , when you read the `function name` ,
 it includes the `base name` plus the `argument list` .
 More often though ,
 it is just the `base name` and the `first argument`
 that comprise the `function name` .
 After the `base name`
 we have a list of parameters or arguments that the function accepts :
 
 `func index(_ i : Self.Index ,`
            `offsetBy n : Self.IndexDistance)`
 `-> Self.Index { ... }`
  
 An `argument` is given an `argument label`
 to help give it some context and meaning .
 An `argument label` has two forms ,
 (`A`) an `external name` ,
 and (`B`) a `local name` .
 especially because it needs to strike a careful balance with the next one .
 In the second argument in the aforementioned function ,
 
 `func index(_ i : Self.Index ,`
            `offsetBy n : Self.IndexDistance)`
 `-> Self.Index { ... }`
 
 `offsetBy` is the `external name`
 — the one that you see when you call the function —
 while `n` is the `local name`
 that we use inside of the body of the function
 to refer to the argument :
 
 `func index(_ i : Self.Index ,`
            `offsetBy n : Self.IndexDistance)`
 `-> Self.Index { ... }`
 
 You don't have to specify both the `local` and `external name` .
 When you specify just a single argument label for an argument ,
 Swift uses that single label
 as both the `external name` and the `local name` .
 You can also omit the `external name`
 by specifying an _underscore_ for the `external name` :
 
 `func index(_ i : Self.Index ,`
            `offsetBy n : Self.IndexDistance)`
 `-> Self.Index { ... }`
 
 As you can see in this function ,
 the first argument has the `external name` omitted .
 We'll talk about when and why this is done .
 You cannot of course omit the `local name` .
 Finally a function has a `return type` :
 
 `func index(_ i : Self.Index ,`
            `offsetBy n : Self.IndexDistance)`
 `-> Self.Index { ... }`
 
 With functions and methods ,
 a distinction needs to be made between
 where the function is defined and where it is used .
 The function should read well when we _use it_ ,
 not necessarily when we _define it_ .
 When we design our functions ,
 we should always check how they read and use sites .
 Let's say we wanted to define a function that inserted an element into an array
 at a particular position and we defined it like this :
 
 `func insert(element: Element , position: Int) { ... }`
  
 Now this looks fine but remember ,
 it is important that the method reads well
 at the use site . Calling the method
 and passing in some values
 gets us this :
 
 `func insert(element: Element , position: Int) { ... }`
 
 `insert(element : "a" , position : 1) // use site`
 
 Using this as a baseline ,
 let's work our way through the various high level guidelines
 established under Swift 3 :
 */


/**
 (`1`) So first up is rule number one ,
 `omit needless words` .
 In this example
 
 `insert(element : "a" , position : 1) { ... }`
 
 the `base name` of the method insert
 indicates that we are inserting something .
 The method reads _insert element position_ .
 Let's ignore that second argument label for now
 and focus on the _insert element_ bit .
 This method is one that is called on an `Array` ,
 and inserts an item at a particular `Array index` .
 Since _insert_ makes it obvious that we are inserting an element into the `Array` ,
 especially since we call it on an `Array` ,
 the `argument label` _element_ is redundant .
 All the information that we need is already provided by the word _insert_ .
 In fact since Arrays are typed ,
 if we call insert on an array of Strings ,
 we know that we are inserting a `String` ,
 we can't insert anything else .
 So again any inclusion of an `external name`
 — for the element being added — is needless .
 So to follow this guideline of getting rid of needless words ,
 let's get rid of the `external name` by using an _underscore_ :
 
 `func insert(_ element: Element , position: Int)`
 
 `insert("a" , position : 1) {...}`
 
 So now the method just reads _insert_ .
 This reads much better .
 And here ,
 it is a fairly obvious case of where we could omit a needless word .
 This guideline is tough though ,
 especially because it needs to strike a careful balance with the next one .
 */


/**
 (`2`) Rule number two states
 that we need to include all the words needed
 to avoid ambiguity .
 Let's define a counterpart for `insert()` ,`remove()` .
 It removes an element from an Array given an index .
 Hot off the heels of defining our first method we decide
 that we don't need an argument label here
 because it is probably redundant as well :
 
 `func remove(_ index: Int)`
 
 This looks similar to `insert()` .
 Remember , even though this reads okay here ,
 the priority is
 clarity at the _use site_ .
 At the use site
 `remove(1)`
 it isn't really clear what we are removing .
 Are we removing the _value_ `1` itself in this method call ?
 The problem is compounded
 when the arguments are assigned to constants or variables ,
 
 `func remove(_ index: Int)`
 `let unrelatedVariableName = 1`
 
 and passed through :
 
 `remove(unrelatedVariableName)`
 
 It is unclear here whether we are removing an element from the array itself ,
 or something else altogether .
 In this case — where it is sort of ambiguous — the argument label is crucial .
 Our method would read better
 when we specify removing the element at a given index :
 
 `func remove(at index: Int)`
 `remove(at : 1)`

 For each of these guidelines ,
 it really comes down to a case by case evaluation of the method or function .
 In both the cases we looked at however ,
 we had one aspect of Swift that helped us in someway , `type information` .
 In the case of the `insert()` method , let's say on an `Array of Strings` ,
 
 `func insert(_ element: Element , position: Int) { ... }`
 
 despite there being no argument label for the first argument.
 The fact that the type of argument is `String`
 indicates to us that we are inserting a String value into the existing Array .
 In the case of `remove()` , again ,
 with the array of Strings ,
 the type of argument is `Int` ,
 which can reinforce the fact that we are removing an element at an index .
 */


/**
 (`3`) There are cases though where type information can be lacking .
 This is common when we use higher types — or type aliases —
 like `AnyObject` , `Any` , or even Objective C's `NS object`
 in our function or method arguments . For example ,
 let's say we have a class called `Notification` .
 `Notification` has an instance method that allows us
 to add `AnyObject` as an observer of a notification .
 So we could define the method to read like this :
 
 `func add(_ observer: AnyObject)`
 
 Here , it seems okay , when you look at it , it is more or less clear
 that we are adding an observer to the current notification . And we think
 " hey , we want to emit needless words " , so we get rid of that external label .
 When we call it however ,
 
 `add(self)`
 
 it is not clear what we are adding , and again ,
 the type information here is so ambiguous and weak
 — is just `AnyObject` —
 that it doesn't provide any further context .
 Since we can pass in `AnyObject` as an `argument` ,
 we don't really know we are adding to the underlying notification .
 In this case ,
 we do want to use more words to compensate for the lack of clarity
 expressed by the weak type information of `AnyObject` .
 Now one easy way we could do that , is ,
 by adding the `argument label` back in , so that our methods read as such :
 
 `func add(observer: AnyObject)`
 
 Now the call site would read as follows ,
 
 `add(observer : self)`
 
 so it says _notification add observer_ .
 However , with the case of ambiguous type information
 we want the method’s `base name` to convey all the information .
 So instead ,
 we precede each weakly typed parameter
 with a noun describing its role .
 Let me repeat that ,
 with the case of `ambiguous type information` ,
 we precede each `weakly typed parameter`
 with a noun
 describing its role .
 So instead ,
 we would write the method like this .
 And remove the `external argument` name :
 
 `func addObserver(_ observer: AnyObject) addObserver(self)`
  
 Now this seems odd ,
 but I want you to hang onto this guideline for a second .
 We'll get into why exactly we choose to omit the `external name`
 and add the `argument` to the `base name` in just a bit .
    Let's look at another example to drive this point home .
 Imagine that the `Dictionary type` in Swift ,
 didn't exist in the Standard Library ,
 and then , we are in charge of defining it .
 The type includes a method to update the values for a given key ,
 so let's create one .
 We are going to make an assumption
 that our Dictionary always has a type of String to Any ,
 which isn't all that uncommon of a type .
 So here we have a function named update value
 
 `func update(value: Any , key: String)`
 
 `Any` provides no context whatsoever about the argument
 — that is , it has weak type information .
 `String` on the other hand ,
 is a fundamental type that we also consider
 to have weak type information
 since you can pass in really anything as a String .
 In this case
 — just like `addObserver()` — ,
 the rule is
 to precede the parameter
 with a noun
 describing its role .
 Now for the first argument value , that means ,
 moving that noun — value —
 to the `base name` — update .
 It means omitting the `external argument label` — value —
 and adding a noun describing the argument to the `base name`
 that would make the method read like this :
 
 `func updateValue(_ value: Any , key: String)`
 
 So now the `base name` is `updateValue()` .
 This means we can now rely directly on the `base method name`
 to convey what the method does .
 But by the second parameter ,
 it also has `weak type information` .
 We are going to follow the same rule here ,
 except we add the noun describing the role
 to the `external name` of the `argument` .
 So along with the goal of making this readable as grammatical English at the use site ,
 we end up with a method like this :
 
 `func updateValue(_ value: Any , forKey key: String)`
 */
/**
 This takes getting used to
 but there are further rules that we'll go over that should help make more sense .
 So before we move on ,
 let’s quickly recap our naming rules for methods :
 
 (`1`) We want to omit needless information .
 (`2`) We want to include all words needed to avoid ambiguity .
 (`3`) We want to compensate for weak type information because
 — tying in with point number two —
 weak type information introduces room for ambiguity .
 */
