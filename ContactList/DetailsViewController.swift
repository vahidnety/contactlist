//
//  DetailsViewController.swift
//  ContactList
//
//  Created by Vahid on 18/07/2016.
//  Copyright © 2016 Vahid. All rights reserved.
//

import UIKit
import CoreData


class DetailsViewController: UIViewController,UITableViewDelegate {
    let coreDataStack = CoreDataStack()

    @IBOutlet var tableview: UITableView!
    var detail: Detail!
    let detailDataSource = DetailDataSource()
    
    var contact: Contact! {
        didSet {
            navigationItem.title = contact.fullName
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.dataSource = detailDataSource
        self.tableview.delegate = self
        self.tableview.estimatedRowHeight = 60.0
        self.tableview.rowHeight = UITableViewAutomaticDimension
   }
}
