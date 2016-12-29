//
//  ContactsDataSource.swift
//  ContactList
//
//  Created by Vahid on 19/07/2016.
//  Copyright © 2016 Vahid. All rights reserved.
//

import UIKit
import CoreData

class DetailDataSource: NSObject, UITableViewDataSource {
    
    var details: Detail!

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 5
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCellReuseIdentifier",
                                                               for: indexPath) as! DetailCell
        var cellContent: [String]?

        if indexPath.row == 0 {
            let username = String(format:"\n%@\n",(details.username)!)
            cellContent = [username,"USERNAME" ]
        }
        else if indexPath.row == 1 {
            let phone = String(format:"\n%@\n",(details.phone)!)
            cellContent = [phone,"PHONE"]
        }
        else if indexPath.row == 2 {
            let address = String(format:"\n%@ %@\n%@, %@\n" ,
                                 String(describing: details.address!["suite"]!),
                                 String(describing: details.address!["street"]!),
                                 String(describing: details.address!["city"]!),
                                 String(describing: details.address!["zipcode"]!))
            
                            cellContent = [address,"ADDRESS"]
        }
        else if indexPath.row == 3 {
            let website = String(format:"\n%@\n",(details.website)!)
            cellContent = [website,"WEBSITE"]
        }
        else if indexPath.row == 4 {
            let company = String(format:"\n%@\n%@\n%@\n" ,
                                 String(describing: details.company!["name"]!),
                                 String(describing: details.company!["catchPhrase"]!),
                                 String(describing: details.company!["bs"]!))
                            cellContent = [company,"COMPANY"]
        }
        
        cell.updateWithDetail(cellContent)

        return cell
    }
}
