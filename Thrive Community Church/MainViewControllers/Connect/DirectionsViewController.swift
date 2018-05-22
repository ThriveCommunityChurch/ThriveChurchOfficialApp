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
        dropPin.subtitle = "20041 S Tamiami Trl #1\nEstero, FL 33928"
        directionsMapView.addAnnotation(dropPin)
		directionsMapView.selectedAnnotations = [dropPin]
		directionsMapView.showsScale = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // initial viewDidLoad settings
    private func cameraSetup() {
        directionsMapView.camera.altitude = 11000
        directionsMapView.camera.pitch = 0
        directionsMapView.camera.heading = 0
    }
    
    private func regionSetup() {
        let region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(26.448174, -81.816173),
											MKCoordinateSpanMake(0.05, 0.07))
        
        directionsMapView.setRegion(region, animated: true)
    }

    @IBAction func showTraffic(_ sender: AnyObject) {
		
        directionsMapView.showsTraffic = !directionsMapView.showsTraffic
		
		if directionsMapView.showsTraffic == true {
			sender.setTitle("Hide Traffic", for: UIControlState())
		}
		else {
			sender.setTitle("Show Traffic", for: UIControlState())
		}
		
    }
    
    // Opens in Apple Maps
    @IBAction func findRoute(_ sender: AnyObject) {
		
		self.openUrlAnyways(link: "http://maps.apple.com/?daddr=" +
			"Thrive+Community+Church&dirflg=d")
    }
}
