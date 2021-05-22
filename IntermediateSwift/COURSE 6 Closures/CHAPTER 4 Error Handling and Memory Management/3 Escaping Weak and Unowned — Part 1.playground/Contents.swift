import Foundation


/**
 `3 Escaping, Weak and Unowned` PART 1 OF 2
 INTRO — We have made two assumptions in our work with closures so far :
 First that they are executed immediately ,
 and second that we always want strong relationships .
 In this video ,
 let’s examine those assumptions
 so we know what to do when they fall apart .
 */
/**
 All of the closures we have looked at so far
 have involved a couple of assumptions ,
 one of which is that the closure is called immediately .
 This isn't always the case .
 In the `map()` function , yes , it is ,
 like when we pass in a value to `map()` ,
 that closure is called immediately using that value .
 But let's look at another example .
 Let's define a class ,
 we'll call it `NetworkSessionManager` :
 */

/*
class NetworkSessionManager {
    
    typealias CompletionHandler = () -> Void
    
    
    var completionHandlers = Array<CompletionHandler>()
    
    
    func dataTask(with handler: CompletionHandler) {
        
        completionHandlers.append(handler) // ERROR : Converting non-escaping parameter 'handler' to generic parameter 'Element' may allow it to escape .
    }
}
 */

/**
 And here ,
 we'll pretend that this class is responsible for
 firing off a series of network requests ,
 and upon completion of each request
 it will execute the contents of a closure that we provide .
 Now , first , to make all these functions signatures easier to read ,
 we will define a `typealias` called `CompletionHandler`
 that has a signature of `Void to Void` ,

 `typealias CompletionHandler = () -> Void`
 
 Next ,
 we are going to add ,
 as a variable stored property to this class ,
 an array that will hold on to each closure that we pass in :

 `var completionHandlers = Array<CompletionHandler>()`
 
 After that ,
 a really simple function,
 we will call this `dataTask()` ,
 whose job is
 to purely highlight this example :
 
 `func dataTask(with handler: CompletionHandler) {`
 
    `completionHandlers.append(handler)`
 `}`
 
 The `dataTask()` function takes as a parameter
 a closure of type `CompletionHandler` ,
 which again is just `Void to Void` .
 So , no parameters and no return type .
 The interesting part of this function is
 that the closure we are passing in
 as an argument to the `handler` parameter
 won't be called immediately . In fact ,
 what we are going to do , is ,
 `append` it to our array .
 
 `completionHandlers.append(handler)`
 
 What is our error , let's see ,
 
 `ERROR : Converting non-escaping parameter 'handler' to generic parameter 'Element' may allow it to escape .`
 
 This might seem odd ,
 particularly since we haven't really built up any context around this example .
 But this is a common occurrence , that is ,
 executing a closure
 sometime after the containing function returns .
 So here , `dataTask()`
 with `handler` — the function we are calling —
 is going to finish executing and return
 without having executed the closure passed into it .
 At some point later
 we are going to retrieve this `handler` back out of the array
 and execute it .
 _But who knows when that will happen ?_
 This is typical of `asynchronous code`
 that runs independent of the main program flow .
 Now ,
 you don't know what asynchronous code is necessarily ,
 we'll talk about this soon .
 But think of writing code that downloads content from the Internet , for example .
 Regardless of whether you have a slow or a fast connection ,
 when you make a web request ,
 the code that determines
 what you do with the results
 won't be executed immediately ,
 because , well ,
 the web request won't finish executing immediately .
 Imagine our case that the `dataTask()` method fires off a web request ,
 and when the request is done ,
 the code in the `CompletionHandler`
 
 `typealias CompletionHandler = () -> Void`
 
 is executed .
 There is no way
 to determine
 when a request will be completed ,
 particularly if you have a slow connection .
 So ,
 the closure can be executed
 some time after the `dataTask()` method is called .
 In cases like this ,
 where the closure is called after the function returns ,
 we say that the `closure escapes` .
 So , over here ,
 `escaping` means
 the fact that this closure no longer resides just in the body of this `dataTask()` function .
 It leaves it , _it escapes_ , and we put it in this array :
 
 `var completionHandlers = Array<CompletionHandler>()`
 
 `completionHandlers.append(handler)`
 
 To allow a closure to escape ,
 we need to let the compiler know that .
 Otherwise , we get an error , which is what you see here .
 And to do this ,
 to allow the closure to escape ,
 we add the keyword `@escaping`
 right before the closure signature
 before that argument type :
 */

class NetworkSessionManager {
    
    typealias CompletionHandler = () -> Void
    
    
    var completionHandlers = Array<CompletionHandler>()
    
    
    func dataTask(with handler: @escaping CompletionHandler) {
        
        completionHandlers.append(handler)
    }
}

/**
 When you mark a closure as `escaping` ,
 the compiler knows that this may execute some point later .
 So , inside the body of the closure ,
 if you reference the outer scope ,
 if you were to use `self` in here ,
 you would have to do this explicitly .
 If a closure is `non-escaping` ,
 which all closures are by default ,
 then `self`
 — that is referring to the outer scope —
 
 `completionHandlers.append(handler)`
 
 is done implicitly .
 We won't really touch on this here ,
 and we'll stop with this topic for now .
 But when we do learn about `asynchronous code`
 — particularly in the context of making a web request —
 you will understand more
 about how escaping closures come into play .
 */
/**
👉 Continues in PART 2
*/
