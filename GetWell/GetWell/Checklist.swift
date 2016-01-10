//
//  Checklist.swift
//  GetWell
//
//  Created by Keron Williams on 1/9/16.
//  Copyright © 2016 GetWell. All rights reserved.
//

import Foundation

class Checklist
{
    let checklist: String
    let listImg: String
    
    init(dictionary: NSDictionary)
    {
        let checklist = dictionary["checklist"] as! String
        let listImg = dictionary["listImg"] as? String ?? ""
        
        self.checklist = checklist
        self.listImg = listImg
        
    }
    
}

    


