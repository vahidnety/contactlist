//
//  ContactCell.swift
//  ContactList
//
//  Created by Vahid on 19/07/2016.
//  Copyright © 2016 Vahid. All rights reserved.
//

import UIKit

class DetailCell: UITableViewCell {
    
    @IBOutlet weak var info: UILabel!
    @IBOutlet weak var content: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        updateWithDetail(nil)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        updateWithDetail(nil)
    }

    func updateWithDetail(_ detail: [String]?) {
        if let contactObj = detail {
            content.text = contactObj[0]
            info.text = contactObj[1]
        }
        else {
            content.text = nil
            info.text = nil
        }
    }
    
}
