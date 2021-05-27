import Foundation
import CoreData


/**
 `5 The Persistent Store Coordinator`
 INTRO — The next part of our stack that we need to create , is ,
 the `Persistent Store Coordinator` .
 This is the object that will talk to both
 the `context` and the actual `data store` .
 */
/**
 For the next part of our `CoreDataStack` ,
 we need a `Persistent Store Coordinator` .
 
 `Managed Object Context`
 `|`
 `Persistent Store Coordinator`
 `|`
 `Persistent Store`
 
 The `Persistent Store` sits in the middle of the stack
 and is responsible for realising instances of entities
 that are defined in the `managed object model` .
 It creates new instances of those entities
 and it retrieves existing instances from a `Persistent Store` .
 */

class CoreDataStack {
    
    // Creates a destination to store the data :
    private(set) lazy var applicationDocumentsDirectory: URL = {
        
        let urls = FileManager.default.urls(for : FileManager.SearchPathDirectory.documentDirectory ,
                                            in : FileManager.SearchPathDomainMask.userDomainMask)
        
        let endIndex = urls.index(before : urls.endIndex)
        
        return urls[endIndex]
    }()
    
    
    // Creates the Managed Object Model :
    private(set) lazy var managedObjectModel: NSManagedObjectModel = {
        
        let modelURL = Bundle.main.url(forResource : "toDoList" ,
                                       withExtension : "momd")!
        
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    
    // Creates the Persistent Store Coordinator :
    private(set) lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        
        // Hooks up the Persistent Store Coordinator with the Managed Object Model :
        let coordinator: NSPersistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel : managedObjectModel)
        
        // Specifies the location of the store :
        let url = self.applicationDocumentsDirectory.appendingPathComponent("ToDoList.sqlite")
        
        // Creates the Persistent Store :
        do {
            try coordinator.addPersistentStore(ofType : NSSQLiteStoreType ,
                                               configurationName : nil ,
                                               at : url)
        } catch let error {
            print(error)
            
            abort()
        }
        
        return coordinator
    }()
}

 /**
 So again ,
 we want the `lazy stored property` to be _publicly readable_
 but only _settable inside_ the [ OLIVIER : CoreDataStack ] class :
 
 `private(set) lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = { ... }()``
 
 Inside the body of the closure
 we are going to create a `coordinator` , ...
 
 `let coordinator: NSPersistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel : managedObjectModel)`

 ... and this `coordinator` is an instance of the `NSPersistentStoreCoordinator class` .
 Since a `Persistent Store Coordinator` communicates
 between the `Managed Object Model` and the `Persistent Store` ,
 we need to hook them all up in here .
 So first ,
 let's create an instance of the `coordinator` [ OLIVIER : NSPersistentStoreCoordinator ]
 by initialising it with a `managedObjectModel` .
 Now that we have a coordinator that is hooked up to our managed object model .
 
 `NSPersistentStoreCoordinator(managedObjectModel : managedObjectModel)`
 
 Once it has a `managedObjectModel`
 — knows how to create these things —
 next ,
 the `coordinator` needs to know about
 where we are going to save the data .
 What is our `Persistent Store` ?
 We haven't specified where we want to save the data , yet ,
 so , let's do that :
 
 `let url = self.applicationDocumentsDirectory.appendingPathComponent("ToDoList.sqlite")`
 
 First , we need to specify the location ,
 which is always defined as a `url` .
 We are going to use the `applicationDocumentsDirectory` URL we created earlier
 
 `private(set) lazy var applicationDocumentsDirectory: URL = {`
 
    `let urls = FileManager.default.urls(for : FileManager.SearchPathDirectory.documentDirectory ,`
                                        `in : FileManager.SearchPathDomainMask.userDomainMask)`
 
    `let endIndex = urls.index(before : urls.endIndex)`
 
    `return urls[endIndex]`
`}()`
 
 and append a path component to that
 
 `let url = self.applicationDocumentsDirectory.appendingPathComponent("ToDoList.sqlite")`
 
 to specify the location of a `SQLite file` as a `String` .
 Using this `url` ,
 we can now ask `core data`
 to create a `persistent store` for us when it launches for the first time .
 The method to do this is a _throwing method_ ,
 so we need to wrap it in a `do catch statement` :
 
 `do {`
     `try coordinator.addPersistentStore(ofType : NSSQLiteStoreType ,`
                                        `configurationName : nil ,`
                                        `at : url)`
 `} catch let error {`
     `print(error)`
     
     `abort()`
 `}`
 
 Okay ,
 so back to the `do block` ,
 
 `try coordinator.addPersistentStore(ofType : NSSQLiteStoreType ,`
                                    `configurationName : nil ,`
                                    `at : url)`
 
 The method we are using is called `addPersistentStore() ofType` ,
 The method takes a type of a `persistent store` .
 We want a `SQLite database`
 so we are going to pass in `NSSQLiteStoreType` for the configuration ,
 The next argument is a `configurationName` .
 We are going to pass in `nil` , we are not going to worry about it .
 Next , the method takes a stored property — `url` ,
 and we are creating the `persistent store` at this `url` .
 If this works ,
 we now have a `coordinator` with an associated `managedObjectModel` .
 As well as a `persistent Store` in the form of a `SQLite database`
 saved in the applicationDocumentsDirectory .
 If this doesn't work ,
 an `error` is thrown .
 
 `do {`
    `...`
 
 ` } catch let error {`
     `print(error)`
     
     `abort()`
 `}`
 
 We need to provide some error handling code
 so that we know what went wrong .
 In a `catch statement` like this ,
 the error is automatically bound to a `local constant` .
 So , for now we are just going to print the `error` .
 
 `NOTE` :
 At this point , when shipping the app to actual users ,
 we need to do something with this `error` .
 We need to do something informative ,
 either we can log it ,
 or let the user know that something went wrong .
 Logging is almost necessary ,
 because you — the developer — want to know
 what went wrong on your customer's device as well .
 So , for our purposes , though ,
 all we are going to do , is ,`abort()`.
 
 `NOTE` :
 The `addPersistentStore() ofType` method
 takes an `options dictionary` here as well ,
 
 `try coordinator.addPersistentStore(ofType : NSSQLiteStoreType ,`
                                    `configurationName : nil ,`
                                    `at : url ,`
                                    `options: [AnyHashable : Any]?)`
 It is an optional parameter that defaults to `nil` ,
 so we are not going to worry about it here ,
 we are just going to leave it at that `nil` argument .

 
 
 
 Okay ,
 step three is done .
 We now have
 a `managed object model` ,
 a `persistent store coordinator` ,
 and an `associated persistence store` .
 In the next video ,
 let's create the final component of our `CoreDataStack` ,
 the `Managed Object Context` .
 */
