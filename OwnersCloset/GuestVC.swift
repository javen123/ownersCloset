//
//  GuestVC.swift
//  CabTrack2.1
//
//  Created by Jim Aven on 4/9/15.
//  Copyright (c) 2015 Jim Aven. All rights reserved.
//

import UIKit
import iAd

class GuestVC: UIViewController, UITableViewDataSource, UITableViewDelegate, ADBannerViewDelegate {

 
    @IBOutlet weak var tableView: UITableView!
    
    private var bannerView = ADBannerView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         tableView.reloadData()
        
        self.loadAds()
        
        println(myGuestPlacesArray)
        
        
    }
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "toGuestDetailSegue" {
            
            let detailVC:GuestDetialVC = segue.destinationViewController as! GuestDetialVC
            let indexPath = self.tableView.indexPathForSelectedRow()
            let guestPlace:AnyObject = myGuestPlacesArray[indexPath!.row]
            detailVC.name = guestPlace.valueForKey("name") as! String
            detailVC.itemsDict = guestPlace.valueForKey("items") as! NSDictionary
            var latitude = guestPlace.valueForKey("location")?.latitude
            var longitude = guestPlace.valueForKey("location")?.longitude
            mapCoord = (latitude!, longitude!)
            }
        
    }
    
    //Buttons
    
    @IBAction func backBtnPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func addGestResBtnPressed(sender: UIButton) {
        self.performSegueWithIdentifier("toGuestSearchSegue", sender: self)
    }

   
    
    //MARK: TableViewDatasource
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:GuestVCCell = tableView.dequeueReusableCellWithIdentifier("cell") as! GuestVCCell
        let places:AnyObject = myGuestPlacesArray[indexPath.row]
        let name:String = places.valueForKey("name") as! String
        cell.resCellName.text = name
        return cell
    }
    
 
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if myGuestPlacesArray.count > 0 {
            
            let tableRows = myGuestPlacesArray.count
            
            return tableRows
        }
        else {
            return 0
        }

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("toGuestDetailSegue", sender: self)
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let objectDelete:PFObject = myGuestPlacesArray[indexPath.row] as! PFObject
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            myGuestPlacesArray.removeAtIndex(indexPath.row)
            var query = PFQuery(className: "OwnerPlaces")
            query.getObjectInBackgroundWithId(objectDelete.objectId!) {
                object, error in
                if error != nil {
                    println("Delete: \(error?.localizedDescription)")
                }
                else {
                    object?.deleteInBackground()
                    self.tableView.reloadData()
                }
            }
            
        }
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
