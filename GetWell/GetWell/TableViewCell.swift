//
//  TableViewCell.swift
//  FinalGetWell2
//
//  Created by Keron Williams on 12/18/15.
//  Copyright © 2015 Keron. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell
{
    
    @IBOutlet weak var todoDescription: UILabel!
    @IBOutlet weak var todoCheckbox: UIImageView!
    
    var isDone = false
    
}

