//
//  ViewController.swift
//  On The Map
//
//  Created by Giordany Orellana on 2/18/19.
//  Copyright © 2019 Giordany Orellana. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Subscribe to the keyboard notification, to allow the view to raise when necessary
        self.subscribeToKeyboardNotifications()

    }
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        unsubscribeFromKeyboardNotifications()
    }
    
    
    //MARK: KEYBOARD FUNCTIONS
    //////////////////////////
    
    @objc func subscribeToKeyboardNotifications() {
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        
        //shift view frame up for keyboard
        
        if passwordTextField.isFirstResponder || emailTextField.isFirstResponder {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        
        //reset view frame
        if passwordTextField.isFirstResponder || emailTextField.isFirstResponder {
            view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        //Gets the size of the keyboard
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    //MARK: BUTTONS
    //////////////////////////
    
    @IBAction func loginTapped(_ sender: Any) {
        
        if (emailTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)! {
            
            let alert = UIAlertController(title: "Login Failed", message: "Fields are empty. Please add in your email and/or password.", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: { action in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
            
        } else {
            
            let email = emailTextField.text?.removeWhitespace()
            
            let password = passwordTextField.text?.removeWhitespace()
            
            setLoggingIn(true)
            
            UdacityClient.login(username: email!, password: password!, completion: handleLoginResponse(success:error:))
            
        }
    }
    
    
    @IBAction func signUpButton(_ sender: UIButton) {
        if let requestUrl = NSURL(string: "https://auth.udacity.com/sign-up?next=https://classroom.udacity.com/authenticated&") {
            UIApplication.shared.openURL(requestUrl as URL)
        }
    }
    //MARK: BUTTONS
    //////////////////////////
    
    func handleLoginResponse(success: Bool, error: Error?) {
        print("working on login in")
        print(success)
        if success {
            setLoggingIn(false)
            self.performSegue(withIdentifier: "completeLogin", sender: nil)
            print("working on creating session")
        } else {
            setLoggingIn(false)
            print("Handle login error: \(String(describing: error?.localizedDescription))")
            let alert = UIAlertController(title: "Login Failed", message: "\(error?.localizedDescription)", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: { action in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func setLoggingIn(_ loggingIn: Bool) {
        if loggingIn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        
        emailTextField.isEnabled = !loggingIn
        passwordTextField.isEnabled = !loggingIn
        loginButton.isEnabled = !loggingIn
    }
}

extension String {
    
    // Found on stack overflow
    
    func replace(string:String, replacement:String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }
    
    func removeWhitespace() -> String {
        return self.replace(string: " ", replacement: "")
    }
}
