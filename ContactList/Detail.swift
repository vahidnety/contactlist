//
//  Detail.swift
//  ContactList
//
//  Created by Vahid on 18/07/2016.
//  Copyright © 2016 Vahid. All rights reserved.
//

import Foundation
import CoreData


class Detail: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    override func awakeFromInsert() {
        super.awakeFromInsert()
        
        // Give the properties their initial values
        phone = ""
        username = ""
        website = ""
        address = nil
        company = nil
        
    }

}
