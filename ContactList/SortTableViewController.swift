//
//  SortTableViewController.swift
//  ContactList
//
//  Created by Vahid on 20/07/2016.
//  Copyright © 2016 Vahid. All rights reserved.
//

import UIKit
import CoreData


class SortTableViewController: UITableViewController {
    var selectedIndex: Int = 0
    @IBAction func Done(_ sender: AnyObject) {
        let check = String(format: "%d",selectedIndex)
        UserDefaults.standard.set(check, forKey: "Sort")
        UserDefaults.standard.synchronize()
        NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.rowHeight = UITableViewAutomaticDimension

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    func resetChecks() {
        for i in (0..<self.tableView.numberOfSections) {
            for j in (0..<self.tableView.numberOfRows(inSection: i)) {
                if let cell = tableView.cellForRow(at: IndexPath(row: j, section: i)) {
                    cell.accessoryType = .none
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.resetChecks()
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        if let cell = self.tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == .none
            {
                selectedIndex=indexPath.row
                cell.accessoryType = .checkmark
            }
            else
            {
                cell.accessoryType = .none
            }
        }
    }
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        let defaults: UserDefaults = UserDefaults.standard
        let aString = defaults.value(forKey: "Sort") as? String
        let cellIndex:Int? = Int(aString!)
        if indexPath.row == cellIndex {
            selectedIndex=indexPath.row
            cell.accessoryType = .checkmark
        }
        else
        {
            cell.accessoryType = .none
        }
        
    }
    
}
