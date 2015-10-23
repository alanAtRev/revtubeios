//
//  PlayListHeaderCell.swift
//  Revtube
//
//  Created by Alan Baker on 10/23/15.
//  Copyright © 2015 Alan Baker. All rights reserved.
//

import UIKit

class PlayListHeaderCell : UITableViewCell {
    
    @IBOutlet var headerTitleLabel: UILabel!
    
    func setTitle(title: String) {
        headerTitleLabel.text = title
    }
}
