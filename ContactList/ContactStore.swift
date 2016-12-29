//
//  ContactStore.swift
//  ContactList
//
//  Created by Vahid on 14/07/2016.
//  Copyright © 2016 Vahid. All rights reserved.
//

import UIKit
import CoreData

enum ContactError: Error {
    case contactCreationError
}

class ContactStore {
    
    let coreDataStack = CoreDataStack()
    
    let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    func processContactsRequest(data: Data?, error: NSError?) -> ContactsResult {
        guard let jsonData = data else {
            return .failure(error!)
        }
        
        return JsonApi.contactsFromJSONData(jsonData,
                                            inContext: self.coreDataStack.managedObjectContext)
    }
        
    
    func fetchMainQueueContacts(predicate: NSPredicate? = nil,
                                          sortDescriptors: [NSSortDescriptor]? = nil) throws -> [Contact] {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
        fetchRequest.sortDescriptors = sortDescriptors
        
        let mainQueueContext = self.coreDataStack.managedObjectContext
        var mainQueueContacts: [Contact]?
        var fetchRequestError: Error?
        mainQueueContext.performAndWait({
            do {
                mainQueueContacts = try mainQueueContext.fetch(fetchRequest) as? [Contact]
            }
            catch let error {
                fetchRequestError = error
            }
        })
        
        guard let contacts = mainQueueContacts else {
            throw fetchRequestError!
        }
        
        return contacts
    }
    
    func fetchContacts(completion: @escaping (ContactsResult) -> Void) {
        
        let url = URL(string: JsonApi.getUrl())
        let request = URLRequest(url: url!)
        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error) -> Void in
            
            var result = self.processContactsRequest(data: data, error: error as NSError?)

            if case let .success(contacts) = result {
                
                let queueContext = self.coreDataStack.managedObjectContext
                queueContext.performAndWait({
                    try! queueContext.obtainPermanentIDs(for: contacts)
                })
                let objectIDs = contacts.map{ $0.objectID }
                let predicate = NSPredicate(format: "self IN %@", objectIDs)
                let sortByName = NSSortDescriptor(key: "contactID", ascending: true)
                
                do {
                    try self.coreDataStack.saveContext()
                    
                    let mainQueueContacts = try self.fetchMainQueueContacts(predicate: predicate,
                        sortDescriptors: [sortByName])
                    result = .success(mainQueueContacts)
                }
                catch let error {
                    result = .failure(error)
                }
            }
            
            completion(result)
        })
        task.resume()
    }
    func fetchContactsWithSort(_ sort: Bool , contacts: [Contact], completion: (ContactsResult) -> Void) {
        
        var resultContacts = ContactsResult.success(contacts)
        
                let queueContext = self.coreDataStack.managedObjectContext
                queueContext.performAndWait({
                    try! queueContext.obtainPermanentIDs(for: contacts)
                })
                let objectIDs = contacts.map{ $0.objectID }
                let predicate = NSPredicate(format: "self IN %@", objectIDs)
                let sortByName = NSSortDescriptor(key: "fullName", ascending: sort)
                
                do {
                    try self.coreDataStack.saveContext()
                    
                    let mainQueueContacts = try self.fetchMainQueueContacts(predicate: predicate,
                        sortDescriptors: [sortByName])
                    resultContacts = .success(mainQueueContacts)
                }
                catch let error {
                    resultContacts = .failure(error)
                }
        
            completion(resultContacts)
    }
    
    func offlineContacts( _ completion: (ContactsResult) -> Void) {
        
        var resultContacts : ContactsResult
        
        let moc = self.coreDataStack.managedObjectContext
        let contactsFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
        
        do {
            let fetchedContacts = try moc.fetch(contactsFetch) as! [Contact]
            print(fetchedContacts.count)
            print(fetchedContacts)
            if fetchedContacts.count > 0 {
                resultContacts = .success(fetchedContacts)
            }
            else {
                resultContacts = .failure(FetchError.errorFetchingResults)
            }

        } catch let error {
            resultContacts = .failure(error)
        }
        completion(resultContacts)
    }
    
}
