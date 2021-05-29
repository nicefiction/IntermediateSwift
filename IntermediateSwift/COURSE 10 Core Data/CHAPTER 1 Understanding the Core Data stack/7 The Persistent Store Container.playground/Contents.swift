import Foundation
import CoreData


/**
 `7 The Persistent Store Container`
 INTRO — Despite all that work we did ,
 there is a much simpler way to create a Core Data stack .
 In this video
 lets explore a new class , `NSPersistentContainer`
 and see how it simplifies our code .
 */
/**
 In iOS 10 , Apple engineers bestowed from the heavens above
 a new class — `NSPersistentContainer` —
 that handles the creation of
 the `managedObjectModel` ,
 the `persistentStoreCoordinator` ,
 and the `managedObjectContext`
 automatically for us
 with just a few lines of code .
 So , let's see what difference this makes :
 */

class CoreDataStack {
    
    // Creates a destination to store the data :
//    private(set) lazy var applicationDocumentsDirectory: URL = {
//
//        let urls = FileManager.default.urls(for : FileManager.SearchPathDirectory.documentDirectory ,
//                                            in : FileManager.SearchPathDomainMask.userDomainMask)
//
//        let endIndex = urls.index(before : urls.endIndex)
//
//        return urls[endIndex]
//    }()
    
    
    // Creates the Managed Object Model :
//    private(set) lazy var managedObjectModel: NSManagedObjectModel = {
//
//        let modelURL = Bundle.main.url(forResource : "toDoList" ,
//                                       withExtension : "momd")!
//
//        return NSManagedObjectModel(contentsOf: modelURL)!
//    }()
    
    
    // Creates the Persistent Store Coordinator :
//    private(set) lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        
        // Hooks up the Persistent Store Coordinator with the Managed Object Model :
//        let coordinator: NSPersistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel : managedObjectModel)
        
        // Specifies the location of the store :
//        let url = self.applicationDocumentsDirectory.appendingPathComponent("ToDoList.sqlite")
        
        // Creates the Persistent Store :
//        do {
//            try coordinator.addPersistentStore(ofType : NSSQLiteStoreType ,
//                                               configurationName : nil ,
//                                               at : url)
//        } catch let error {
//            print(error)
//
//            abort()
//        }
//
//        return coordinator
//    }()
    
    
    // Manages the object context :
//    lazy var managedObjectContext: NSManagedObjectContext = {
//
//        let coordinator = self.persistentStoreCoordinator
//
//        let managedObjectContext = NSManagedObjectContext(concurrencyType : .mainQueueConcurrencyType)
//
//        managedObjectContext.persistentStoreCoordinator = coordinator
//
//        return managedObjectContext
//    }()
    
    
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        
//        let coordinator = self.persistentStoreCoordinator
//        let managedObjectContext = NSManagedObjectContext(concurrencyType : .mainQueueConcurrencyType)
//        managedObjectContext.persistentStoreCoordinator = coordinator

//        return managedObjectContext
        
        let container = self.persistentContainer
        
        return container.viewContext
    }()
    
    
    
    private lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name : "ToDoList")
        
        container.loadPersistentStores(){ (storeDescription , error) in
            
            if
                let _error = error as NSError? {
                fatalError("Unresolved error : \(_error) , \(_error.userInfo)")
            }
        }
        
        return container
    }()
}

/**
 So , let's see what difference this makes :
 
`private lazy var persistentContainer: NSPersistentContainer = {`
     
     let container = NSPersistentContainer(name : "ToDoList")
     
     container.loadPersistentStores(){ (storeDescription , error) in
         
         if
             let _error = error as NSError? {
 
             fatalError("Unresolved error : \(_error) , \(_error.userInfo)")
         }
     }
     
     return container
 `}()`
 
 (`1`)
 First , we'll start off by creating a `container `:
 
 `let container = NSPersistentContainer(name : "ToDoList")`
 
 Creating a `container` is super easy .
 We just need to specify a name
 that matches
 our `SQLite database`and the GUI editor file that we create .
 And we will stick to the name we used earlier , which is `ToDoList` .
 
 (`2`)
 The next step is to instruct the persistent container
 to create the persistent stores ,
 which we'll do by calling the `loadPersistentStores()` method :
 
 `container.loadPersistentStores(){ (storeDescription , error) in`
    `...`
 `}`
 
 This method takes a completion handler that is called
 when the store is created
 and includes the `NSPersistentStoreDescription`
 and an `Error` object if anything goes wrong .
 We define this as a trailing closure with two arguments
 — `storeDescription` and `error` .
 The type of error value here is the `Error` protocol ,
 but the actual error object returned by the framework
 is an `NSError object` .
 So , we'll check if the error object exists and attempt to cast that to `NSError` .
 And if it does , again , for the sake of this course , we'll crash .
 
 `if`
     `let _error = error as NSError? {`
 
     `fatalError("Unresolved error : \(_error) , \(_error.userInfo)")`
 `}`
 
 And we'll include a message .
 And we'll also get the error's `userInfo` dictionary for more context .
 Seriously ,
 all the work of creating the `managedObjectModel` , `persistentStoreContext `,
 all that is handled for us by the [ OLIVIER : CoreData ] framework .
 Since we are going to be using the `managedObjectContext` throughout our app ,
 we'll expose it in our class , again , by modifying this
 so that we can read the new property . Okay , so now ,
 let's modify the `managedObjectContext` .
 And before we do that , let's get rid of everything else .
 So now , in here , inside this ,
 we'll get rid of the body and we'll say ,

 `lazy var managedObjectContext: NSManagedObjectContext = {`
     
    `// let coordinator = self.persistentStoreCoordinator`
    `// let managedObjectContext = NSManagedObjectContext(concurrencyType : .mainQueueConcurrencyType)`
    `// managedObjectContext.persistentStoreCoordinator = coordinator`

    `// return managedObjectContext`
 
    `let container = self.persistentContainer`
    `return container.viewContext`
 `}()`
 
 To get access to the `managedObjectContext` ,
 we call a property named `viewContext` ,
 And that is it .
 With this approach ,
 we don't have to worry about
 getting multiple moving parts implemented correctly .
 We can rely on the framework to handle all of it for us ,
 which is much better .
 Okay ,
 with the core data stack out of the way ,
 let's get to building our app .

 */
