//
//  GuestSearchVC.swift
//  CabTrack2.1
//
//  Created by Jim Aven on 4/14/15.
//  Copyright (c) 2015 Jim Aven. All rights reserved.
//

import UIKit

class GuestSearchVC: UIViewController {
    
    var returnedPlace:PFObject!

    @IBOutlet weak var resNameTextField: UITextField!
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toReturnPlaceSegue" {
            let returnVC:ReturnedPlaceVC = segue.destinationViewController as! ReturnedPlaceVC
            
            returnVC.myPlace = self.returnedPlace
        }
    }
    
    @IBAction func backBtnPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
   
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
                    
                    self.returnedPlace = object!
                    var alert:UIAlertController = UIAlertController(title: "We've found it",
                        message: "Click OK to verify the location",
                        preferredStyle: UIAlertControllerStyle.Alert)
                    
                    let alertAction:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                        self.performSegueWithIdentifier("toReturnPlaceSegue", sender: self)
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
    
    @IBAction func backBtPressed(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}