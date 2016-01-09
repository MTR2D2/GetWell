//
////
////  ViewController.swift
////  TableViewChecklist
////
////  Created by Michael Reynolds on 12/18/15.
////  Copyright © 2015 Michael Reynolds. All rights reserved.
////
//
//import UIKit
//
//class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
//    
//{
//    
//    @IBOutlet weak var tv: UITableView!
//    @IBOutlet weak var plus: UIButton!
//    @IBOutlet weak var next: UIButton!
//    
//    
//    
//    var allToDos = ["Find your meditation spot", "Get comfortable", "Clear your mind"]
//    
//    var shownTodos = [String]()
//    
//    var currentItemIndex = 0
//    
//    
//    
//    var isDone: Bool?
//    
//    let checkImg = UIImage(named: "checked.png")
//    
//    let uncheckImg = UIImage(named: "unchecked.png")
//    
//    override func viewDidLoad()
//        
//    {
//        
//        super.viewDidLoad()
//        
//        next.hidden = true
//        
//        next.alpha = 0
//        
//        isDone = false
//        
//    }
//    
//    
//    
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
//        
//    {
//        
//        return shownTodos.count
//        
//    }
//    
//    
//    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
//        
//    {
//        
//        let cell = tableView.dequeueReusableCellWithIdentifier("aCell", forIndexPath: indexPath) as! TableViewCell
//        
//        
//        
//        let todo = shownTodos[indexPath.row]
//        
//        cell.todoDescription.text = todo
//        
//        
//        
//        switch cell.isDone
//            
//        {
//            
//        case true: cell.todoCheckbox.image = UIImage(named: "checked.png")
//            
//        case false: cell.todoCheckbox.image = UIImage(named: "unchecked.png")
//            
//        }
//        
//        
//        
//        return cell
//        
//    }
//    
//    
//    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
//        
//    {
//        
//        tableView.deselectRowAtIndexPath(indexPath, animated: true)
//        
//        
//        
//        let cell = tableView.visibleCells[indexPath.row] as! TableViewCell
//        
//        
//        
//        cell.isDone = !cell.isDone
//        
//        
//        
//        enableNextButtonWithAnimation()
//        
//        tableView.reloadData()
//        
//    }
//    
//    
//    
//    @IBAction func addButtonPressed(sender: UIButton!)
//        
//    {
//        
//        isDone = true
//        
//        
//        
//        let newTodo = allToDos[currentItemIndex]
//        
//        shownTodos.append(newTodo)
//        
//        
//        
//        let newItemIndexPath = NSIndexPath(forRow: currentItemIndex, inSection: 0)
//        
//        tv.insertRowsAtIndexPaths([newItemIndexPath], withRowAnimation: .Automatic)
//        
//        
//        
//        currentItemIndex += 1
//        
//        
//        
//        if currentItemIndex == 3
//            
//        {
//            
//            sender.enabled = false
//            
//        }
//        
//    }
//    
//    
//    
//    func enableNextButtonWithAnimation()
//        
//    {
//        
//        var count = 0
//        
//        let visibleCells = tv.visibleCells as! [TableViewCell]
//        
//        for cell in visibleCells
//            
//        {
//            
//            if cell.isDone
//                
//            {
//                
//                count++
//                
//            }
//            
//        }
//        
//        
//        
//        if count == 3
//            
//        {
//            
//            next.hidden = false
//            
//            let originalNextButtonY = next.frame.origin.y
//            
//            next.frame.origin.y += next.frame.size.height
//            
//            UIView.animateWithDuration(0.25, animations: { () -> Void in
//                
//                self.next.alpha = 1
//                
//                self.next.frame.origin.y = originalNextButtonY
//                
//                }) { (_) -> Void in
//                    
//                    //nothing
//                    
//            }
//            
//        }
//            
//        else  if next.hidden == false || next.alpha != 0
//            
//        {
//            
//            UIView.animateWithDuration(0.25, animations: { () -> Void in
//                
//                self.next.alpha = 0
//                
//                }, completion: { (_) -> Void in
//                    
//                    self.next.hidden = true
//                    
//            })
//            
//        }
//        
//    }
//    
//    
//    
//    
//    
//}
//
//
