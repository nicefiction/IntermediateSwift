//  CoreDataStack.swift

import Foundation



class CoreDataStack {
    
    // Creates a destination to store the data :
    lazy var applicationDocumentsDirectory: URL = {
        
        let urls = FileManager.default.urls(for : FileManager.SearchPathDirectory.documentDirectory ,
                                            in : FileManager.SearchPathDomainMask.userDomainMask)
        
        let endIndex = urls.index(before : urls.endIndex)
        
        return urls[endIndex]
    }()
}
