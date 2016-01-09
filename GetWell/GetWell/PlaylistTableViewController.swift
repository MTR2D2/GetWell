//
//  PlaylistTableViewController.swift
//  FinalGetWell2
//
//  Created by Michael Reynolds on 1/4/16.
//  Copyright © 2016 Keron. All rights reserved.
//

import UIKit


class PlaylistTableViewController: UITableViewController
{
    var songs = Array<Song>()
    
    var parent: MediaPlayerViewController?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //        tableView.separatorColor = UIColor.whiteColor()
        tableView.separatorStyle = .None
        
        //        loadSongs()
        
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //         self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }
    override func viewWillAppear(animated: Bool) {
        animateTable()
        if timerCount%2 == 1
        {
            parent?.togglePlayback(true)
        }
    }
    
    
    func animateTable() {
        tableView.reloadData()
        
        let cells = tableView.visibleCells
        let tableHeight: CGFloat = tableView.bounds.size.height
        
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransformMakeTranslation(0, tableHeight)
        }
        
        var index = 0
        
        for a in cells {
            let cell: UITableViewCell = a as UITableViewCell
            UIView.animateWithDuration(1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
                cell.transform = CGAffineTransformMakeTranslation(0, 0);
                }, completion: nil)
            
            index += 1
        }
    }
    
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return songs.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("PlaylistModalViewCell", forIndexPath: indexPath) as! PlaylistTableViewCell
        
        let aSong = songs[indexPath.row]
        cell.meditationImage.image = UIImage(named: aSong.albumArtworkName)
        cell.songTitle.text = aSong.title
        //        cell.detailTextLabel?.text = aSong.artist
        
        return cell
    }
    
    override func tableView(tableview: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableview.deselectRowAtIndexPath(indexPath, animated: true)
        
        //        timerCount = timerCount + 1
        
        let selectedSong = songs[indexPath.row]
        parent?.song = selectedSong
        parent?.currentSong = selectedSong
        parent?.loadCurrentSong()
        //        parent?.player.play()
        //        parent?.startTimer()
        
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath)
    {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! PlaylistTableViewCell
        
        UIView.animateWithDuration(0.5) { () -> Void in
            cell.imageOverlayView.alpha = 0.3
        }
        //        cell.backgroundView = aSong.albumArtworkName
    }
    
    override func tableView(tableView: UITableView, didUnhighlightRowAtIndexPath indexPath: NSIndexPath)
    {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! PlaylistTableViewCell
        
        UIView.animateWithDuration(0.25) { () -> Void in
            cell.imageOverlayView.alpha = 1.0
        }
    }
    
    @IBAction func dismissPressed(sender: UIButton!)
    {
        dismissViewControllerAnimated(true, completion: nil)
        if timerCount%2 == 1
        {
            parent?.togglePlayback(true)
        }
    }
    
    //    // Override to support conditional editing of the table view.
    //    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    //        // Return false if you do not want the specified item to be editable.
    //        return false
    //    }
    //
    //
    //    /*
    //    // Override to support editing the table view.
    //    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    //        if editingStyle == .Delete {
    //            // Delete the row from the data source
    //            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    //        } else if editingStyle == .Insert {
    //            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    //        }
    //    }
    //    */
    //
    //
    //    // Override to support rearranging the table view.
    //    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath)
    //    {
    //
    //    }
    //
    //
    //    /*
    //    // Override to support conditional rearranging of the table view.
    //    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    //        // Return false if you do not want the item to be re-orderable.
    //        return true
    //    }
    //    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    // Private Functions
    
    //    private func loadSongs()
    //    {
    //        do
    //        {
    //            let filePath = NSBundle.mainBundle().pathForResource("Songs", ofType: "json")
    //            let dataFromFile = NSData(contentsOfFile: filePath!)
    //            let songData: NSArray! = try NSJSONSerialization.JSONObjectWithData(dataFromFile!, options: []) as! [NSDictionary]
    //            for songDictionary in songData
    //            {
    //                //                let aSong = Song(songDictionary: songDictionary as! NSDictionary)
    //                let song = Song(dictionary: songDictionary as! NSDictionary)
    //
    //                songs.append(song)
    //            }
    //            songs.sortInPlace({ $0.title < $1.title})
    //            //            songs.sortInPlace({ $0.artist < $1.artist})
    //
    //        }
    //        catch let error as NSError
    //        {
    //            print(error)
    //        }
    //    }
    
}
