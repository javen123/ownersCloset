//
//  GuestItemDetailVC.swift
//  OwnersCloset
//
//  Created by Jim Aven on 5/5/15.
//  Copyright (c) 2015 Jim Aven. All rights reserved.
//

import UIKit
import iAd

class GuestItemDetailVC: UIViewController, UITableViewDataSource, UITableViewDelegate, ADBannerViewDelegate {
    
    //Vars
    
    var items:[(String, Int)]!
    var place:[[String:Int]]!
    var name:String!
    var upLoadHead:String!
    var obId:String!
    private var isSLiderEnabled = false
    private var controller:UIAlertController?
    private var bannerView = ADBannerView()
    
    // Bar buttons
    
    var toolItems = [UIBarButtonItem]()
    var updateBtn:UIBarButtonItem!
    var saveBtn: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadAds()
        
        self.updateBtn = UIBarButtonItem(title: "Update", style: UIBarButtonItemStyle.Plain, target: self, action: "updateBtnPressed:")
        self.updateBtn.tintColor = UIColor.blackColor()
        self.toolItems.append(self.updateBtn)
        
        let backBtn = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: "backBtnPressed:")
        backBtn.tintColor = UIColor.blackColor()
        backBtn.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Helvetica Neue", size: 15)!], forState: UIControlState.Normal)
        self.navigationItem.leftBarButtonItem = backBtn
        self.navigationItem.rightBarButtonItems = self.toolItems
        
        
        self.items = self.convertAPIItems(place)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Buttons
    
    func updateBtnPressed(sender:UIBarButtonItem) {
        
        controller = UIAlertController(title: "Permission to update items", message: "Enter the owner's password", preferredStyle: UIAlertControllerStyle.Alert)
        controller!.addTextFieldWithConfigurationHandler { (textField:UITextField!) -> Void in
            textField.placeholder = "XXXXXXXX"
        }
        let action = UIAlertAction(title: "Enter", style: UIAlertActionStyle.Default) {[weak self] (paramAction:UIAlertAction!) -> Void in
            
            if let textFields = self!.controller?.textFields {
                let aTextFields = textFields as! [UITextField]
                let password = aTextFields[0].text
                
                let query = PFQuery(className: "OwnerPlaces")
                query.whereKey("name", equalTo: self!.name)
                var aQuery = query.getFirstObject()
                if let result = aQuery {
                    let pass:String = result.valueForKey("password") as! String
                    if pass == password {
                        self!.controller = UIAlertController(title: "Perfect", message: "Now use the slider to update the items quantity", preferredStyle: UIAlertControllerStyle.Alert)
                        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
                        let nextAction = UIAlertAction(title: "Next", style: UIAlertActionStyle.Default, handler: { (alert:UIAlertAction!) -> Void in
                            self?.isSLiderEnabled = true
                            self?.toolItems.removeAll(keepCapacity: true)
                            self?.saveBtn = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.Plain, target: self, action: "saveBtnPressed:")
                            self?.saveBtn.tintColor = UIColor.blackColor()
                            self?.toolItems.append(self!.saveBtn)
                            self?.self.navigationItem.rightBarButtonItems = self?.toolItems
                            self?.tableView.reloadData()
                            
                        })
                        self!.controller?.addAction(nextAction)
                        self!.controller?.addAction(cancelAction)
                        self!.presentViewController(self!.controller!, animated: true, completion: nil)
                    }
                    else {
                        self!.controller = UIAlertController(title: "Uh Oh", message: "Password does not match", preferredStyle: UIAlertControllerStyle.Alert)
                        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
                        self!.controller?.addAction(cancelAction)
                        self!.presentViewController(self!.controller!, animated: true, completion: nil)
                    }
                }
            }
        }
        controller!.addAction(action)
        self.presentViewController(controller!, animated: true, completion: nil)
    }
    
    func saveBtnPressed (button:UIBarButtonItem) {
        
        let query = PFQuery(className: "Items")
        query.getObjectInBackgroundWithId(self.obId) {
            object, error in
            
            if error != nil {
                println(error!.localizedDescription)
            }
            else {
                object![self.upLoadHead] = self.convertTupToDictArray(self.items)
                object!.saveInBackground()
                self.controller = UIAlertController(title: "Items have been saved", message: "", preferredStyle: UIAlertControllerStyle.Alert)
                let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) { (alert:UIAlertAction!) -> Void in
                    fetchUserOwnerPlaces()
                    self.navigationController?.popToRootViewControllerAnimated(true)
                }
                self.controller?.addAction(action)
                self.presentViewController(self.controller!, animated: true, completion: nil)
            }
        }
    }

    //MARK: tableviewdata
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        let cell:itemsDetailCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as! itemsDetailCell
        
        let path = self.items[indexPath.row]
        
        cell.itemLabel.text = path.0
        cell.slider.value = Float(path.1)
        
        
        if self.isSLiderEnabled == false {
            cell.slider.enabled = false
        }
        else {
            cell.slider.enabled = true
            let aPath = indexPath.row
            cell.slider.tag = aPath
            cell.slider.addTarget(self, action: "sliderValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
            
        }

        return cell
        
    }
    
    // items converter
    
    func convertAPIItems(dict:[[String:Int]]) -> [(String, Int)] {
        
        var aItems = [(String, Int)]()
        
        
        for i in dict {
            let o:NSDictionary = i as NSDictionary
            for (key, value) in o {
                
                var tup:(String, Int) = (key as! String, value as! Int)
                aItems.append(tup)
            }
        }
        return aItems
    }
    
    
    //Slider helper
    
    func sliderValueChanged(sender: UISlider) {
        var curValue:Int = Int(sender.value)
        var position = sender.tag
        sender.continuous = true
        self.items[position].1 = curValue
        println(curValue)
        
    }
    
    // Save btn helper
    
    func convertTupToDictArray (tup:[(String, Int)]) -> [[String:Int]] {
        
        var tDict = [String:Int]()
        var dictArray = [[String:Int]]()
        
        for x in tup {
            let item = x.0
            let num = x.1
            tDict = [item:num]
            dictArray.append(tDict)
        }
        return dictArray
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
    
    func backBtnPressed(button:UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }

}

