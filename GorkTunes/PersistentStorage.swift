//
//  PersistentStorage.swift
//  GorkTunes
//
//  Created by Malachi McArthur on 1/17/26.
//
import CoreData

class PersistentStorage {
    static let shared = PersistentStorage()
    private init(){}
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PersistentData")
        container.loadPersistentStores{ _ , error in
            if let error = error{
                fatalError("Failed to load CoreData Stack \(error)")
            }
        }
        return container
    }()
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    func setUpCoreDataStack(){
        
    }
    
}
