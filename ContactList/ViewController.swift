//
//  ViewController.swift
//  ContactList
//
//  Created by Vahid on 13/07/2016.
//  Copyright © 2016 Vahid. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class ViewController: UIViewController,UITableViewDelegate {
    var store: ContactStore!
    let contactsDataSource = ContactsDataSource()
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.spinner.startAnimating()
        self.label.isHidden=false
        
        self.startFetching()
    }
    func startFetching() {
        store.fetchContacts() {
            (contactsResult) -> Void in
            
            OperationQueue.main.addOperation() {
                switch contactsResult {
                case let .success(contacts):
                    print("Successfully found \(contacts.count) contacts.")
                    self.contactsDataSource.contacts = contacts
                    self.showTable()
                case let .failure(error):
                    self.contactsDataSource.contacts.removeAll()
                    print("Error fetching contacts: \(error)")
                    self.showAlert(error)
                }
            }
        }
    }
    func offlineFetching() {
        store.offlineContacts() {
            (contactsResult) -> Void in
            
            OperationQueue.main.addOperation() {
                switch contactsResult {
                case let .success(contacts):
                    print("Successfully found \(contacts.count) contacts.")
                    self.contactsDataSource.contacts = contacts
                    self.showTable()
                case let .failure(error):
                    self.contactsDataSource.contacts.removeAll()
                    print("Error fetching contacts: \(error)")
                    self.showAlert(error)
                }
            }
        }
    }

    func showAlert(_ error: Error) {
        DispatchQueue.main.async(execute: {
            let alertController = UIAlertController(
                title: "Error!",
                message: (error as NSError).localizedDescription,
                preferredStyle: UIAlertControllerStyle.alert
            )
            let tryAction = UIAlertAction(
            title: "Try again", style: UIAlertActionStyle.default) { (action) in
                self.startFetching()
            }
            let offlineAction = UIAlertAction(
            title: "Offline Access", style: UIAlertActionStyle.default) { (action) in
                self.offlineFetching()
            }

            alertController.addAction(tryAction)
            alertController.addAction(offlineAction)

            self.present(alertController, animated: true, completion: nil)
            return
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showTable()
    {
        DispatchQueue.main.async(execute: {
            self.spinner.stopAnimating()
            self.label.isHidden=true
            self.performSegue(withIdentifier: "showContacts", sender: self)
            return
        })
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showContacts" {
            let navController = segue.destination as! UINavigationController
            let contactController = navController.topViewController as! ContactsViewController
            contactController.store = store
            contactController.contactsDataSource.contacts = self.contactsDataSource.contacts
        }
    }
    
}

