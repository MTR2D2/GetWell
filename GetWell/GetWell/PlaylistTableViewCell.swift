//
//  PlaylistTableViewCell.swift
//  FinalGetWell2
//
//  Created by Michael Reynolds on 1/4/16.
//  Copyright © 2016 Keron. All rights reserved.
//

class PlaylistTableViewCell: UITableViewCell
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
    
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func startRecording(_ sender: UIButton!)
    {
        
    }
    
}
