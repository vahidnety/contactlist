//
//  Detail+CoreDataProperties.swift
//  ContactList
//
//  Created by Vahid on 18/07/2016.
//  Copyright © 2016 Vahid. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Detail {

    @NSManaged var address: [String: AnyObject]?
    @NSManaged var company: [String: AnyObject]?
    @NSManaged var phone: String?
    @NSManaged var username: String?
    @NSManaged var website: String?
    @NSManaged var contacts: NSSet?
    
}
