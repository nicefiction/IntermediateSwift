import Foundation


/**
 `2 Defining Access Levels`
 INTRO — Now that we know
 the different `access levels` available
 let's see
 how we can define them in our code .
 */
/**
 An important thing to know about `access controls` is ,
 that you cannot define an entity
 in terms of another entity
 that has a lower or more restrictive access level .
 _What does this mean ?_
 It means
 that you cannot
 for example
 define a `public` stored property
 whose type is `internal` , `fileprivate` , or `private` :
 */

private struct AccessLevel {
    
    public var value: Double
}

/**
 This is because
 if we try to use the property in a different `module`
 — which is what the `public` access level allows —
 the underlying type won't be available
 because it is either `internal` ,  `fileprivate` , or `private` .
 To define an `access level` ,
 we use one of the keywords :
 Either `open` ,
 `public` ,
 `internal` ,
 `fileprivate` ,
 or `private`
 before the entity :
 */

private struct Degree {}

fileprivate var someVariable = 1

public func someFunc() {}

/**
 For custom types
 we place the keyword
 in front of the declaration ,
 
 `private struct Degree {}`
 
 For variables , constants , and functions or methods ,
 they go at the beginning as well ,
 
 `fileprivate var someVariable = 1`
 `public func someFunc() {}`
 
 The `access control` level of a type
 
 `private struct Degree {}`
 
 defines
 what `access control` level
 its members
 — that is its properties , methods , initialisers , and subscripts —
 have .
 If you define a `class` as a `private class` or `fileprivate`
 then the default access level of its members is also `fileprivate` or `private` :
 */

private class SomeClass {
    
    /*
     All members of this class
     are private by default .
     */
}

/**
 A member
 cannot have
 a higher or less restrictive access level
 than the enclosing type . So ,
 inside a `private class` ,
 you cannot have a `public method` .
 But you can go the other way around :
 */

public class AnotherClass {
    
    internal var anotherProperty: Int = 1
    
    fileprivate func anotherMethod() {}
    
    private func someMethod() {}
}

/**
 Inside a `public class` ,
 you can have a `fileprivate` method ,
 a `private` method ,
 or an `internal` property .
 Basically you can have a more restrictive
 — or lower access level —
 inside a type .
    The only other bit that is important to know , is ,
 when it comes to subclassing .
 You can subclass any class
 that can be accessed
 within its current context .
 So , if you have a `fileprivate` class for example ,
 it can be subclassed within that source file , ...
 
 `MODULE 1 :`
    `SOURCE FILE 1 : fileprivate class A`
    `SOURCE FILE 1 : class B: A`
 
 ... but not outside of it ...
 
 `MODULE 1 :`
    `SOURCE FILE 1 : fileprivate class A`
    `SOURCE FILE 2 : class B: A`❌
 
 ... because the base class
 
 `fileprivate class A`
 
 is `private` to that file .
 A `subclass`
 cannot have a higher access level
 than its `superclass` . So ,
 you cannot have a `public subclass` of a `private superclass` .
 You can also `override` any class member again :
 a property ,
 method ,
 initializer ,
 or subscript
 in the subclass ,
 as long as it is visible in the access context .
 An `override` can make an inherited class member
 more accessible than its superclass version .
 So , in the code you see here :
 */

public class A {
    
    fileprivate func someMethod() {}
}

/**
 Our `base class` is
 a `public class`
 with a `fileprivate method` , named `someMethod()` .
 */

internal class B: A {
    
    override internal func someMethod() {}
}

/**
 The `subclass` is an `internal class`,
 so it has a lower `access level` .
 But the overridden implementation of `someMethod()` is now marked `internal` ,
 which is a higher `access level` than `fileprivate` .
 
 `NOTE` :
 Now all this is complicated . That is okay ,
 we are not going to touch on this as much though
 because honestly
 we won't really be writing any such specific access control for a while .
 It is just something you should be aware of
 because as you inspect header files of the `iOS SDK`
 — the `Swift standard library` —
 and other people's code ,
 you will come across all sorts of access control keywords .
 And it is important to know
 how they affect your ability
 to interact with that code.
 Code that we use from the sources I just mentioned ,
 is code from a different `module` . Remember ,
 we `import Foundation` and `UIKit`
 in other different `modules`
 to use it .
 This means
 we need to understand
 that `open` and `public` code is accessible to us
 while `internal` , `private` , and `fileprivate` , are not .
    Another important distinction that I probably should mention
 — even though we won't use it at all — is , that
 while `open` and `public`
 are the same `access level`
 within a `module` .
 Across `modules` ,
 you can only subclass classes that are marked as `open` .
 You can use a `public class` , but you cannot subclass it .
 A `final class` , which we have learned about before , is ,
 how you prevent subclassing from within a module .
 
 
 Okay , that is enough learning .
 I think it is safe to say
 that we have covered a lot of content in this course .
 In general , we took our Swift fundamentals
 — like initialization , properties , and protocols —
 and found out just how flexible and powerful they really are .
 We pulled back the covers on `memory management`
 and explained why being `weak` can actually be a good thing .
 You have just made a big leap
 in terms of your understanding of Swift ,
 both in terms of features and underlying concepts .
 Congratulations , this is big stuff.
 You should feel proud for meeting the challenge .
 See you soon in the next course .
 */
