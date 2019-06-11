//
//  ListViewController.swift
//  On The Map
//
//  Created by Giordany Orellana on 2/21/19.
//  Copyright © 2019 Giordany Orellana. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    

    @IBOutlet weak var tableView: UITableView!
    
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    @IBAction func reloadLocations(_ sender: Any) {
        
        UdacityClient.getStudentLocations(completion: loadStudentLocationsHandler(results:error:))
            
            self.tableView.reloadData()
        }

    @IBAction func logout(_ sender: Any) {
        UdacityClient.createLogout {
            print("Logged out")
        }
        dismiss(animated: true, completion: nil)
        
    }

    @IBAction func addLocationButton(_ sender: Any) {
        if AddLocationViewController.studentInfoAlreadyPostedOnline {
            // create the alert
            let alert = UIAlertController(title: "Location Already Posted", message: "You have already posted a student location. Would you like to Overwrite your current location?", preferredStyle: UIAlertController.Style.alert)
            
            // add the actions (buttons)
            alert.addAction(UIAlertAction(title: "Overwrite", style: UIAlertAction.Style.default, handler: { action in
                self.performSegue(withIdentifier: "presentAddLocation", sender: nil)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { action in
                alert.dismiss(animated: true, completion: nil)
            }))
            // show the alert
            self.present(alert, animated: true, completion: nil)
        } else {
            self.performSegue(withIdentifier: "presentAddLocation", sender: nil)
        }
    }
}

extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UdacityStudentModel.locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentLocation")!
        
        let location = UdacityStudentModel.locations[indexPath.row]
        
        if (location.firstName != nil) && (location.lastName != nil) {
             cell.textLabel?.text = "\(String(describing: location.firstName!))" + " " + "\(String(describing: location.lastName!))"
        } else {
            cell.textLabel?.text = "Unknown"
        }
        
        cell.imageView!.image = UIImage(named: "noun_Location_2234036" )
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        tableView.deselectRow(at: indexPath, animated: true)
        
        let urlString = UdacityStudentModel.locations[indexPath.row].mediaURL
        
        if let url = URL(string: urlString ?? "http://www.udacity.com"){
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func loadStudentLocationsHandler(results: [StudentLocationResponse], error: Error?) {
        
        if results.isEmpty {
            let alert = UIAlertController(title: "Error", message: "Unable to download student information. Check internet connectivity and press the refresh button.", preferredStyle: UIAlertController.Style.alert)
            // add the actions (buttons)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: { action in
                alert.dismiss(animated: true, completion: nil)
            }))
            // show the alert
            self.present(alert, animated: true, completion: nil)
        } else {
            UdacityStudentModel.locations = results
        }
    }
}
