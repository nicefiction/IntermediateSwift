import Foundation


/**
 `4 Fluent Usage`
 INTRO — In addition to the rules we defined ,
 an important goal when writing Swift , is ,
 to use fluent English to make our code extremely readable .
 In this video ,
 we look at what fluent means
 and the pitfalls we need to avoid .
 */
/**
 The guidelines we just looked at
 form a sort of basis of
 how we should think about writing methods and functions in Swift 3 .
 But they are more high level guidelines than real details .
 In this video ,
 let's look at the nuances of what the Swift team calls
 the fluent usage of the language.
 (`1`) The first rule that really governs most of our naming decisions , is ,
 that methods and functions should read as grammatical English phrases at the use site .
 Earlier , we wrote a function `insert()` that looked like this :
 
 `insert("a" , position : 1)`
 
 If we read this all out ,
 including the arguments ,
 it reads _insert 'a' position 1_ .
 And you think , hey that sounds great ,
 it conveys what I am trying to say .
 But it really isn't grammatically correct English though .
 We wouldn't say _insert 'a' position 1_ in English .
 Instead ,
 we would say something like _insert 'a' at 1_
 where 1 is the position .
 Let's write that out :
 
 `func insert(_ element: Element , at: Int) insert("a" , at : 1)`
  
 At the use site ,
 this now reads as a grammatical English phrase .
 Now it says _insert 'a’ at 2_ .
 That is much better ,
 because our goal , again , is
 to read as a correct grammatical English phrase .
 But `at` over here ,
 is an odd argument name `locally` ,
 that is
 inside the body of the function .
 `at` doesn't make much sense .
 Let's give it a better `local name` .
 In the Swift Standard Library
 this method on an array
 uses the `local name` , `i` ,
 to represent the index for the second argument . That is fine ,
 but I think we can be a bit more descriptive .
 The code we write will typically have less i 's on it ,
 and less documentation than a ( Swift ) language Standard Library ,
 so every bit of descriptiveness to aid readers , helps .
 We'll call our `local name` _index_ :
 
 `func insert(_ element: Element , at index: Int)`
 
 Now the method reads well
 — as per the guidelines —
 and is grammatically correct
 both
 at the point of definition ,
 
 `func insert(_ element: Element , at index: Int)`
 
 and at the call site ,
 
 `insert("a" , at : 2)`
 
 This satisfies the guidelines we established earlier as well .
 There are no needless words , no ambiguity ,
 and we are relying on Swift's type system
 to provide more information when needed .
    Let's look at another example .
 We want to define a function that we could hypothetically call on a String literal .
 The function finds a character within a particular range on a given String
 and returns an index value .
 We'll define the function's base name as `find()` .
 
 `func find(character: String , range: Range<String.Index>) -> Int`
 
 This function takes , as an argument ,
 a character which we'll define as a String .
 We’ll give this argument a label of `character` .
 We also need a `range` within which we are going to check .
 We'll give the second argument a label of `range` of type `Range`
 that is generic over `String.index` .
 
 `NOTE` : If you don't know what generics are just yet , that's okay . That is not relevant to this part .
  
 So this is what our function looks like so far ,
 and it looks decent :
 
 `func find(character: String , range: Range<String.Index>) -> Int { }`
 
 But remember ,
 we always need to make sure it is grammatically correct
 and reads well at the use site .
 Here you can see how the function is used at the use site :
 
 `let character = "a"`
 
 `let range = character.startIndex..<character.endIndex`
 
 `find(character : character , range : range)`
 
 This function makes sense,
 but it doesn't read well .
 It says _find character range_ .
 So how do we actually say this ,
 if we tried to make this grammatically correct ?
 We could say _find character in range_ .
 So let's make that change :
 
 `func find(character: String , in range: Range<String.Index>) -> Int { }`
   
 By adding an external name of in to this second argument ,
 we can make it read better at the use site .
 So now it says _find character in range_ .
 
 `find(character : character , in : range)`
 
 What about that first argument , though ?
 What about the character label ?
 When we wrote the `insert()` function
 when we first started , we said ,
 it was fine to get rid of the `external argument label`
 because it fits the guideline amid needless words .
 In addition ,
 the type information provided by the function's signature
 helped avoid any ambiguity as to what the function actually did .
 So why don't those same considerations apply over here ?
 In this case ,
 
 `func find(character: String , in range: Range<String.Index>) -> Int { }`
 
 we have set the type of the character argument to `String` :
 Again ,
 `String` is a fundamental type
 that is used to represent different kinds of data .
 If I were to omit the _character_ `argument label` here
 
 `func find(character: String , in range: Range<String.Index>) -> Int { }`
 
 and rely just on `String` to convey that information ,
 
 `find(character , in : range)`
 
 it is not clear that I mean that I am looking for a single character to find .
 There is nothing preventing me from passing in a full word as an argument .
 In that case , again , it is unclear what the function is expecting and how it would behave .
 Therefore , it is ambiguous .
 
 👉 Remember ...
 
 ... guideline number three from the previous video
 talked about `weak type information` . With that in mind
 the way to proceed would be to omit the `external label`
 and precede the argument — the first argument — with a noun describing its role .
 Now since this is the first argument in the method , we would add that noun
 back into the `base name` . So our method would read like this :
 
 `func findCharacter(_ character: String , in range: Range<String.Index>) -> Int { }`
 
 So now it still reads _findCharacter in range_
 but now `findCharacter` is the `base name` .
 In this specific case , however ,
 we are not going to go down that route
 because we do have a more specific type that we can use
 that fits the function's role appropriately .
 Rather than accept an argument of type `String` ,
 we can accept an argument of type `Character` :
 
 `func find(character: Character , in range: Range<String.Index>) -> Int { }`
 
 Because `Character` is a more specific type ,
 now it is evident that the function only accepts a character .
 And so the `external argument name` is redundant and is a needless word .
 So now that we have `Character` as a type ,
 we can omit the `argument label`
 and rely on the `type information`
 to provide all the context that we need :
 
 `find(character , in : range)`
 
 So now it is _find character in range_ without an `argument label` ,
 so at the use site ,
 we still get the same level of information as we did earlier .
 There is actually one more change we can make to this function ,
 but before we go down that path ,
 let’s talk about argument labels in the next video .
 */
