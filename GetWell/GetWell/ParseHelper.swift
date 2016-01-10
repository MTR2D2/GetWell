//
//  ParseHelper.swift
//  GetWell
//
//  Created by Michael Reynolds on 1/10/16.
//  Copyright © 2016 GetWell. All rights reserved.
//

import UIKit

class ParseHelper: NSObject {
    class func uploadSoundFileToParse(filePath:String,nameOfFile:String) {
        do {
            //            let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
            //
            //            let audioFileURL = "\(documentsPath)/MyMemo.m4a"
            //
            let paths:String = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
            let getImagePath = "\(paths)/MyMemo.m4a"
            
            let dataOfFile:NSData = try NSData(contentsOfFile: getImagePath, options: .DataReadingMappedAlways)
            let dataToUpload : NSData = dataOfFile
            let soundFile = PFFile(name: nameOfFile, data: dataToUpload)
            let userSound = PFObject(className:"upload")
            userSound["name"] = nameOfFile
            userSound["user"] = ""
            userSound["sound"] = soundFile
            userSound.saveInBackgroundWithBlock({ (success, error) -> Void in
                print(error)
            })
        } catch {
            print(error)
        }
        
    }
    
}

