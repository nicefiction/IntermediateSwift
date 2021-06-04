import Foundation


/**
 `7 Side-Effects and Mutation`
 INTRO — One of the last " big " rules , is ,
 how to define pairs of methods
 where we have both
 a mutating
 and non mutating counterpart .
 */
/**
 We have made our way through several seemingly , confusing guidelines
 but we still have a few more points to talk about .
 Don't worry , these rules should help you stay consistent
 with how you think of method names . First up ,
 we want to name methods and functions according to their side effects .
 
 `1 Methods with Side Effects`
 The basic rule here , is ,
 that methods with side effects should read as `verb phrases` .
 Now a method with a side effect , is ,
 (`A`) one that mutates the current state
 (`B`) rather than a method that takes an input ,
 performs an operation ,
 and then outputs a value
 without affecting the current state .
 For example ,
 adding an element to an `Array` is a method with a side effect
 because it affects the state of the Array ,
 it mutates it .
 The` base name` of this method would use a verb phrase
 which is what we see in the Standard Library with the name `append()` :
 
 `func append(_ newElement: Element)`
 
 
 `2 Methods without Side Effects`
 On the other hand , if the method does not have any side effects
 — that is
 it takes an input ,
 performs a non-mutating operation ,
 and outputs a value —
 then the method's name
 — the `base name` —
 should read as a `noun` .
 If we wanted to calculate the distance between two points as we have done before ,
 the method name would read _distance_ as a noun :
 
 `func distance(to point: Point)`
 
 This method , `distance()` ,
 accepts an argument
 and we are going back to the rules we just learned ,
 in determining how to write those out .
 
 `NOTE` : I’ll point out one other thing in our method name here
 because it combines two of the rules we learned earlier as well .
 _distance to_ forms a `prepositional phrase` .
 So going by the rules we have established ,
 the `argument label` for that `first argument` should read , `toPoint` .
 The `argument type` however , indicates ,
 that we are clearly accepting a `Point instance` ,
 and ( the external ) label _point_
 would just be redundant . So ,
 we omit that needless word to end up with _distance to_ .
 
 
 `3 Naming Method Pairs • Verbs`
 
 `3.1 Mutating version`
 Sometimes, a method has both
 a `mutating variant`
 — that is one that performs a side effect —
 and a `non-mutating` one :
 In such cases ,
 we want to keep the naming consistent between the two .
 How we do so , depends on the operation we are trying to define .
 If the operation is naturally described as a verb — like _filter_ —
 then we use the `imperative form` of the verb for the `mutating method` :
 
 `anArray.filter(isEven)`
 
 Here the imperative form is _filter_ . So the mutating version of the method
 — the one that performs side effects — would be named _filter_ .
 
 `3.2 Non-Mutating version`
 The _filter_ method called on an Array would filter the array in place
 without creating a copy
 and it changes the original Array .
 
 MUTATING VERSION :
 
 `anArray.filter(isEven)`
 
 NON-MUTATING VERSION :
 
 `let filteredArray = anArray.filtered(isEven)`
 
 For such cases
 — again ,
 where the operation is best described as a verb for the non-mutating version —
 we take the `imperative form` and add `-ed` or `-ing` as the suffix
 to get our `non-mutating version` .
 
 `NOTE` : Now I realise , I just said seconds ago ,
 that `non-mutating methods` would use `nouns` . This again
 that I am talking about , is only for cases where we have `pairs of methods` ,
 where we have both a `mutating` and a `non-mutating` version .
 Since `filter` is our` imperative form` of the verb
 that we used to name the `mutating version` ,
 `filtered` becomes the `base name` for the `non-mutating form` .
 So , calling `filtered` on `anArray`
 
 `let filteredArray = anArray.filtered(isEven)`
 
 leaves the current array unchanged
 and returns a new copy filtered with a given criteria .
    Another example of this , is ,
 if we were to define a `sort()` operation :
 
 MUTATING VERSION :
 
 `anArray.sort()`
 
 NON-MUTATING VERSION :
 
 `let sortedArray = anArray.sorted()`
 
 Again since this is best described by a verb , since `sort()` is a verb ,
 we use the imperative form `sort()`
 to define the `mutating` version of the function
 and `sorted()` for the `non-mutating` .
 Now , `-ed` suffixes are easy
 but sometimes they don't work . For example ,
 let's say we have a method that removes whitespace from a String :
 `strip` is the `imperative form` of the verb we are going to use .
 So , the mutating version would be something like , `stripWhitespace()` :
 
 `someString.stripWhitespace()`
 
 For the `non-mutating version` that returns a new String with whitespace stripped ,
 how do we name it ?
 Adding the `-ed` suffix to the verb would give us `strippedWhitespace()` ,
 but that doesn't sound right .
 So the convention here , is , to use the `-ing` suffix
 so we end up with `strippingWhitespace()` :
 
 `let s = someString.strippingWhitespace()`
 
 If you think that sounds weird , I'm with you .
 The technical reason for this , is ,
 when adding `-ed` is not grammatical
 — because the verb has a direct object —
 name the `non-mutating variant`
 using the verb's present participle by appending `-ing` . ( You shouldn't have asked 🙂 )
 Okay , we are not done though .
 Now that was for when an operation was best described by a verb .
 What happens when the operation is best described by a noun ?
 Thankfully , this case is much simpler .
 
 
 `3 Naming Method Pairs • Nouns`
 We use the noun `form` for the `non-mutating method`
 and then use the `form` prefix for the `mutating counterpart` . So again ,
 we are still going with `nouns` for the `non-mutating` versions
 and then , using `form` to notify to the reader that this is now a `mutating counterpart` .
 A simple example of that is a method that , say ,
 forms a union between two Arrays of numbers .
 We would name the `non-mutating` version of this union
 — using a noun —
 
 `let union = anArray.union(with : anotherArray)`
 
 and then , we would add `form` to the beginning of it
 to say `formUnion` for the `mutating version` :
 
 `anArray.formUnion(with : anotherArray)`
 
 
 Let's recap .
 As a basis for considering method names ,
 we want to think about how the method works :
 (`A`) If a method performs side effects , then ,
 the method should use a verb for the `base name` .
 A simple example is the `append()` method that mutates an `Array` .
 (`B`) If the method does not perform side effects ,
 consider using a `noun` for the `base name` , like `distance()` .
 These two rules should suffice with most of the methods that you will write .
 
 The exception arises
 when you want to define pairs of methods that have both ,
 A `mutating` and `non-mutating` counterpart .
 The basis for which part of speech that is
 — whether we use a verb or a noun —
 is determined by
 how the method is best described .
 If the method is best described using a verb
 — like , `sort()` —
 then we use that `verb` , the `imperative form` for the `mutating method` . Remember ,
 we are still going with verbs for `mutating` . In this example ,
 `sort()` is the version of the method that mutates the underlying array .
 For the `non-mutating` counterpart ,
 we use the `-ed` or `-ing` suffix .
 On the other hand ,
 if the operation is best described by a `noun`
 — like , `union` —
 then ,
 we use the `noun` form for the `non-mutating version` .
 For the `mutating version` ,
 we add the `form prefix` to the name we used .
 For the `non-mutating` version
 — and in this case , that is `formUnion` :
 
 MUTATING VERSION :
 
 `anArray.formUnion(with : anotherArray)`
 
 NON-MUTATING VERSION :
 
 `let union = anArray.union(with : anotherArray)`
 
 
 
 All right , let's take a break here .
 In the next video ,
 let's cover some of the remaining conventions .
 */
