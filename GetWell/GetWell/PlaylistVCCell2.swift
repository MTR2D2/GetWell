//
//  PlaylistVCCell2.swift
//  GetWell
//
//  Created by Michael Reynolds on 1/12/16.
//  Copyright © 2016 GetWell. All rights reserved.
//

class PlaylistVCCell2: UITableViewCell
{
    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var meditationImage: UIImageView!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var imageOverlayView: UIView!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
//    @IBAction func startRecording(sender: UIButton!)
//    {
//        
//    }
    
}
