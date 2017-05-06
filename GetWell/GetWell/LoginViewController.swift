//
//  LoginViewController.swift
//  FinalGetWell2
//
//  Created by Elizabeth Yeh on 12/17/15.
//  Copyright © 2015 Keron. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController
{
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    
    var dismissDelegate: LoginViewControllerDismissDelegate?
    var sourceViewController: LoginViewController?
    var destinationViewController: MainViewController?

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Navigation
    
 
    func userCanSignIn() -> Bool
    {
        if usernameTextField.text != "" && passwordTextField.text != ""
        {
            return true
        }
        errorMessageLabel.text = "Enter Username and Password to Login"

        return false
    }
    


//    @IBAction func cancelPressed(sender: UIBarButtonItem)
//    {
//        dismissViewControllerAnimated(true, completion: nil)
//       self.navigationController?.performSegueWithIdentifier("unwindFromLogin", sender: self)
//    }



}
