//
//  DirectionsViewController.swift
//  Thrive Community Church
//
//  Created by Wyatt Baggett on 6/22/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import UIKit
import MapKit

class DirectionsViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var directionsMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        directionsMapView.delegate = self
        cameraSetup()
        regionSetup()
        
        // Dropping Pin
        let dropPin = MKPointAnnotation()
        let thriveLocation = CLLocationCoordinate2DMake(26.448174, -81.816173)
        dropPin.coordinate = thriveLocation
        dropPin.title = "Thrive Community Church"
        dropPin.subtitle = "20041 S. Tamiami Trail #1, Estero, FL, 33928"
        directionsMapView.addAnnotation(dropPin)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // initial viewDidLoad settings
    private func cameraSetup() {
        directionsMapView.camera.altitude = 9000
        directionsMapView.camera.pitch = 0
        directionsMapView.camera.heading = 0
    }
    
    private func regionSetup() {
        let region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(26.448174, -81.816173), MKCoordinateSpanMake(0.05, 0.07))
        
        directionsMapView.setRegion(region, animated: true)
    }

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
                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            }
            else{
                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            }
        }
    }
    
    // Opens in APPLE MAPS
    @IBAction func findRoute(_ sender: AnyObject) {
        let url = URL(string: "http://maps.apple.com/?daddr=" +
            "Thrive+Community+Church&dirflg=d")
        
        if UIApplication.shared.canOpenURL(url!) {
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        }
        else {
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        }
    }
}
