//  CoreDataStack.swift

import Foundation
import CoreData



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
}
