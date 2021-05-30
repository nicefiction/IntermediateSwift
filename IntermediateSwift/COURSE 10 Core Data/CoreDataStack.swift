//  CoreDataStack.swift

import Foundation
import CoreData



class CoreDataStackTheory {
    
    // Creates a destination to store the data :
    private(set) lazy var applicationDocumentsDirectory: URL = {
        
        let urls = FileManager.default.urls(for : FileManager.SearchPathDirectory.documentDirectory ,
                                            in : FileManager.SearchPathDomainMask.userDomainMask)
        
        let endIndex = urls.index(before : urls.endIndex)
        
        return urls[endIndex]
    }()
    
    
    // Creates the Managed Object Model :
    private(set) lazy var managedObjectModel: NSManagedObjectModel = {
        
        let modelURL = Bundle.main.url(forResource : "ToDoList" ,
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
    lazy var managedObjectContext: NSManagedObjectContext = {
    
        let coordinator = self.persistentStoreCoordinator
        
        let managedObjectContext = NSManagedObjectContext(concurrencyType : .mainQueueConcurrencyType)
        
        managedObjectContext.persistentStoreCoordinator = coordinator
        
        return managedObjectContext
    }()
}
