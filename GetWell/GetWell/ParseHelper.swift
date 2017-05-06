//
//  ParseHelper.swift
//  GetWell
//
//  Created by Michael Reynolds on 1/10/16.
//  Copyright © 2016 GetWell. All rights reserved.
//

import UIKit

class ParseHelper: NSObject {
    class func uploadSoundFileToParse(_ filePath:String,nameOfFile:String) {
        do {
            //            let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
            //
            //            let audioFileURL = "\(documentsPath)/MyMemo.m4a"
            //
            let paths:String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
            let getImagePath = "\(paths)/MyMemo.m4a"
            
            let dataOfFile:Data = try Data(contentsOf: URL(fileURLWithPath: getImagePath), options: .alwaysMapped)
            let dataToUpload : Data = dataOfFile
            let soundFile = PFFile(name: nameOfFile, data: dataToUpload)
            let userSound = PFObject(className:"upload")
            userSound["name"] = nameOfFile
            userSound["user"] = ""
            userSound["sound"] = soundFile
            userSound.saveInBackground(block: { (success, error) -> Void in
                print(error)
            })
        } catch {
            print(error)
        }
        
    }
    
}

