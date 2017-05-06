//
//  MySavedAffirmationViewController.swift
//  GetWell
//
//  Created by Keron Williams on 1/12/16.
//  Copyright © 2016 GetWell. All rights reserved.
//

import UIKit

class MySavedAffirmationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate

{

    @IBOutlet weak var createAffirmation: UIButton!
    
    var dad: MediaPlayerVC2?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if timerCount%2 == 1
        {
            dad?.togglePlayback(true)
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if timerCount%2 == 1
        {
            dad?.togglePlayback(true)
        }
    }
    
    // MARK: - Table View Data Source
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        
    {
        return 10
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedAff", for: indexPath) as! MySavedAffirmationTableViewCell
        
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
