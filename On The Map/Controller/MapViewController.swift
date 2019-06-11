//
//  MapViewController.swift
//  On The Map
//
//  Created by Giordany Orellana on 2/21/19.
//  Copyright © 2019 Giordany Orellana. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        //Load Student Locations
        UdacityClient.getStudentLocations(completion: loadStudentLocationsHandler(results:error:))
    
    }
    
    //MARK: MAP PINS
    ////////////////
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
                print("URL pressed")
            }
        }
    }
    
    
    //MARK: BUTTONS
    ////////////////
    
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
    
    @IBAction func refreshLocations(_ sender: Any) {
        
        UdacityClient.getStudentLocations(completion: loadStudentLocationsHandler(results:error:))
        generateMap()
    }
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        UdacityClient.createLogout {
            print("Logged out")
        }
        UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: false, completion: nil)
    }
    
    //MARK: FUNKS
    ////////////////
    
    func generateMap () {
        
        var locations: [StudentLocationResponse] = []
        
        let locationsVar = UdacityStudentModel.locations
        
        locations = locationsVar
        
        print("Outside closure: \(locationsVar)")
        //locations = getLocations()
        setLoggingIn(true)
        
        var annotations = [MKPointAnnotation]()
        
        for dictionary in locations {
            
            if (dictionary.latitude != nil) && (dictionary.longitude != nil) {
                
                let lat = CLLocationDegrees(dictionary.latitude as! Double)
                
                let long = CLLocationDegrees(dictionary.longitude as! Double)
                
                // The lat and long are used to create a CLLocationCoordinates2D instance.
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                
                let first = dictionary.firstName ?? "Unknown."
                let last = dictionary.lastName ?? "Unknown"
                let mediaURL = dictionary.mediaURL ?? "Unknown"
                
                // Here we create the annotation and set its coordiate, title, and subtitle properties
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "\(first) \(last)"
                annotation.subtitle = mediaURL
                
                // Finally we place the annotation in an array of annotations.
                annotations.append(annotation)
            } else {
                print("Coordinates not found.")
            }
        }
        setLoggingIn(false)
        self.mapView.addAnnotations(annotations)
    }
    
    func setLoggingIn(_ loggingIn: Bool) {
        if loggingIn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
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
            generateMap()
        }
    }
}
