//
//  AffirmationViewController.swift
//  GetWell
//
//  Created by Michael Reynolds on 1/12/16.
//  Copyright © 2016 GetWell. All rights reserved.
//

import UIKit

class AffirmationViewController: UIViewController {
    
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
    
    override func viewWillAppear(animated: Bool) {
        if timerCount%2 == 1
        {
            dad?.togglePlayback(true)
        }
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
