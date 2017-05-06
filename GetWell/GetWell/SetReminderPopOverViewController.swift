//
//  SetReminderPopOverViewController.swift
//  GetWell
//
//  Created by Michael Reynolds on 12/10/15.
//  Copyright © 2015 The Iron Yard. All rights reserved.
//

import UIKit

class SetReminderPopOverViewController: UIViewController
{
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var doneButton: UIButton!
    
    var delegate: DatePickerDelegate?

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
//    override func viewWillDisappear(animated: Bool)
//    {
//        super.viewWillDisappear(animated)
//        
//        delegate?.dateWasChosen(datePicker.date)
//        
//        let localNotification = UILocalNotification()
//                  localNotification.fireDate = datePicker.date
//                           print(NSDate())
//                          print(localNotification.fireDate)
//                   localNotification.timeZone = NSTimeZone.localTimeZone()
//                   localNotification.alertBody = "Time to Relax"
//                   localNotification.alertAction = "Open App"
//                   localNotification.soundName = UILocalNotificationDefaultSoundName
//        
//                UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
//    
//    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneWasPressed(_ sender: UIButton!)
    {
        delegate?.dateWasChosen(datePicker.date)
        
        let localNotification = UILocalNotification()
        localNotification.fireDate = datePicker.date
        print(Date())
        print(localNotification.fireDate)
        localNotification.timeZone = TimeZone.autoupdatingCurrent
        localNotification.alertBody = "Time to Relax"
        localNotification.alertAction = "Open App"
        localNotification.soundName = UILocalNotificationDefaultSoundName
        
        UIApplication.shared.scheduleLocalNotification(localNotification)
        
            dismiss(animated: true, completion: nil)

    }

}
