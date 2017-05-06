//
//  MainViewController.swift
//  FinalGetWell2
//
//  Created by Elizabeth Yeh on 12/17/15.
//  Copyright © 2015 Keron. All rights reserved.
//

import UIKit



protocol StepsListViewDelegate
{
    func stepsChecked(_ buttonTapped: Int)
}

protocol LoginViewControllerDismissDelegate
{
    func unwindFromLogin()
}

class MainViewController: UIViewController,UIPopoverPresentationControllerDelegate, UITableViewDataSource, UITableViewDelegate,LoginViewControllerDismissDelegate, UIGestureRecognizerDelegate, DatePickerDelegate
    
{
    
    //var checklist: Checklist?
    var timer: Timer?
    
    @IBOutlet weak var chkGuideImg: UIImageView!
    @IBOutlet weak var image: UIImage!
    //    @IBOutlet var skipToMedia: UIButton!
    @IBOutlet weak var tv: UITableView!
    @IBOutlet var next: UIButton!
    @IBOutlet weak var loginButton: UIBarButtonItem!
    @IBOutlet weak var setReminderButton: UIBarButtonItem!
    @IBOutlet weak var nextMeditation: UILabel!
    @IBOutlet weak var tapImageGesture: UIGestureRecognizer!
    
    //var allToDos: [NSDictionary]
    
    var allToDos = ["Find your meditation spot", "Get comfortable", "Begin Deep Breathing", "Clear your mind"]
    var shownTodos = [String]()
    var currentItemIndex = 0
    var addTodoTimer: Timer?
    
    
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
        next.isHidden = true
        next.alpha = 0
        isDone = false
        
        //        chkGuideImg.addGestureRecognizer(tapImageGesture)
        
        //        if PFUser.currentUser() == nil
        //        {
        //                   performSegueWithIdentifier(<#T##identifier: String##String#>, sender: <#T##AnyObject?#>)
        //        }
        
        let addInterval: TimeInterval = 0.75
        addTodoTimer = Timer.scheduledTimer(timeInterval: addInterval, target: self, selector: #selector(MainViewController.addTodo), userInfo: nil, repeats: true)
    }
    
    func addTodo()
    {
        if shownTodos.count != allToDos.count
        {
            let newTodo = allToDos[currentItemIndex]
            shownTodos.insert(newTodo, at: currentItemIndex)
            
            let newItemIndexPath = IndexPath(row: currentItemIndex, section: 0)
            tv.insertRows(at: [newItemIndexPath], with: .automatic)
            
            currentItemIndex += 1
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
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
    }
    
    // MARK: - Table View Data Source
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        
    {
        return shownTodos.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "aCell", for: indexPath) as! TableViewCell
        
        let todo = shownTodos[(indexPath as NSIndexPath).row]
        
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
        
    {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.visibleCells[(indexPath as NSIndexPath).row] as! TableViewCell
        
        cell.isDone = !cell.isDone
        enableNextButtonWithAnimation()
        
        switch (indexPath as NSIndexPath).row
        {
        case 0: chkGuideImg.image = UIImage(named: "findYourMeditationImg2")
        case 1: chkGuideImg.image = UIImage(named: "getComfortable")
        case 2: chkGuideImg.image = UIImage(named: "beginBreathing")
        case 3: chkGuideImg.image = UIImage(named: "clearMind")
        default: chkGuideImg.image = UIImage(named: "mainImage2")
        }
        
        tableView.reloadData()
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton!)
        
    {
        isDone = true
        let newTodo = allToDos[currentItemIndex]
        shownTodos.insert(newTodo, at: currentItemIndex)
        
        let newItemIndexPath = IndexPath(row: currentItemIndex, section: 0)
        tv.insertRows(at: [newItemIndexPath], with: .automatic)
        
        currentItemIndex += 1
        if currentItemIndex == 4
            
        {
            sender.isEnabled = false
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
                count += 1
            }
            
        }
        
        if count == 4
            
        {
            next.isHidden = false
            let originalNextButtonY = next.frame.origin.y
            next.frame.origin.y += next.frame.size.height
            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                
                self.next.alpha = 1
                
                self.next.frame.origin.y = originalNextButtonY
                
                }, completion: { (_) -> Void in
                    
                    //nothing
            }) 
        }
            
        else  if next.isHidden == false || next.alpha != 0
            
        {
            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                
                self.next.alpha = 0
                
                }, completion: { (_) -> Void in
                    
                    self.next.isHidden = true
            })
        }
    }
    
    
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
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
            let destVC = segue.destination as! SetReminderPopOverViewController
            destVC.popoverPresentationController?.delegate = self
            destVC.delegate = self
            destVC.preferredContentSize = CGSize(width: 410.0, height: 216.0)
            
        }
        //        if let loginVC = segue.destinationViewController as? LoginViewController
        //        {
        //            loginVC.dismissDelegate = self
        //
        //        }
    }
    
    func unwindFromLogin()
    {
        navigationController?.popToRootViewController(animated: true)
    }
    
    
    // MARK: - UIPopoverPresentationController Delegate
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle
    {
        return UIModalPresentationStyle.none
    }
    
    // MARK: DatePicker Delegate
    
    func dateWasChosen(_ date: Date)
    {
        nextMeditation.text = "Next session: \(dateFormat(date))"
        
        let localNotification = UILocalNotification()
        localNotification.fireDate = date
        print(Date())
        print(localNotification.fireDate)
        localNotification.timeZone = TimeZone.autoupdatingCurrent
        localNotification.alertBody = "Time to Relax"
        localNotification.alertAction = "Open App"
        localNotification.soundName = UILocalNotificationDefaultSoundName
        
        UIApplication.shared.scheduleLocalNotification(localNotification)
    }
    
    
    func dateFormat(_ x: Date) -> String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "MMM dd yyyy HH:mm", options: 0, locale: Locale.current)
        let formattedTime = formatter.string(from: x).uppercased()
        
        return String(formattedTime)
    }
    
    @IBAction func unwindToMainViewController(_ unwindSegue: UIStoryboardSegue)
    {
        dismiss(animated: true, completion: nil)
    }
    
    
}
