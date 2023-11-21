//
//  PersistentEventManager.swift
//  EventManager
//
//  Created by Ilya Kharlamov on 11/30/22.
//  Copyright © 2022 DIGITAL RETAIL TECHNOLOGIES, S.L. All rights reserved.
//

import CoreData
import Foundation

public final class EventManager: NSPersistentContainer {
    
    public let queue = DispatchQueue(label: "com.simla.PersistantEventManager", qos: .default)
    
    var limitEvents: [NSManagedObject] = []
    var allEvents: [NSManagedObject] = []
    
    public init() {
        super.init(name: "PersistantEventManagerDB", managedObjectModel: Self.model)
        let description = NSPersistentStoreDescription()
        description.shouldMigrateStoreAutomatically = true
        description.shouldInferMappingModelAutomatically = true
        persistentStoreDescriptions.append(description)
        loadPersistentStores(completionHandler: { _, error in
            if let error {
                fatalError(error.localizedDescription)
            }
        })
    }
    
    // сохронение события в БД
    public func capture(_ event: Event) {
        performBackgroundTask({ context in
            let newRecord = DBEvent(context: context)
            newRecord.id = event.id
            newRecord.createdAt = event.date
            
            if !event.parameters.isEmpty {
                newRecord.parameters = Set(event.parameters.map({
                    return DBParameter(parameter: $0, context: context)
                }))
            }
            
            do {
                try context.save()
            } catch {
                print("Error:", error.localizedDescription)
            }
            
        })
    }
    
    public func getLimitEvents(n: Int = 0) {
        
        var limitAllEvents: [NSManagedObject] = []
        let request = DBEvent.makeFetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(DBEvent.createdAt), ascending: false)
        request.sortDescriptors = [sort]
        request.fetchLimit = (15 + n)
        
        queue.sync {
            do {
                limitAllEvents = try viewContext.fetch(request)
            } catch let error as NSError {
                print("Coud not fetch \(error), \(error.userInfo)")
            }
        }
        
        limitEvents = limitAllEvents
        
    }
    
    public func getEvents() {
        
        var events: [NSManagedObject] = []
        let request = DBEvent.makeFetchRequest()
        
        queue.sync {
            do {
                events = try viewContext.fetch(request)
            } catch let error as NSError {
                print("Coud not fetch \(error), \(error.userInfo)")
            }
        }
        
        allEvents = events
        
    }
    
    public func deleteEvent(index: Int) {
        
        let context = viewContext
        let parameterSet = limitEvents[index].value(forKey: R.KeyProperties.parameters) as? NSSet ?? NSSet()
        
        context.delete(limitEvents[index])
        limitEvents.remove(at: index)
        
        // remove parameters of event
        for parameter in parameterSet {
            context.delete((parameter as! NSManagedObject))
            
        }
        do {
            try context.save()
        } catch {
            print("Error:", error.localizedDescription)
        }
    }
    
    public func entitiesCount() -> Int {
        do {
            return try viewContext.count(for: DBEvent.makeFetchRequest())
        } catch {
            print("Error:", error.localizedDescription)
            return .zero
        }
    }
    
    public func containsEvent(_ event: String, withParameters parameters: ParameterSet? = nil) -> Bool {
        containsEvent(with: preparePredicate(forEvent: event, withParameters: parameters))
    }
    
    public func containsEvent(with predicate: NSPredicate) -> Bool {
        let request = DBEvent.makeFetchRequest()
        request.predicate = predicate
        do {
            return try viewContext.count(for: request) > 0
        } catch {
            print("Error:", error.localizedDescription)
            return false
        }
    }
    
    public func lastDateOfEvent(_ event: String, withParameters parameters: ParameterSet? = nil) -> Date? {
        lastDateOfEvent(with: preparePredicate(forEvent: event, withParameters: parameters))
    }
    
    public func lastDateOfEvent(with predicate: NSPredicate) -> Date? {
        let request = DBEvent.makeFetchRequest()
        request.predicate = predicate
        let sort = NSSortDescriptor(key: #keyPath(DBEvent.createdAt), ascending: false)
        request.sortDescriptors = [sort]
        request.fetchLimit = 1
        do {
            return try viewContext.fetch(request).first?.createdAt
        } catch {
            print("Error:", error.localizedDescription)
            return nil
        }
    }
    
    public func clean(completion: ((Error?) -> Void)? = nil) {
        performBackgroundTask { context in
            do {
                let deleteFetchEvent = NSFetchRequest<NSFetchRequestResult>(entityName: DBEvent.entityName)
                let deleteFetchParameter = NSFetchRequest<NSFetchRequestResult>(entityName: DBParameter.entityName)
                
                let deleteRequestEvent = NSBatchDeleteRequest(fetchRequest: deleteFetchEvent)
                let delereRequestParameter = NSBatchDeleteRequest(fetchRequest: deleteFetchParameter)
                
                try context.execute(deleteRequestEvent)
                try context.execute(delereRequestParameter)
                
                if context.hasChanges {
                    try context.save()
                }
                DispatchQueue.main.async {
                    completion?(nil)
                }
            } catch {
                print("Error:", error.localizedDescription)
                DispatchQueue.main.async {
                    completion?(error)
                }
            }
        }
    }
    
    private func preparePredicate(forEvent event: String, withParameters parameters: ParameterSet?) -> NSPredicate {
        var subPredicates: [NSPredicate] = [
            NSPredicate(format: "id=%@", event)
        ]
        if let parameters {
            for (key, paramValue) in parameters {
                let value: (format: String, arg: CVarArg) = {
                    switch paramValue {
                    case .string(let value):
                        return ("stringValue = %@", value)
                    case .bool(let value):
                        return ("booleanValue = %@", value)
                    case .integer(let value):
                        return ("integerValue = %i", value)
                    case .array(let value):
                        return ("arrayValue = %@", value)
                    }
                }()
                let paramPredicate = NSPredicate(
                    format: "SUBQUERY(parameters, $p, $p.key = %@ AND $p.\(value.format)).@count > 0",
                    key,
                    value.arg
                )
                subPredicates.append(paramPredicate)
            }
        }
        return NSCompoundPredicate(andPredicateWithSubpredicates: subPredicates)
    }
}
