//
//  AddLocationViewController.swift
//  On The Map
//
//  Created by Giordany Orellana on 2/24/19.
//  Copyright © 2019 Giordany Orellana. All rights reserved.
//

import UIKit

class AddLocationViewController: UIViewController {
    
    
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var urlLinkTextField: UITextField!
    
    @IBAction func findLocationButton(_ sender: Any) {
        
        if (locationTextField.text?.isEmpty)! {
            
            let alert = UIAlertController(title: "Error", message: "Please enter a valid location, like a city, state, or country.", preferredStyle: UIAlertController.Style.alert)
            
            // add the actions (buttons)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: { action in
                alert.dismiss(animated: false, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
            
        } else {
            FindLocationViewController.searchText = locationTextField.text ?? "Unknown"
        }
        
        if urlLinkTextField.text!.isValidURL {
            FindLocationViewController.mediaURLlink = urlLinkTextField.text!
        } else {
            let alert = UIAlertController(title: "Error", message: "Please enter a valid URL, for example http://www.udacity.com", preferredStyle: UIAlertController.Style.alert)
            
            // add the actions (buttons)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: { action in
               alert.dismiss(animated: false, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
        FindLocationViewController.mediaURLlink = urlLinkTextField.text ?? "www.udacity.com"
        
        self.performSegue(withIdentifier: "presentFindLocation", sender: nil)
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        self.performSegue(withIdentifier: "showMap", sender: nil)
    }
    
    static var studentInfoAlreadyPostedOnline = false

}

extension String {
    
    // Found for use from Stack Overflow
    
    var isValidURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.endIndex.encodedOffset)) {
            // it is a link, if the match covers the whole string
            return match.range.length == self.endIndex.encodedOffset
        } else {
            return false
        }
    }
}
