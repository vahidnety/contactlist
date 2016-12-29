//
//  ContactsDataSource.swift
//  ContactList
//
//  Created by Vahid on 14/07/2016.
//  Copyright © 2016 Vahid. All rights reserved.
//

import UIKit
import CoreData

class ContactsDataSource: NSObject, UITableViewDataSource {
    
    var contacts: [Contact] = []

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return contacts.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCellReuseIdentifier",
                                                               for: indexPath) as! ContactCell
        let contact = contacts[indexPath.row]
        cell.updateWithContact(contact)
        return cell
    }
}
