//
//  Contacts+CoreDataProperties.swift
//  ContactList
//
//  Created by Vahid on 14/07/2016.
//  Copyright © 2016 Vahid. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Contacts {

    @NSManaged var fullName: String?
    @NSManaged var emailAddress: String?
    @NSManaged var details: Details?

}
