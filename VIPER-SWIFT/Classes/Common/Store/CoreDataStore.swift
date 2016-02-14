//
//  CoreDataStore.swift
//  VIPER-SWIFT
//
//  Created by Conrad Stoll on 6/4/14.
//  Copyright (c) 2014 Mutual Mobile. All rights reserved.
//

import Foundation
import CoreData

extension Array {
    func lastObject() -> Element {
        let endIndex = self.endIndex
        let lastItemIndex = endIndex - 1
        
        return self[lastItemIndex]
    }
}

class CoreDataStore : NSObject {
    var persistentStoreCoordinator : NSPersistentStoreCoordinator?
    var managedObjectModel : NSManagedObjectModel?
    var managedObjectContext : NSManagedObjectContext?
    
    override init() {
        managedObjectModel = NSManagedObjectModel.mergedModelFromBundles(nil)
        
        persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel!)
        
        let domains = NSSearchPathDomainMask.UserDomainMask
        let directory = NSSearchPathDirectory.DocumentDirectory
        
        let applicationDocumentsDirectory : AnyObject = NSFileManager.defaultManager().URLsForDirectory(directory, inDomains: domains).lastObject()
        let options = [NSMigratePersistentStoresAutomaticallyOption : true, NSInferMappingModelAutomaticallyOption : true]
        
        let storeURL = applicationDocumentsDirectory.URLByAppendingPathComponent("VIPER-SWIFT.sqlite")
        
        try? persistentStoreCoordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: "", URL: storeURL, options: options)

        managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
        managedObjectContext!.persistentStoreCoordinator = persistentStoreCoordinator
        managedObjectContext!.undoManager = nil
        
        super.init()
    }
    
    func fetchEntriesWithPredicate(predicate: NSPredicate, sortDescriptors: [AnyObject], completionBlock: (([ManagedTodoItem]) -> Void)!) {
        let fetchRequest = NSFetchRequest(entityName: "TodoItem")
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = []
        
        managedObjectContext?.performBlock {
            let queryResults = try? self.managedObjectContext?.executeFetchRequest(fetchRequest)
            let managedResults = queryResults! as! [ManagedTodoItem]
            completionBlock(managedResults)
        }
    }
    
    func newTodoItem() -> ManagedTodoItem {
        let entityDescription = NSEntityDescription.entityForName("TodoItem", inManagedObjectContext: managedObjectContext!)
        let newEntry = NSManagedObject(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext) as! ManagedTodoItem
        
        return newEntry
    }
    
    func save() {
        do {
            try managedObjectContext?.save()
        } catch _ {
        }
    }
}