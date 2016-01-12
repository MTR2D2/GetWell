//
//  MainViewController.swift
//  FinalGetWell2
//
//  Created by Elizabeth Yeh on 12/17/15.
//  Copyright © 2015 Keron. All rights reserved.
//

import UIKit

protocol DatePickerDelegate
{
    func dateWasChosen(date: NSDate)
}

protocol StepsListViewDelegate
{
    func stepsChecked(buttonTapped: Int)
}

protocol LoginViewControllerDismissDelegate
{
    func unwindFromLogin()
}

class MainViewController: UIViewController,UIPopoverPresentationControllerDelegate, DatePickerDelegate, UITableViewDataSource, UITableViewDelegate,LoginViewControllerDismissDelegate, UIGestureRecognizerDelegate
    
{

    //var checklist: Checklist?
    var timer: NSTimer?
    
    @IBOutlet weak var chkGuideImg: UIImageView!
    @IBOutlet weak var nextMeditation: UILabel!
    @IBOutlet weak var image: UIImage!
//    @IBOutlet var skipToMedia: UIButton!
    @IBOutlet weak var tv: UITableView!
    @IBOutlet weak var next: UIButton!
    @IBOutlet weak var loginButton: UIBarButtonItem!
    @IBOutlet weak var setReminderButton: UIBarButtonItem!
    @IBOutlet weak var tapImageGesture: UIGestureRecognizer!
    
    //var allToDos: [NSDictionary]
    
    var allToDos = ["Find your meditation spot", "Get comfortable", "Begin Deep Breathing", "Clear your mind"]
    var shownTodos = [String]()
    var currentItemIndex = 0
    var addTodoTimer: NSTimer?
    
    
    let checklistDict1: NSDictionary = [
        "checklist": "Find your meditation spot",
        "listImg" : "fingYourMeditationImg2",
        ]
    let checklistDict2: NSDictionary = [
        "checklist": "Get comfortable",
        "listImg" : "getComfortable",
    ]
    let checklistDict3: NSDictionary = [
        "checklist": "Begin Deep Breathing",
        "listImg" : "beginBreathing",
    ]
    let checklistDict4: NSDictionary = [
        "checklist": "Clear your mind",
        "listImg" : "clearMind",
    ]
    
    

    var isDone: Bool?
    let checkImg = UIImage(named: "cHheckeD.png")
    let uncheckImg = UIImage(named: "uUncheckeD.png")
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //allToDos = [checklistDict1, checklistDict2, checklistDict3, checklistDict4]
        
//        self.navigationController!.navigationBar.topItem!.title = "Cancel"
        
       // plus.hidden = true
       // plus.enabled = false
        next.hidden = true
        next.alpha = 0
        isDone = false
        
//        chkGuideImg.addGestureRecognizer(tapImageGesture)
        
//        if PFUser.currentUser() == nil
//        {
//                   performSegueWithIdentifier(<#T##identifier: String##String#>, sender: <#T##AnyObject?#>)
//        }
        
        let addInterval: NSTimeInterval = 0.75
        addTodoTimer = NSTimer.scheduledTimerWithTimeInterval(addInterval, target: self, selector: "addTodo", userInfo: nil, repeats: true)
    }
    
    func addTodo()
    {
        if shownTodos.count != allToDos.count
        {
            let newTodo = allToDos[currentItemIndex]
            shownTodos.insert(newTodo, atIndex: currentItemIndex)
            
            let newItemIndexPath = NSIndexPath(forRow: currentItemIndex, inSection: 0)
            tv.insertRowsAtIndexPaths([newItemIndexPath], withRowAnimation: .Automatic)
            
            currentItemIndex++
        }
        else
        {
            if addTodoTimer != nil
            {
                addTodoTimer?.invalidate()
            }
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
      
    }

    // MARK: - Table View Data Source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        
    {
        return shownTodos.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("aCell", forIndexPath: indexPath) as! TableViewCell
        
        let todo = shownTodos[indexPath.row]
        
        cell.todoDescription.text = todo
        
        switch cell.isDone
            
        {
            
        case true: cell.todoCheckbox.image = UIImage(named: "cHheckeD.png")
            cell.backgroundColor = UIColor(red: 0.73, green: 0.031, blue: 0.91, alpha: 1)
            
        case false: cell.todoCheckbox.image = UIImage(named: "uUncheckeD.png")
            cell.backgroundColor = UIColor(red:0.64, green:0.027, blue:0.86, alpha:1.0)
            
        }
        
        return cell
        
    }
    
     func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
        
    {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let cell = tableView.visibleCells[indexPath.row] as! TableViewCell
        
        cell.isDone = !cell.isDone
        enableNextButtonWithAnimation()
        
        switch indexPath.row
        {
        case 0: chkGuideImg.image = UIImage(named: "findYourMeditationImg2")
        case 1: chkGuideImg.image = UIImage(named: "getComfortable")
        case 2: chkGuideImg.image = UIImage(named: "beginBreathing")
        case 3: chkGuideImg.image = UIImage(named: "clearMind")
        default: chkGuideImg.image = UIImage(named: "mainImage2")
        }
        
        tableView.reloadData()
        
    }
    
    @IBAction func addButtonPressed(sender: UIButton!)
        
    {
        isDone = true
        let newTodo = allToDos[currentItemIndex]
        shownTodos.insert(newTodo, atIndex: currentItemIndex)
     
        let newItemIndexPath = NSIndexPath(forRow: currentItemIndex, inSection: 0)
        tv.insertRowsAtIndexPaths([newItemIndexPath], withRowAnimation: .Automatic)
        
        currentItemIndex += 1
        if currentItemIndex == 4
            
        {
            sender.enabled = false
        }
        
    }
    
    
    func enableNextButtonWithAnimation()
        
    {
        var count = 0
        let visibleCells = tv.visibleCells as! [TableViewCell]
        for cell in visibleCells
        {
            if cell.isDone
                
            {
                count++
            }
            
        }
        
        if count == 4
            
        {
            next.hidden = false
            let originalNextButtonY = next.frame.origin.y
            next.frame.origin.y += next.frame.size.height
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                
                self.next.alpha = 1
                
                self.next.frame.origin.y = originalNextButtonY
                
                }) { (_) -> Void in
                    
                    //nothing
            }
        }
            
        else  if next.hidden == false || next.alpha != 0
            
        {
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                
                self.next.alpha = 0
                
                }, completion: { (_) -> Void in
                    
                    self.next.hidden = true
            })
        }
    }
    
    
    

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
//        let backItem = UIBarButtonItem()
//        backItem.title = "Cancel"
//        navigationItem.backBarButtonItem = backItem
//        backItem.tintColor = UIColor.whiteColor()
//        if segue.identifier == "ShowMediaSegue"
//        {
//            let mediaPlayerVC = segue.destinationViewController as! MediaPlayerViewController
//            mediaPlayerVC.delegate = self
//        }
        
        if segue.identifier == "SetReminderSegue"
        {
            let destVC = segue.destinationViewController as! SetReminderPopOverViewController
            destVC.popoverPresentationController?.delegate = self
            destVC.delegate = self
            destVC.preferredContentSize = CGSizeMake(410.0, 216.0)
           
        }
        if let loginVC = segue.destinationViewController as? LoginViewController
        {
            loginVC.dismissDelegate = self

        }
    }
    
    func unwindFromLogin()
    {
        navigationController?.popToRootViewControllerAnimated(true)
    }

    
    // MARK: - UIPopoverPresentationController Delegate
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle
    {
        return UIModalPresentationStyle.None
    }
    
    // MARK: DatePicker Delegate
    
    func dateWasChosen(date: NSDate)
    {
        nextMeditation.text = "Next session: \(dateFormat(date))"
        
        let localNotification = UILocalNotification()
        localNotification.fireDate = date
        print(NSDate())
        print(localNotification.fireDate)
        localNotification.timeZone = NSTimeZone.localTimeZone()
        localNotification.alertBody = "Time to Relax"
        localNotification.alertAction = "Open App"
        localNotification.soundName = UILocalNotificationDefaultSoundName
        
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    
    
    func dateFormat(x: NSDate) -> String
    {
        let formatter = NSDateFormatter()
        formatter.dateFormat = NSDateFormatter.dateFormatFromTemplate("MMM dd yyyy HH:mm", options: 0, locale: NSLocale.currentLocale())
        let formattedTime = formatter.stringFromDate(x).uppercaseString
        
        return String(formattedTime)
    }

    @IBAction func unwindToMainViewController(unwindSegue: UIStoryboardSegue)
    {
        dismissViewControllerAnimated(true, completion: nil)
    }


}
