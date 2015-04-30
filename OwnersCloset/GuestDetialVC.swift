//
//  GuestDetialVC.swift
//  CabTrack2.1
//
//  Created by Jim Aven on 4/15/15.
//  Copyright (c) 2015 Jim Aven. All rights reserved.
//

import UIKit
import iAd

class GuestDetialVC: UIViewController, UITableViewDataSource, UITableViewDelegate, ADBannerViewDelegate {

    var name:String!
    var itemsDict:NSDictionary!
    private var iDictArray:[(String, Int)]!
    private var includedItemsArray = [String : Int]()
    private var bannerView = ADBannerView()
    var controller:UIAlertController?
    var isSliderEnabled = false
   
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var updateBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var mapViewBtn: UIButton!
    
    
    
   
    
    override func viewWillAppear(animated: Bool) {
        self.iDictArray = self.convertDictToTuple(self.itemsDict)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tableView.reloadData()
//        self.loadAds()
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Buttons
    
    @IBAction func backBtnPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func mapViewBtnPressed(sender: UIButton) {
        
        //configured on storyboard
    }
    
    @IBAction func updateBtnPressed(sender: UIButton) {
       
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
                            self?.isSliderEnabled = true
                            self?.updateBtn.hidden = true
                            self?.saveButton.hidden = false
                            self?.mapViewBtn.hidden = true
                            self?.backBtn.hidden = true
                            self!.tableView.reloadData()
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

    @IBAction func saveBtnPressed(sender: UIButton) {
        
        controller = UIAlertController(title: "Are you sure you want to save?", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.Default) { (alert:UIAlertAction!) -> Void in
            
            self.tableView.reloadData()
            
            self.includedItemsArray = self.convertTupleToDictArray(self.iDictArray)
            let query = PFQuery(className: "OwnerPlaces")
            query.whereKey("name", equalTo: self.name)
            query.getFirstObjectInBackgroundWithBlock {
                
                result, error in
                if error != nil {
                    println(error!.localizedDescription)
                }
                else {
                    result!["items"] = self.includedItemsArray
                    result!.saveInBackgroundWithBlock({
                        success, error in
                        
                        if success == true {
                            fetchUserOwnerPlaces()
                            self.controller = UIAlertController(title: "Items saved", message: "Thank you and the owner will be notified", preferredStyle: UIAlertControllerStyle.Alert)
                            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (alert:UIAlertAction!) -> Void in
                                
                                self.updateBtn.hidden = false
                                self.backBtn.hidden = false
                                self.mapViewBtn.hidden = false
                                self.saveButton.hidden = true
                                self.isSliderEnabled = false
                                self.tableView.reloadData()
                                self.dismissViewControllerAnimated(true, completion: nil)
                            })
                            
                            self.controller!.addAction(okAction)
                            self.presentViewController(self.controller!, animated: true, completion: nil)
                        }
                        else {
                        self.controller = UIAlertController(title: "Error", message: "Unable to save items. Please try again", preferredStyle: UIAlertControllerStyle.Alert)
                        self.controller?.addAction(cancelAction)
                        }
                    })
                }
            }
        }
        self.controller!.addAction(cancelAction)
        self.controller!.addAction(saveAction)
        self.presentViewController(self.controller!, animated: true, completion: nil)
    }
    
    //MARK: TableViewData

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:GuestDetailCell = tableView.dequeueReusableCellWithIdentifier("cell") as! GuestDetailCell
        
        let path = self.iDictArray[indexPath.row]
        
        cell.itemNameLabel.text = path.0
        cell.slider.continuous = false
        cell.slider.tag = indexPath.row
        cell.slider.value = Float(path.1)
        
        if self.isSliderEnabled == false {
            cell.slider.enabled  = false
        }
        else {
            cell.slider.enabled = true
            cell.slider.addTarget(self, action: "sliderValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
        }
//        cell.slider.addTarget(self, action: "sliderValueChanged:", forControlEvents: nil)
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let tableRows = self.itemsDict.count
        return tableRows
        
    }

    
    //MARK: iAd Banner
    
    private func loadAds () {
        
        self.bannerView.frame = CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50)
        self.bannerView.delegate = self
        self.bannerView.hidden = true
        view.addSubview(bannerView)
    }
    
    private func bannerViewDidLoadAd(banner: ADBannerView!) {
        
        self.bannerView.hidden = false
    }
    
    private func bannerViewActionShouldBegin(banner: ADBannerView!, willLeaveApplication willLeave: Bool) -> Bool {
        return willLeave
    }
    
    private func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        self.bannerView.hidden = true
    }
    
    //MARK: TableView converters
    
    
    func convertDictToTuple(dict:AnyObject) -> [(String, Int)] {
        
        var itemArray = [(String, Int)]()
        var tuple:(String, Int)!
        var newDict:[String : Int] = dict as! [String : Int]
        
        for (key, value) in newDict {
            let nameKey = key
            let itemInt = value
            tuple = (nameKey, itemInt)
            itemArray.append(tuple)
        }
        
        return itemArray
    }
    
    func convertTupleToDictArray (array:[(String, Int)]) -> [String:Int] {
        
        var funcArray = [String:Int]()
        for x in array {
            let name:String = x.0
            let num:Int = x.1
            funcArray[name] = num
        }
        return funcArray
    }
    
    //Slider helper
    
    func sliderValueChanged(sender: UISlider) {
        
        var curValue:Int = Int(sender.value)
        var position = sender.tag
        println("Index value for tag is \(position)")
        self.iDictArray[position].1 = curValue
        println(iDictArray[position])
    }

}

