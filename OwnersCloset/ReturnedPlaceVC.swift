//
//  ReturnedPlaceVC.swift
//  CabTrack2.1
//
//  Created by Jim Aven on 4/14/15.
//  Copyright (c) 2015 Jim Aven. All rights reserved.
//

import UIKit
import MapKit

class ReturnedPlaceVC: UIViewController, CLLocationManagerDelegate {
    
    let user = PFUser.currentUser()
    
    var myPlace:PFObject!
    
    @IBOutlet weak var resNameLabel: UILabel!
    @IBOutlet weak var resLocationView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var latitude = self.myPlace.valueForKey("location")?.latitude
        var longitude = self.myPlace.valueForKey("location")?.longitude
        
        // set map view
        
        let location = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        let span = MKCoordinateSpanMake(0.25, 0.25)
        let region = MKCoordinateRegionMake(location, span)
        self.resLocationView.setRegion(region, animated: true)
        
        // Drop pin
        
        let annotation = MKPointAnnotation()
        annotation.title = myPlace.valueForKey("name") as! String
        annotation.coordinate = location
        self.resLocationView.addAnnotation(annotation)
        
        self.resNameLabel.text = self.myPlace.valueForKey("name") as? String
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backBtPressed(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    @IBAction func addToMyPlacesBtPressed(sender: UIButton) {
        
        //fetch current object from Parse
        
        let name = myPlace.valueForKey("name") as! String
        let id = myPlace.objectId!
        let query = PFQuery(className: "OwnerPlaces")
        query.getObjectInBackgroundWithId(id, block: {
            object, error in
            
            if error != nil {
                
                var alert:UIAlertController = UIAlertController(title: "Error",
                    message: "\(error!.localizedDescription)",
                    preferredStyle: UIAlertControllerStyle.Alert)
                
                let alertAction:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
                    
                })
                alert.addAction(alertAction)
                
                self.presentViewController(alert, animated:true, completion: nil)
            }
            else {
                
                //add place to user guest relation
                
                var relation = self.user!.relationForKey("myGuestPlaces")
                relation.addObject(object!)
                self.user?.saveInBackground()
                
                var alert:UIAlertController = UIAlertController(title: "Congratulations. \(name) has been added to your Places",
                    message: "",
                    preferredStyle: UIAlertControllerStyle.Alert)
                
                let alertAction:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                    self.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(false, completion: nil)
                })
                
                alert.addAction(alertAction)
                self.presentViewController(alert, animated:true, completion: nil)
                
                //Query and update tables
                fetchUserOwnerPlaces()
            }
        })
    }
}
