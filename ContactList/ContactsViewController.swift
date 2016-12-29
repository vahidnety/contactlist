//
//  ContactsViewController.swift
//  ContactList
//
//  Created by Vahid on 14/07/2016.
//  Copyright © 2016 Vahid. All rights reserved.
//

import UIKit
import CoreData


class ContactsViewController: UITableViewController {
    
    var store: ContactStore!
    var contact: Contact!
    let contactsDataSource = ContactsDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = contactsDataSource
        self.tableView.delegate = self
        self.tableView.estimatedRowHeight = 60.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        NotificationCenter.default.addObserver(self, selector: #selector(ContactsViewController.reloadList(_:)),name:NSNotification.Name(rawValue: "load"), object: nil)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func reloadList(_ notification: Notification){
        //load data here
        let defaults: UserDefaults = UserDefaults.standard
        let aString = defaults.value(forKey: "Sort") as? String
        let sortType:Int? = Int(aString!)
        
        if sortType == 0 {
            self.ascending()
        }
        else
        {
            self.descending()
        }
    }

    
    //Ascending sort
    func ascending() {
        let sort: Bool = true
        store.fetchContactsWithSort(sort, contacts: self.contactsDataSource.contacts) {
            (contactsResult) -> Void in
            
            OperationQueue.main.addOperation() {
                switch contactsResult {
                case let .success(contacts):
                    print("Successfully ascending sorted \(contacts.count) contacts.")
                    self.contactsDataSource.contacts = contacts
                    self.tableView.reloadData()
                case let .failure(error):
                    self.contactsDataSource.contacts.removeAll()
                    print("Error fetching contacts: \(error)")
                }
            }
        }

    }
    
    //Descending sort
    func descending() {
        let sort: Bool = false
        store.fetchContactsWithSort(sort, contacts: self.contactsDataSource.contacts) {
            (contactsResult) -> Void in
            
            OperationQueue.main.addOperation() {
                switch contactsResult {
                case let .success(contacts):
                    print("Successfully descending sorted \(contacts.count) contacts.")
                    self.contactsDataSource.contacts = contacts
                    self.tableView.reloadData()
                case let .failure(error):
                    self.contactsDataSource.contacts.removeAll()
                    print("Error fetching contacts: \(error)")
                }
            }
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showDetails" {
            if let row = tableView.indexPathForSelectedRow?.row {
                let contact = self.contactsDataSource.contacts[row]
                let destinationVC = segue.destination as! DetailsViewController
                destinationVC.contact = contact
                destinationVC.detailDataSource.details = (contact.details as! Set<Detail>).first
                destinationVC.detail = (contact.details as! Set<Detail>).first
                
            }
        }
    }
}
