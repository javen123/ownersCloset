//
//  MapViewVC.swift
//  CabTrack2.1
//
//  Created by Jim Aven on 4/16/15.
//  Copyright (c) 2015 Jim Aven. All rights reserved.
//

import UIKit
import MapKit
import iAd

class MapViewVC: UIViewController, CLLocationManagerDelegate, ADBannerViewDelegate {
    
     private var bannerView = ADBannerView()
    
    @IBOutlet weak var resLocationView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadAds()
        //Set mapView
        var latitude = mapCoord.0
        var longitude = mapCoord.1
        let location = CLLocationCoordinate2D(latitude:latitude, longitude:longitude)
        let span = MKCoordinateSpanMake(0.25, 0.25)
        let region = MKCoordinateRegionMake(location, span)
        self.resLocationView.setRegion(region, animated: true)
        
        //set pin
        let annotation = MKPointAnnotation()
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

 //MARK: iAd Banner

    func loadAds () {
        
        self.bannerView.frame = CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50)
        self.bannerView.delegate = self
        self.bannerView.hidden = true
        view.addSubview(bannerView)
    }

    func bannerViewDidLoadAd(banner: ADBannerView!) {
        
        self.bannerView.hidden = false
    }
    
    func bannerViewActionShouldBegin(banner: ADBannerView!, willLeaveApplication willLeave: Bool) -> Bool {
        return willLeave
    }
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        self.bannerView.hidden = true
    }
}
   