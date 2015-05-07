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
    @IBOutlet weak var menuBtn: UIBarButtonItem!
    
    private var bannerView = ADBannerView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !gMyGuestPLacesArray.isEmpty {
            tableView.reloadData()
        }
        if self.revealViewController() != nil {
            menuBtn.target = self.revealViewController()
            menuBtn.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        self.navigationController?.toolbar.hidden = true
        println(gMyGuestPLacesArray)
        self.loadAds()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        if !gMyGuestPLacesArray.isEmpty {
            tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "guestDetailSegue" {
            
            let detailVC:GuestDetailVC = segue.destinationViewController as! GuestDetailVC
            let indexPath = self.tableView.indexPathForSelectedRow()
            let guestPlace:PFObject = gMyGuestPLacesArray[indexPath!.row] as! PFObject
            let lat = guestPlace["location"]!.latitude
            let lon = guestPlace["location"]!.longitude
            mapCoord = (lat, lon)
            detailVC.curPlace = guestPlace
        }
    }
    
    //MARK: TableViewDatasource
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:GuestVCCell = tableView.dequeueReusableCellWithIdentifier("cell") as! GuestVCCell
        let places:AnyObject = gMyGuestPLacesArray[indexPath.row]
        let name:String = places.valueForKey("name") as! String
        let update:NSDate = places.valueForKey("updated") as! NSDate
        
        cell.dateLabel.text = self.dateConverter(update)
        cell.resCellName.text = name
        return cell
    }
    
 
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if gMyGuestPLacesArray.count > 0 {
            
            let tableRows = gMyGuestPLacesArray.count
            
            return tableRows
        }
        else {
            return 0
        }

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("guestDetailSegue", sender: self)
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let objectDelete:PFObject = gMyGuestPLacesArray[indexPath.row] as! PFObject
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            gMyGuestPLacesArray.removeAtIndex(indexPath.row)
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
    
     func dateConverter(date:NSDate) -> String {
            
            var dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            var dateString = dateFormatter.stringFromDate(date)
            return dateString
        }

}
