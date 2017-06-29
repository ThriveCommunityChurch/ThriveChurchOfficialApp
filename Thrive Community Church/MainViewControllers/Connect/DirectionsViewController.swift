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
    
//    @IBOutlet var zoomIn: UIButton!
//    @IBOutlet var zoomOut: UIButton!
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
        
        // Droping Pin
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
 
/*  --------------Segmented control for Map Type -------------------------------
     @IBAction func segmentControlChanged(sender: AnyObject) {
        
        switch sender.selectedSegmentIndex {
        case 1:
            directionsMapView.mapType = MKMapType.SatelliteFlyover
            cameraSetup()
            print("Loaded Sateillite")
            break
            
        case 2:
            directionsMapView.mapType = MKMapType.HybridFlyover
            cameraSetup()
            print("Loaded Hybrid")
            break
            
        default:
            directionsMapView.mapType = MKMapType.Standard
            cameraSetup()
            print("Loaded the Maps")
            break
        }
    }
 */
    
    @IBAction func showTraffic(_ sender: AnyObject) {
        
        if #available(iOS 9.0, *) {
            directionsMapView.showsTraffic = !directionsMapView.showsTraffic
        } else {
            // Fallback on earlier versions
            
            print("Cannot use Traffic - user does not have iOS 9... Prepare to" +
            "open in Apple Maps")
        }
        
        if #available(iOS 9.0, *) {
            if directionsMapView.showsTraffic == true {
                sender.setTitle("Hide Traffic", for: UIControlState())
            }
            else {
                sender.setTitle("Show Traffic", for: UIControlState())
            }
        } else {
            // Open in Apple Maps anyways
            
            let url = URL(string: "http://maps.apple.com/?daddr=Thrive+Community+Church&dirflg=d")
            
            if UIApplication.shared.canOpenURL(url!){
                UIApplication.shared.openURL(url!)
            }
            else{
                UIApplication.shared.openURL(url!)
            }
        }
    }
    
/*  COMPASS FEATURE IF WANTED --------------------------------------------------
    @IBAction func showCompass(sender: AnyObject) {
        
        directionsMapView.showsCompass = !directionsMapView.showsCompass
        
        if directionsMapView.showsCompass == true {
            sender.setTitle("Hide Compass", forState: UIControlState.Normal)
        }
        else {
            sender.setTitle("Show Compass", forState: UIControlState.Normal)
        }
    }
    
*/
    @IBAction func getLocation(_ sender: AnyObject){
        
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
        
        let url = URL(string: "http://maps.apple.com/?daddr=Thrive+Community+Church&dirflg=d")
        
            if UIApplication.shared.canOpenURL(url!){
                     UIApplication.shared.openURL(url!)
        }
        else{
            UIApplication.shared.openURL(url!)
        }
    }
    
    //declairing variable for zoom - if Wanted----------------------------------
    //var zoom = 0
    
//    @IBAction func zoomIn(sender: AnyObject) {
//        // Zooms the view in slightly
//        directionsMapView.camera.altitude = directionsMapView.camera.altitude - 1000
//        print("Zoomed In")
//    }
//    
//    @IBAction func zoomOut(sender: AnyObject) {
//        // Zooms the view out slightly
//        directionsMapView.camera.altitude = directionsMapView.camera.altitude + 1000
//        print("Zoomed Out")
//    }
    
//BUTTONS ----------------------------------------------------------------------

}
