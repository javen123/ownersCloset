//
//  GuestDetailVC.swift
//  OwnersCloset
//
//  Created by Jim Aven on 5/5/15.
//  Copyright (c) 2015 Jim Aven. All rights reserved.
//

import UIKit
import iAd

class GuestDetailVC: UIViewController, UITableViewDataSource, UITableViewDelegate, ADBannerViewDelegate {

    
    private var headers = ["Kitchen", "Bath", "Bar", "Outdoor", "Game"]
    
    private var barItems:[[String:Int]]!
    private var kitchenItems:[[String:Int]]!
    private var bathItems:[[String:Int]]!
    private var gameItems:[[String:Int]]!
    private var outDoorItems:[[String:Int]]!
    private var bannerView = ADBannerView()
    
    var name:String!
    var curPlace:PFObject!
    var retrievedItems:[AnyObject]!
    var controller:UIAlertController?
    var objId:String!

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.toolbar.hidden = true
        
        let mapButton = UIBarButtonItem(title: "Map", style: UIBarButtonItemStyle.Plain, target: self, action: "mapView:")
        mapButton.tintColor = UIColor.blackColor()
        self.navigationItem.rightBarButtonItem = mapButton
        
        let backBtn = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: "backBtnPressed:")
        backBtn.tintColor = UIColor.blackColor()
        backBtn.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Helvetica Neue", size: 15)!], forState: UIControlState.Normal)
        self.navigationItem.leftBarButtonItem = backBtn
        
        
        self.grabItems()

        self.loadAds()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        var tempArray = [[String:Int]]()
        
        if segue.identifier == "guestItemSegue" {
            
            let itemDetail:GuestItemDetailVC = segue.destinationViewController as! GuestItemDetailVC
            
            itemDetail.name = self.curPlace["name"] as! String
            
            let path = self.tableView.indexPathForSelectedRow()?.row
            
            if path == 0 {
                itemDetail.place = self.kitchenItems
                itemDetail.obId = self.objId
                itemDetail.upLoadHead = "kitchen"
            }
            else if path == 1 {
                itemDetail.place = self.bathItems
                itemDetail.obId = self.objId
                itemDetail.upLoadHead = "bath"
            }
            else if path == 2 {
                itemDetail.place = self.barItems
                itemDetail.obId = self.objId
                itemDetail.upLoadHead = "bar"
            }
            else if path == 3 {
                itemDetail.place = self.outDoorItems
                itemDetail.obId = self.objId
                itemDetail.upLoadHead = "outDoor"
            }
            else if path == 4 {
                itemDetail.place = self.gameItems
                itemDetail.obId = self.objId
                itemDetail.upLoadHead = "game"
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.headers.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:GuestDetailCell = tableView.dequeueReusableCellWithIdentifier("cell") as! GuestDetailCell
        
        let path = self.headers[indexPath.row]
        
        cell.itemNameLabel.text = path
        
        return cell
    }
        
    //MARK: TableView Delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("guestItemSegue", sender: self)
    }
    
    // API grab items
    func grabItems() {
        
        let itemRelation = self.curPlace.relationForKey("myItems")
        itemRelation.query()?.findObjectsInBackgroundWithBlock({
            
            objects, error in
            
            if error != nil {
                
                println(error!.localizedDescription)
            }
            else {
                
                for object in objects! {
                    self.objId = object.objectId
                    self.barItems = object["bar"] as! [[String:Int]]
                    self.kitchenItems = object["kitchen"] as! [[String:Int]]
                    self.bathItems = object["bath"] as! [[String:Int]]
                    self.gameItems = object["game"] as! [[String:Int]]
                    self.outDoorItems = object["outDoor"] as! [[String:Int]]
                    println(self.objId)
                }
            }
        })
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
    
    func mapView (button:UIBarButtonItem) {
        self.performSegueWithIdentifier("mapSegue", sender: self)
    }
    func backBtnPressed(button:UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }

}
