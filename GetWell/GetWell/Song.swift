//
//  Songs.swift
//  FinalGetWell2
//
//  Created by Elizabeth Yeh on 12/17/15.
//  Copyright © 2015 Keron. All rights reserved.
//

import Foundation
import AVFoundation

class Song
{
    
    let title: String
    let artist: String
    let filename: String
    let albumArtworkName: String
    
    let playerItem: AVPlayerItem
    
    //    init(title: String, artist: String, filename: String, albumArtwork: String)
    //    {
    //        self.title = title
    //        self.artist = artist
    //        self.filename = filename
    //        self.albumArtworkName = albumArtwork
    //        self.playerItem = AVPlayerItem(URL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(filename, ofType: "mp3")!))
    //    }
    
    init(dictionary: NSDictionary)
    {
        let title = dictionary["title"] as! String
        let artist = dictionary["artist"] as! String
        let filename = dictionary ["filename"] as! String
        //            let albumArtwork = ["albumArtwork"] as! String
        let albumArtwork = dictionary["albumArtwork"] as? String ?? ""
        
        self.title = title
        self.artist = artist
        self.filename = filename
        self.albumArtworkName = albumArtwork
        self.playerItem = AVPlayerItem(url: URL(fileURLWithPath: Bundle.main.path(forResource: filename, ofType: "mp3")!))
    }
    
}
