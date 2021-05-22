import UIKit


/**
 `CHAPTER 6`
 `Access Control`
 Sometimes we need to restrict access to our code in certain ways
 and Swift comes with a set of access controls
 that allow us to do this .
 In these videos ,
 let's look at the different tools at our disposal .
 */
/**
 `1 Understanding Access Levels`
 INTRO — There are several ways we can restrict our code
 and in this video
 we look at
 what those levels are
 and why we would need these restrictions .
 */
/**
 So far all the code we have written
 is available everywhere in our projects .
 But when writing production code
 — or code that will work in the real world —
 we don't want the same level of access for every line of code that we write .
 We may want to restrict certain parts from being accessed and modified ,
 while other parts , we want to indicate that modification is okay .
 This concept is called `access control`
 and restricts access to parts of your code
 from code in other files or modules .
 Features like this enable us
 ( 1 ) to hide implementation details of our code ,
 and ( 2 ) to specify interfaces through which we can access and use objects .
 Before we look at the different access levels ,
 it is important to understand
 the distinction between
 a module
 and a source file :
 
 `.swift`
 `.swift`
 `.swift`
 `.swift`
 –––––––– +
 `Module`
 
 A `module` is a single unit of code distribution ,
 think an `app` or a `framework` . For our purposes ,
 an easy way to think of a `module` is ,
 if you are using an `import` statement —
 like `import UIKit` or `import Foundation` . In this case ,
 you are importing a `module` . In contrast ,
 a `source file` is
 a single swift file of source code
 contained within a `module` .
 In our apps and projects ,
 individual files ending in `.swift` were `source files` .
 So , a `source file` is contained within a `module` .
 The reason this distinction is important to understand , is ,
 because we define `access levels` in our `source files`
 so that a specific interface is used
 when the `module` containing our code is used .
 So ,
 _what are these different access levels ?_
 Swift provides five different `access levels`
 to restrict certain parts of our code .
 These `access levels` are relative to the `source file`
 in which they are written .
 We'll start from the most open
 and work our way down :
 
 `1`: `Open`
 `2`: `Public`
 `3`: `Internal`
 `4`: `Fileprivate`
 `5`: `Private`
 */
/**
 First up , we have (`1`) `Open access` and (`2`) `Public access `.
 These enable code
 written in a `source file`
 to be used anywhere within a `module`
 as well as from another `module` that imports it .
 So for example ,
 if we were to look at the generated interface
 or the header file for the `UIViewController` class ,
 */

/*
 open class UIViewController : UIResponder, NSCoding, UIAppearanceContainer, UITraitEnvironment, UIContentContainer, UIFocusEnvironment {
 
    ...
 
    open func viewDidLoad()
 
    ...
 }
 */

/**
 you can see that ( 1 ) , the `class` is marked as `open` ,
 which means that we can use it outside of this module .
 And you can see that `viewDidLoad()` , which is down here ,
 
 `open func viewDidLoad()`
 
 is also marked as an `open` method .
 This is what allows us to call this code
 when we `import UIkit` ,
 which is the `module` in question .
 And use the `UIViewController class` .
 Within a `module` ,
 `open` and `public`
 function in the same way ,
 but they differ
 when code is used between `modules` .
 `open` is the highest access level ,
 or the least restrictive access level .
 */
/**
 Next up is `internal access `.
 (`3`) `Internal access` enables entities to be used
 within any `source file` from their defining `module` ,
 but not in any `source file` outside of the `module` .
 `Internal access` is specified using the `internal` keyword .
 But `internal access` is the default level of access .
 So even though we haven't been writing any `access control` specifiers in our code ,
 our code has been at an `internal` level by default .
 */
/**
 (`4`) After `internal` we have `fileprivate` .
 This is an interesting one
 and allows you
 to restrict
 the use of an entity
 to within its defining `source file` .
 */
/**
 (`5`) Lastly , we have `private access`
 which is the most restrictive access level .
 `Private access` means
 the use of an entity is restricted
 to an enclosing declaration .
 So for example ,
 a `private` stored property
 can only be used
 within its `class` .
 */
/**
 For our purposes ,
 we won't be defining access levels ,
 which means it is going to be `internal` by default .
 The reason for this is
 that for simple , single target projects
 — which is what ours tend to be —
 the code is self-contained ,
 and doesn't need to be made available outside of that module
 and for our purposes and app
 can be considered our model .
 We may want to set specific methods and properties as `private`
 because we don't want them mutated outside of that declaration ,
 say outside a `class` or a `struct` .
 But those are simple use cases
 that are easy to understand .
    `Access level` only really matters in two cases :
 (`1`) When you are writing frameworks
 — something we won't be doing anytime soon —
 and (`2`) when you are writing tests .
 We are going to learn about tests one day
 but we will save the discussion of `access control` when we get there .
 
 
 In the next video ,
 let's look at a few quick examples
 of how `access levels` are used
 with different constructs .
 */
