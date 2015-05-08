//
//  GuestSearchVC.swift
//  CabTrack2.1
//
//  Created by Jim Aven on 4/14/15.
//  Copyright (c) 2015 Jim Aven. All rights reserved.
//

import UIKit
import MapKit

class GuestSearchVC: UIViewController, CLLocationManagerDelegate {
    
    let user = PFUser.currentUser()
    
    var myPlace:PFObject!
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var resNameTextField: UITextField!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBtn.hidden = true
        self.cancelBtn.hidden = true
        
        let backBtn = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: "backBtnPressed:")
        backBtn.tintColor = UIColor.blackColor()
        backBtn.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Helvetica Neue", size: 15)!], forState: UIControlState.Normal)
        self.navigationItem.leftBarButtonItem = backBtn

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    
    //MARK: SeachView
    @IBAction func searchBtnPresed(sender: UIButton) {
        
        var name = self.resNameTextField.text
        let query = PFQuery(className: "OwnerPlaces")
        query.whereKey("name", equalTo: name)
        query.getFirstObjectInBackgroundWithBlock {
            
            object, error in
            if error != nil {
                
                println(error!.localizedDescription)
                
                var alert:UIAlertController = UIAlertController(title: "Oops",
                    message: "Unable to locate this place",
                    preferredStyle: UIAlertControllerStyle.Alert)
                
                let alertAction:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
                    
                })
                alert.addAction(alertAction)
                
                self.presentViewController(alert, animated:true, completion: nil)
            
            }
            else {
                
                if object != nil {
                    
                    self.myPlace = object!
                    var alert:UIAlertController = UIAlertController(title: "We've found it",
                        message: "Click OK to verify the location",
                        preferredStyle: UIAlertControllerStyle.Alert)
                    
                    let alertAction:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                        self.searchView.hidden = true
                        self.returnedPlace()
                        self.addBtn.hidden = false
                        self.cancelBtn.hidden = false
                    })
                    alert.addAction(alertAction)
                    
                    self.presentViewController(alert, animated:true, completion: nil)
                }
                
                else {
                    
                    var alert:UIAlertController = UIAlertController(title: "Oops",
                        message: "Unable to locate this place",
                        preferredStyle: UIAlertControllerStyle.Alert)
                    
                    let alertAction:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
                        
                    })
                    alert.addAction(alertAction)
                    
                    self.presentViewController(alert, animated:true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func cancelBtnPressed(sender: UIButton) {
        self.searchView.hidden = false
        self.myPlace = nil
        self.viewDidLoad()
    }
    @IBAction func addBtnPressed(sender: UIButton) {
        
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
                    self.navigationController?.popToRootViewControllerAnimated(true)
                })
                
                alert.addAction(alertAction)
                self.presentViewController(alert, animated:true, completion: nil)
                
                //Query and update tables
                fetchUserOwnerPlaces()
                
            }
            
        })
    }
    
   func returnedPlace() {
        
        var latitude = self.myPlace.valueForKey("location")?.latitude
        var longitude = self.myPlace.valueForKey("location")?.longitude
        
        // set map view
        
        let location = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        let span = MKCoordinateSpanMake(0.25, 0.25)
        let region = MKCoordinateRegionMake(location, span)
        self.mapView.setRegion(region, animated: true)
        
        // Drop pin
        
        let annotation = MKPointAnnotation()
        annotation.title = myPlace.valueForKey("name") as! String
        annotation.coordinate = location
        self.mapView.addAnnotation(annotation)
     }
    
    func backBtnPressed(button:UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
