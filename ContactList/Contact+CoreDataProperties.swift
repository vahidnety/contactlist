//
//  Contact+CoreDataProperties.swift
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

extension Contact {

    @NSManaged var contactID: Int32
    @NSManaged var emailAddress: String?
    @NSManaged var fullName: String?
    @NSManaged var details: NSSet?

}
