//
//  FindLocationViewController.swift
//  On The Map
//
//  Created by Giordany Orellana on 2/24/19.
//  Copyright © 2019 Giordany Orellana. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class FindLocationViewController: UIViewController, MKMapViewDelegate {
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    static var searchText = ""
    
    static var mediaURLlink = ""
    
    //Generate student info
    var studentInfo =  UserStudentInfo.init(uniqueKey: UdacityClient.objectId, firstName: "Luke", lastName: "Skywalker", mapString: "", mediaURL: FindLocationViewController.mediaURLlink, latitude: "0.0", longitude: "0.0")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        
        setLoggingIn(true)
        
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = FindLocationViewController.searchText
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        
        activeSearch.start { (response, error) in
            if response == nil {
                self.setLoggingIn(false)
                let alert = UIAlertController(title: "Unknown Location", message: "Maps wasn't able to find your location.", preferredStyle: UIAlertController.Style.alert)
                
                // add the actions (buttons)
                alert.addAction(UIAlertAction(title: "Go back to Add Location", style: UIAlertAction.Style.default, handler: { action in
                    self.performSegue(withIdentifier: "goBackToAddLocation", sender: nil)
                }))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
            } else {
                
                self.setLoggingIn(false)
                print (response!)
                
                let latitude = response?.boundingRegion.center.latitude
                let longitude = response?.boundingRegion.center.longitude
                
                
                self.studentInfo.mapString = response!.mapItems[0].placemark.title ?? ""
                self.studentInfo.longitude = String((response?.mapItems[0].placemark.location?.coordinate.longitude)!)
                self.studentInfo.latitude = String((response?.mapItems[0].placemark.location?.coordinate.latitude)!)
                
                //Create Annotation
                let annotation = MKPointAnnotation()
                annotation.title = FindLocationViewController.searchText.uppercased()
                annotation.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
                annotation.subtitle = self.studentInfo.mediaURL
                self.mapView.addAnnotation(annotation)
                
                let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
                let span = MKCoordinateSpan(latitudeDelta: (response?.boundingRegion.span.latitudeDelta)!, longitudeDelta: (response?.boundingRegion.span.longitudeDelta)!)
                let region = MKCoordinateRegion(center: coordinate, span: span)
                self.mapView.setRegion(region, animated: true)
            }
        }
        
        // MARK: - MKMapViewDelegate
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            
            let reuseId = "pin"
            
            var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
            
            if pinView == nil {
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                pinView!.canShowCallout = true
                pinView!.pinColor = .red
                pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            }
            else {
                pinView!.annotation = annotation
            }
            
            return pinView
        }
        // This delegate method is implemented to respond to taps. It opens the system browser
        // to the URL specified in the annotationViews subtitle property.
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            if control == view.rightCalloutAccessoryView {
                let app = UIApplication.shared
                if let toOpen = view.annotation?.subtitle! {
                    app.openURL(URL(string: toOpen)!)
                }
            }
        }
        
        
    }
    @IBAction func finishButton(_ sender: Any) {
        
        print("First Name: \(self.studentInfo.firstName)")
        print("Last Name: \(self.studentInfo.lastName)")
        print("Media URL: \(self.studentInfo.mediaURL)")
        print("Unique Key: \(self.studentInfo.uniqueKey)")
        print("Map String: \(String(describing: self.studentInfo.mapString))")
        print("Longitude: \(String(describing: self.studentInfo.longitude))")
        print("Latitude: \(String(describing: self.studentInfo.latitude))")
        print("Unique Key: \(String(describing: self.studentInfo.uniqueKey))")
        
        if AddLocationViewController.studentInfoAlreadyPostedOnline {
            
            UdacityClient.updateStudentLocation(studentUniqueKey: self.studentInfo.uniqueKey, firstName: self.studentInfo.firstName, lastName: self.studentInfo.lastName, mapString: self.studentInfo.mapString, mediaURL: self.studentInfo.mediaURL, latitude: self.studentInfo.latitude, longitude: self.studentInfo.longitude) { (response, error) in
                if response {
                    
                    let alert = UIAlertController(title: "Success", message: "Success Updating Student Location", preferredStyle: UIAlertController.Style.alert)
                    
                    // add the actions (buttons)
                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: { action in
                        self.performSegue(withIdentifier: "goBackToAddLocation", sender: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                } else {
                    let alert = UIAlertController(title: "Problem Posting Update", message: "\(error)", preferredStyle: UIAlertController.Style.alert)
                    
                    // add the actions (buttons)
                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: { action in
                        self.performSegue(withIdentifier: "goBackToAddLocation", sender: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
        } else {
            
            UdacityClient.postStudentLocation(studentUniqueKey: self.studentInfo.uniqueKey, firstName: self.studentInfo.firstName, lastName: self.studentInfo.lastName, mapString: self.studentInfo.mapString, mediaURL: self.studentInfo.mediaURL, latitude: self.studentInfo.latitude, longitude: self.studentInfo.longitude) { (response, error) in
                if response {
                    AddLocationViewController.studentInfoAlreadyPostedOnline = true
                    self.studentInfo.uniqueKey = UdacityClient.objectId
                    print("Success posting new student location.")
                    let alert = UIAlertController(title: "Success", message: "Your location was successfully posted.", preferredStyle: UIAlertController.Style.alert)
                    
                    // add the actions (buttons)
                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: { action in
                        self.performSegue(withIdentifier: "showMap", sender: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "Posting Failed", message: "\(String(describing: error))", preferredStyle: UIAlertController.Style.alert)
                    
                    // add the actions (buttons)
                    alert.addAction(UIAlertAction(title: "Go back to Add Location", style: UIAlertAction.Style.default, handler: { action in
                        self.performSegue(withIdentifier: "goBackToAddLocation", sender: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        
        
    }
    
    func setLoggingIn(_ loggingIn: Bool) {
        if loggingIn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
}
