//
//  OwnerAddVC.swift
//  CabTrack2.1
//
//  Created by Jim Aven on 4/9/15.
//  Copyright (c) 2015 Jim Aven. All rights reserved.
//

import UIKit
import CoreLocation

class OwnerAddVC: UIViewController {
    
    
    //Vars for Place Struct
    
    var newResPass:String!
    var newResName:String!
    var newResLocation:PFGeoPoint!
    
    
    //Outlets
    @IBOutlet weak var checkNameView: UIView!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var ownPlaceNameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var zipcodeTextField: UITextField!
    @IBOutlet weak var enterPassTextField: UITextField!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.toolbar.hidden = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "toAddItemsSegue" {
            
            let addVC:OwnerAddItems = segue.destinationViewController as! OwnerAddItems
            addVC.newResPassword = self.newResPass
            addVC.newResNameUpload = self.newResName
            addVC.newResLocationUpload = self.newResLocation
        }
        
    }

    
    @IBAction func checkNameButtonPressed(sender: UIButton) {
        
        //check for name availability
        
        var name:String = ownPlaceNameTextField.text
        var predicate = NSPredicate(format: "name = %@", name)
        var query = PFQuery(className: "OwnerPlaces", predicate: predicate)
        var nameArray = [query.findObjects()]
        
        
        if let curArray = nameArray[0] {
            
            //Throw alert if name is taken
            
            if !curArray.isEmpty {
                
                var alert:UIAlertController = UIAlertController(title: "Name in use",
                    message: "",
                    preferredStyle: UIAlertControllerStyle.Alert)
                
                let alertAction:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                    
                })
                alert.addAction(alertAction)
                
                self.presentViewController(alert, animated:true, completion: {
                nameArray.removeAll(keepCapacity: false)
                
                })
            }
            else {
           
                var alert:UIAlertController = UIAlertController(title: "Name is available",
                    message: "",
                    preferredStyle: UIAlertControllerStyle.Alert)
                
                let alertAction:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                    
                })
                alert.addAction(alertAction)
                
                self.presentViewController(alert, animated:true, completion: {
                    
                    //update fields and allow new fields
                    self.newResName = name
                    self.checkNameView.hidden = true
                    self.addressView.hidden = false
                    
                })
            }
        }
    }
    @IBAction func createBtnPressed(sender: UIButton) {
        
        
        var password:String = self.enterPassTextField.text
        let address = self.addressTextField.text
        let zip = self.zipcodeTextField.text
        
        self.getLocationFromAddress(address, zipCode: zip)
        self.newResPass = password
    }
    
    // MARK: CLGeoLocator  helpers
    
    func getLocationFromAddress (address:String, zipCode:String) {
        
        let locator = CLGeocoder()
        locator.geocodeAddressString("\(address), \(zipCode)") {
            
            results, error in
            if error != nil {
                var alert:UIAlertController = UIAlertController(title: "Error",
                    message: "Address is not pulling up",
                    preferredStyle: UIAlertControllerStyle.Alert)
                
                let alertAction:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
                })
                alert.addAction(alertAction)
                
                self.presentViewController(alert, animated: true, completion: { () -> Void in
                    
                })
            }
            else {
                
                var alert:UIAlertController = UIAlertController(title: "Almost Done",
                    message: "Now its time to add the items you want your guests to update",
                    preferredStyle: UIAlertControllerStyle.Alert)
                
                let alertAction:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
                    
                    self.performSegueWithIdentifier("toAddItemsSegue", sender: self)
                    
                })
                alert.addAction(alertAction)
                
                self.presentViewController(alert, animated: true, completion:nil)

                self.newResLocation = self.cllocationToPFGeoPoint(results)
                
                
            }
        }
    }
    
    
    
    // PFGeoPointHelper
    
    func cllocationToPFGeoPoint (locale:[AnyObject]) -> PFGeoPoint {
        
        let placeMark = locale[0] as? CLPlacemark
        let latitude = placeMark?.location.coordinate.latitude
        let longitude = placeMark?.location.coordinate.longitude
        
        let point = PFGeoPoint(latitude: latitude!, longitude: longitude!)
        
        return point
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        self.view.endEditing(true)
        
    }
    
        
        
    
}



