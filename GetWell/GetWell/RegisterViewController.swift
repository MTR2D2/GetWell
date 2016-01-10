//
//  RegisterViewController.swift
//  FinalGetWell2
//
//  Created by Elizabeth Yeh on 12/17/15.
//  Copyright © 2015 Keron. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController
{

    
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!

    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func userCanRegister() -> Bool
    {
        if usernameTextField.text != "" && passwordTextField.text != ""
        {
            return true
        }
        return false
    }
    
    @IBAction func createAccountTapped(sender: UIButton)
    {
        if userCanRegister()
        {
            let user = PFUser()
            user.username = usernameTextField.text!
            user.password = passwordTextField.text!
            
            user.signUpInBackgroundWithBlock {
                (succeeded: Bool, error: NSError?) -> Void in
                if !succeeded
                {
                    print(error?.localizedDescription)
                    self.errorMessageLabel.text = "Username Already Taken"

                }
                else
                {
                    self.navigationController?.popToRootViewControllerAnimated(true)
                }
            }
        }
    }


}
