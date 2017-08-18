//
//  DirectionsViewController.swift
//  Thrive Community Church
//
//  Created by Wyatt Baggett on 6/22/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class DirectionsViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var directionsMapView: MKMapView!
    let locationManager = CLLocationManager()
    let geoCoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        directionsMapView.delegate = self
        
        // Locating User in the world to referance directions
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.directionsMapView.delegate = self
        
        cameraSetup()
        regionSetup()
        
        let thriveLocation = CLLocationCoordinate2DMake(26.448174, -81.816173)
        
        // Dropping Pin
        let dropPin = MKPointAnnotation()
        dropPin.coordinate = thriveLocation
        dropPin.title = "Thrive Community Church"
        dropPin.subtitle = "20041 S. Tamiami Trail #1, Estero, FL, 33928"
        directionsMapView.addAnnotation(dropPin)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//SETTING UP MAP VIEW ----------------------------------------------------------
    private func cameraSetup() {
        //initial viewDidLoad settings
        directionsMapView.camera.altitude = 9000
        directionsMapView.camera.pitch = 0
        directionsMapView.camera.heading = 0
    }
    
    private func regionSetup() {
        
        let region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(26.448174, -81.816173), MKCoordinateSpanMake(0.05, 0.07))
        
        directionsMapView.setRegion(region, animated: true)
    }

//BUTTONS-----------------------------------------------------------------------
    @IBAction func showTraffic(_ sender: AnyObject) {
        
        directionsMapView.showsTraffic = !directionsMapView.showsTraffic
        
        // Will always return true because deployment target is > 9.0
        if #available(iOS 9.0, *) {
            if directionsMapView.showsTraffic == true {
                sender.setTitle("Hide Traffic", for: UIControlState())
            }
            else {
                sender.setTitle("Show Traffic", for: UIControlState())
            }
        } else {
            // Open in Apple Maps anyways
            
            let url = URL(string: "http://maps.apple.com/?daddr=" +
                "Thrive+Community+Church&dirflg=d")
            
            if UIApplication.shared.canOpenURL(url!){
                UIApplication.shared.openURL(url!)
            }
            else{
                UIApplication.shared.openURL(url!)
            }
        }
    }
    
    /*
     Segue to users location - no matter where they are in the world
     It might also beuseful if it would show users location and the Church in the same
     view
     */
    @IBAction func getLocation(_ sender: AnyObject) {
        
        directionsMapView.showsUserLocation = !directionsMapView.showsUserLocation
        
        if directionsMapView.showsUserLocation == true {
            directionsMapView.showsUserLocation = true
            directionsMapView.camera.altitude = 60000
            print("Displaying Location")
        }
        else {
            directionsMapView.showsUserLocation = false
            print("NOT Displaying Location")
        }
    }
    
// Opens in APPLE MAPS
    @IBAction func findRoute(_ sender: AnyObject) {
        
        let url = URL(string: "http://maps.apple.com/?daddr=" +
            "Thrive+Community+Church&dirflg=d")
        
            if UIApplication.shared.canOpenURL(url!){
                     UIApplication.shared.openURL(url!)
        }
        else{
            UIApplication.shared.openURL(url!)
        }
    }
//BUTTONS ----------------------------------------------------------------------

}
