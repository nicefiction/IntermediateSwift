import Foundation
import CoreData


/**
 `6 The Managed Object Context`
 INTRO — The last part of our core data stack is
 the `managed object context` .
 The `context` functions like a scratch pad ,
 keeping note of all changes to our object layer .
 In this video ,
 we add a `context`
 and thereby finish the building of our stack .
 */
/**
 The last part of our coordinated stack is the `managed object context` .
 
 `Managed Object Context`
    `|`
 `Persistent Store Coordinator`
    `|`
 `Persistent Store`
 
 Remember that this is the object
 that our app will be interacting with the most .
 The `Managed Object Context` will be keeping track of all the changes
 that happen across our object graph layer .
 All `managed objects`
 — which we have access to via the `managed object model` —
 must be registered with a `Managed Object Context` .
 The `Context` then tracks any changes we make
 — both to the individual objects attributes
 as well as to the relationship between any objects .
 When we save any changes we have made ,
 the `Context` ensures that our objects are in a valid state .
 If they are ,
 (`A`) the changes are written to the `Persistence Store` .
 (`B`) New entries are added to the database for objects we created ,
 or removed for objects we deleted .
 Core data does all of this for us automatically .
 Without it , we'd have to write code to archive and unarchive data
 to keep track of changes to our model objects
 and implement any functionality for redo and undo .
 So , we say ,
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
    
    
    // Manages the object context :
    // lazy public var managedObjectContext: NSManagedObjectContext = {
    lazy var managedObjectContext: NSManagedObjectContext = {
    
        let coordinator = self.persistentStoreCoordinator
        
        let managedObjectContext = NSManagedObjectContext(concurrencyType : .mainQueueConcurrencyType)
        
        managedObjectContext.persistentStoreCoordinator = coordinator
        
        return managedObjectContext
    }()
}

/**
 `NOTE` :
 Because we are going to be interacting with the `managed object context` often ,
 we are going to make this a `public` stored property .
 In fact ,
 we don't need the `public` keyword ,
 this is created internally by default
 by the internal scope , which is the entire app
 and that is perfectly fine .
 
 So , in here ,
 
 `lazy var managedObjectContext: NSManagedObjectContext = {`
 
     let coordinator = self.persistentStoreCoordinator
     
     let managedObjectContext = NSManagedObjectContext(concurrencyType : .mainQueueConcurrencyType)
     
     managedObjectContext.persistentStoreCoordinator = coordinator
     
     return managedObjectContext
 `}()`
 
 (`1`) first , we assign the `persistentStoreCoordinator` to a local constant :
 
 `let coordinator = self.persistentStoreCoordinator`
 
 (`2`) Then we create an instance of `NSManagedObjectContext` :
 
 `let managedObjectContext = NSManagedObjectContext(concurrencyType : .mainQueueConcurrencyType)`
 
 The initialiser for the `NSManagedObjectContext class` asks us
 to specify a `concurrencyType` .
 At this point you should know the basics of what concurrency means ,
 but concurrency of data is a pretty advanced topic .
 So , we are going to ignore this for now
 and simply pass in a standard value .
 
 (`3`) The `Context` needs to communicate with the `persistentStoreCoordinator` ,
 so , that is the last thing we have to do :
 
 `managedObjectContext.persistentStoreCoordinator = coordinator`
 
 (`4`) And now we can return the `managedObjectContext` :
 
 `return managedObjectContext`
 
 This is the entirety of our `core data stack` .
 While we still don't know how exactly we can use it ,
 at least we know how the different components are used to build one another ,
 and you have a general idea of the stack .
    So , you know how often times in courses ,
 I make you go through a video where we write a bunch of code ,
 and then I tell you to get rid of it ?
 Well , yeah , we are going to get rid of all of this .
 With iOS 10 ,
 we have a new `API`
 that allows us to create a core data stack in just a few lines of code .
 So , this entire exercise
 was just
 so you know what is going on under the hood .
 And hey ,
 if after all of these courses you didn't see this coming ,
 I don't know what to tell you .
 In the next video , let's refactor this class .
 */
