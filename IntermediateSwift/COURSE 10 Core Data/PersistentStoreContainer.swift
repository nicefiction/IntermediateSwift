//  PersistentStoreContainer.swift

import Foundation
import CoreData



class CoreDataStack {
    
    // MARK: MANAGED OBJECT CONTEXT
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        
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
