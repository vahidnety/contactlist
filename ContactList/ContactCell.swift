//
//  ContactCell.swift
//  ContactList
//
//  Created by Vahid on 14/07/2016.
//  Copyright © 2016 Vahid. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {
    
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var email: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        updateWithContact(nil)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        updateWithContact(nil)
    }
    
    func updateWithContact(_ contact: Contact?) {
        if let contactObj = contact {
            fullName.text = contactObj.fullName
            email.text = contactObj.emailAddress
        }
        else {
            fullName.text = nil
            email.text = nil
        }
    }
    
}
