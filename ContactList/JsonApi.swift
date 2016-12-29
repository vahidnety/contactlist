//
//  JsonApi.swift
//  ContactList
//
//  Created by Vahid on 15/07/2016.
//  Copyright © 2016 Vahid. All rights reserved.
//

import Foundation
import CoreData

enum ContactsResult {
    case success([Contact]!)
    case failure(Error)
}

enum FetchError: Error {  
    case errorFetchingResults
}

class JsonApi {
    
    class func getUrl() -> (String){
        let jsonUrl = "http://jsonplaceholder.typicode.com/users"
        return jsonUrl
    }
    
    class func contactsFromJSONData(_ data: Data,
                                    inContext context: NSManagedObjectContext) -> ContactsResult {
        do {
            let jsonObject: AnyObject = try JSONSerialization.jsonObject(with: data, options: [])
            
            let contactsArray = jsonObject as? [[String:AnyObject]]
            
            var finalContacts = [Contact]()
            for contactJSON in contactsArray! {
                if let contact = contactFromJSONObject(contactJSON , inContext: context)
                {
                    finalContacts.append(contact)
                }
            }
            
            if finalContacts.count == 0 && contactsArray!.count > 0 {
                //error
                return .failure(FetchError.errorFetchingResults)
            }
            return .success(finalContacts)
        }
        catch let error {
            return .failure(error)
        }
    }
    
    fileprivate class func contactFromJSONObject(_ json: [String : AnyObject],
                                             inContext context: NSManagedObjectContext) -> Contact? {
        guard let
            fullName = json["name"] as? String,
            let emailAddress = json["email"] as? String,
            let contactID = json["id"]?.int32Value,
        
            let userName = json["username"] as? String,
            let website = json["website"] as? String,
            let phone = json["phone"] as? String,
            let company = json["company"] as? [String:AnyObject],
            let address = json["address"] as? [String:AnyObject]

            else {
                return nil
        }

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
        let predicate = NSPredicate(format: "contactID == %d", contactID)
        
        fetchRequest.predicate = predicate
        
        var fetchedContacts: [Contact]!
        context.performAndWait() {
            fetchedContacts = try! context.fetch(fetchRequest) as! [Contact]
        }
        var fetchedDetails: [Detail]!
        context.performAndWait() {
            fetchedDetails = try! context.fetch(fetchRequest) as! [Detail]
        }
        
        if fetchedContacts.count > 0 &&  fetchedDetails.count > 0{
            return fetchedContacts.first
        }
        var detail: Detail!
        context.performAndWait({ () -> Void in
            detail = NSEntityDescription.insertNewObject(forEntityName: "Detail",
                into: context) as! Detail
            
            detail.address = address
            detail.company = company
            detail.username = userName
            detail.website = website
            detail.phone = phone
        })
        var contact: Contact!
        context.performAndWait({ () -> Void in
            contact = NSEntityDescription.insertNewObject(forEntityName: "Contact",
                into: context) as! Contact
            contact.contactID = contactID
            contact.fullName = fullName
            contact.emailAddress = emailAddress
            contact.details=NSSet(objects: detail)
        })
        return contact
    }
}
