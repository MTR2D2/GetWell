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
    

    @IBAction func signinTapped(sender: UIButton)
    {
        
        if userCanSignIn()
        {
            PFUser.logInWithUsernameInBackground(usernameTextField.text!, password: passwordTextField.text!) {
                (user: PFUser?, error: NSError?) -> Void in
                if user != nil
                {
                    print("login successful")
//       self.dismissDelegate?.unwindFromLogin()
//        self.navigationController?.performSegueWithIdentifier("unwindFromLogin", sender: self)
                    self.performSegueWithIdentifier("unwindFromLogin", sender: self)
//                    self.navigationController?.performSegueWithIdentifier("MediaPlayerViewController", sender: self)
                }
                else
                {
                    print(error?.localizedDescription)
                    self.errorMessageLabel.text = "Username and/or Password Do Not Match"
                }
                
            }
        }
    }
    
//    @IBAction func cancelPressed(sender: UIBarButtonItem)
//    {
//        dismissViewControllerAnimated(true, completion: nil)
//       self.navigationController?.performSegueWithIdentifier("unwindFromLogin", sender: self)
//    }



}
