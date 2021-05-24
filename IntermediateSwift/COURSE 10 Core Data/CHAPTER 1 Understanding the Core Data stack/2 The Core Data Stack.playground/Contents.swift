import Foundation


/**
 `2 The Core Data Stack`
 Before we talk about what Core Data is exactly ,
 let's talk about what it is _not_
 because there are several misconceptions about its role :
 
 (`1`) If you are coming from a different domain like web development ,
 you might be familiar with `Object Relational Mapping` frameworks ,
 or `ORM`s — like Django’s ORM , or Active Record in Rails .
 Core data is not an ORM ,
 An ORM framework converts between a type system and data .
 So , a Swift ORM would let you query your data
 and it would return a type rather than an instance of data or NS data .
 
 (`2`) If you have worked with `SQL` or `wrapper libraries`
 that make it easier to write functions
 that call SQL code ,
 Core Data is not a `wrapper` either .
 If those terms mean nothing to you ,
 then don't worry
 you are starting off with a clean slate .
 As we mentioned before ,
 `Core Data` is good at `object graph management` ,
 and we'll see what that means in a bit .
 Core data has many moving parts ,
 and together these parts are often referred to as the `Core Data stack` .
 I mentioned earlier that Core Data is two distinct pieces ,
 `1` an `object graph manager`
 and `2` a `persistence framework` .
 
 [ 1 : OBJECT GRAPH MANAGER ]
 So , what is an object graph ?
 An `object graph` is a collection of different objects
 along with the relationships between said objects .
 In previous courses , we have
 (`A`) created custom types
 to represent any of our model objects ,
 and (`B`) defined relationships between those objects as well .
 For example ,
 here is a bit of code that describes
 the stereotypical code example of
 Manager , Employee , and Department relationships :
 */

class Manager {
    
    let employees = Array<Employee>()
    weak var department: Department?
}


class Employee {
    
    weak var manager: Manager?
    weak var department: Department?
}


class Department {
    
    var manager: Manager?
    let employees = Array<Employee>()
}

/**
 Here , we have encoded a relationship between the three objects .
 `NOTE` that an `Employee` can have a `Manager` ,
 a `Manager` can have an array of employees who report to them ,
 and all of them — `Manager` and `Employee` — are part of a `Department` .
 Because we don't want to create circular references
 and thereby a `retain cycle` ,
 we have modified ownership by annotating a few properties as `weak` .
 Since a `Manager` maintains a `strong reference` to all their direct reports ,
 employees maintain a `weak reference` to their managers ,
 All of this code forms an `object graph`
 where the relationships between the objects are specified .
 While this is easily doable in code ,
 if we forget to specify certain properties as `weak` ,
 we can run into memory problems . Moreover ,
 we'd have to worry about serialising
 or converting each of these objects
 into a format that we can save on a disk .
 So , rather than writing code to manage these sets of relationship ,
 we can let `Core Data` handle it for us .
 Because Core Data is an `object graph manager` ,
 we can specify these relationships using an editor ,
 and Core Data handles the code in the background .
 Like all courses , we are going to build an app in this one .
 And we'll see how we can use Core Data
 to manage object relationships .
 So , that is the `object graph` portion of Core Data .
 
 
 [ 2 : PERSISTENCE FRAMEWORK ]
 The next important piece is the `Persistence` ,
 which means
 taking the state of all the objects in our graph ,
 saving it ,
 and retrieving it at a later time .
 So , here is what our current picture of Core Data looks like at a high level :
 
 `Object Graph Manager`
    `|`
 `Persistence`
 
 We have the `Object Graph Manager` at the top
 and `Persistence` at the bottom .
 The first part handles the `model logic` .
 The second part saves the `state of the model` .
 To coordinate between these two ,
 we have a `Coordinator` object :
 
 `Object Graph Manager`
    `|`
 `Coordinator`
    `|`
 `Persistence`
 
 The `Coordinator` communicates with either end of the stack
 to facilitate `model logic` to `persistence` , and vice versa .
 Let's go back to the `Object Graph Management` part .
 The `models` that we create in Core Data
 live inside what is known as a `Context` .
 Think of the `Context` as an intelligent scratch pad .
 When we work with any of our `model objects` ,
 we change the `state` of them constantly :
 We create new instances ,
 we edit data ,
 and we delete instances all the time .
 The `Context` will keep note of all these changes .
 Because the `model object` that we use in this scenario
 are managed by Core Data ,
 they are called `managed objects` .
 Because these `managed objects` exist in a `Context`,
 we call the `Context`
 the `Managed Object Context` .
 Now keep these terms in mind .
 Core data has a lot of terms and names for parts of its stack ,
 and if we are to fully understand how it works ,
 we need to know these moving parts .
 All `Managed Objects` need to be registered or be part of a `Context` .
 Our `Object Graph management` portion of Core data now looks like this :
 
 `Managed Object Context`
    `|`
 `Coordinator`
    `|`
 `Persistence`
 
 We have a `Context` that contains `Managed Objects` .
 There can be more than one `Context` with its own set of `Managed Objects` ,
 but for most cases
 a single `Context` is sufficient .
 The next part of the stack — if we go down one level — is ,
 the `Coordinator` .
 The `Coordinator` is more formally known as the `Persistent Store Coordinator`:
 
 `Managed Object Context`
    `|`
 `Persistent Store Coordinator`
    `|`
 `Persistence`
 
 All the changes that are monitored in the `Managed Object Context`
 don't get saved
 unless we call _Save_ .
 When we do this ,
 information is provided to the `Persistent Store Coordinator`
 to make the save to the disk .
 And this brings us to the last part of the stack , the `Persistent Store` :
 
 `Managed Object Context`
    `|`
 `Persistent Store Coordinator`
    `|`
 `Persistent Store`
 
 The `Persistent Store` consists of a `Store object`
 that interacts with the underlying database .
 The database by default is a `SQL lite database`
 that is stored somewhere on the `apps file system` .
 The `Persistent Store Coordinator` and the `Persistent Store` together
 are responsible for
 mapping between
 the data in the store
 and corresponding objects in a context .
 Okay , a bit complicated ,
 but now that you know what the Core data stack looks like at a high level ,
 let's build an app .
 Because Core data is relatively complex ,
 we are going to keep the app very simple
 and we'll build a task manager — or a to-do-list app — much like the Reminders app .
 Let's jump right in .
 */
