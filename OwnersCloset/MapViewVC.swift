//
//  MapViewVC.swift
//  CabTrack2.1
//
//  Created by Jim Aven on 4/16/15.
//  Copyright (c) 2015 Jim Aven. All rights reserved.
//

import UIKit
import MapKit

class MapViewVC: UIViewController {

    @IBOutlet weak var resLocationView: MKMapView!
    
    var placeName = GuestDetialVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set mapView
        var latitude = mapCoord.0
        var longitude = mapCoord.1
        let location = CLLocationCoordinate2D(latitude:latitude, longitude:longitude)
        let span = MKCoordinateSpanMake(0.25, 0.25)
        let region = MKCoordinateRegionMake(location, span)
        self.resLocationView.setRegion(region, animated: true)
        
        //set pin
        let annotation = MKPointAnnotation()
        annotation.title = "\(self.placeName.name)"
        annotation.coordinate = location
        self.resLocationView.addAnnotation(annotation)
        
        
        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func backBtnPressed(sender: UIButton) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
