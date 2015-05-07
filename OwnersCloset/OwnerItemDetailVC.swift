//
//  OwnerItemDetailVC.swift
//  OwnersCloset
//
//  Created by Jim Aven on 5/4/15.
//  Copyright (c) 2015 Jim Aven. All rights reserved.
//

import UIKit

class OwnerItemDetailVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
   let cItems = OwnerItems()
    
    //Bar Button Items
    
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    @IBOutlet weak var updateBtn: UIBarButtonItem!
    @IBOutlet weak var addItemBtn: UIBarButtonItem!

    // vars
    
    var items:[(String, Int)]!
    var place:[[String:Int]]!
    var name:String!
    var upLoadHead:String!
    var obId:String!
    private var isSLiderEnabled = false
    private var controller:UIAlertController?
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.toolbar.hidden = false
        self.items = self.convertAPIItems(place)
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.blackColor()
        
        let backBtn = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: "backBtnPressed:")
        backBtn.tintColor = UIColor.blackColor()
        backBtn.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Helvetica Neue", size: 15)!], forState: UIControlState.Normal)
        self.navigationItem.leftBarButtonItem = backBtn

       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: TableView Data and Delegates
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:OwnerItemDetailCell = tableView.dequeueReusableCellWithIdentifier("cell") as! OwnerItemDetailCell
        let path = self.items[indexPath.row]
        
        cell.itemName.text = path.0
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    

    //MARK: Buttons
    
    @IBAction func changePasswordBarBtnPressed(sender: UIBarButtonItem) {
        
        controller = UIAlertController(title: "Password Change", message: "for location '\(self.name)'", preferredStyle: UIAlertControllerStyle.Alert)
        controller!.addTextFieldWithConfigurationHandler { (textField:UITextField!) -> Void in
            textField.placeholder = "new password"
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.Default) { (alert:UIAlertAction!) -> Void in
            
            if let text = self.controller?.textFields {
                let aField = text as! [UITextField]
                let newPass = aField[0].text
                
                let query = PFQuery(className: "OwnerPlaces")
                query.whereKey("name", equalTo: self.name)
                query.getFirstObjectInBackgroundWithBlock({
                    object, error in
                    
                    if error != nil {
                        println(error!.localizedDescription)
                    }
                    else {
                        println(newPass)
                        object!["password"] = newPass
                        object!.saveInBackgroundWithBlock({
                            success, error in
                            
                            if success == true {
                                self.controller = UIAlertController(title: "Password Saved", message: "your guests must provide new password to update items", preferredStyle: UIAlertControllerStyle.Alert)
                                let oKAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil);
                                self.controller?.addAction(oKAction)
                                self.presentViewController(self.controller!, animated: true, completion: nil)
                            }
                        })
                    }
                })
            }
        }
        controller?.addAction(cancelAction)
        controller?.addAction(saveAction)
        self.presentViewController(controller!, animated: true, completion: nil)
        
    }
    
    @IBAction func updateBtnPressed(sender: UIBarButtonItem) {
        
        self.navigationController?.toolbar.hidden = false
        
        controller = UIAlertController(title: "Change item values", message: "Use the slider to update amounts", preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) { (alert:UIAlertAction!) -> Void in
            self.isSLiderEnabled = true
            self.tableView.reloadData()
            self.navigationController?.toolbar.hidden = true
           let button = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.Plain, target: self, action: "saveBtnPressed:")
            button.tintColor = UIColor.blackColor()
            self.navigationItem.rightBarButtonItem = button
           
        }
        controller?.addAction(action)
        self.presentViewController(self.controller!, animated: true, completion: nil)
    }

    @IBAction func addItemsBtPressed(sender: UIBarButtonItem) {
        
        controller = UIAlertController(title: "Add new item", message: "for location '\(self.name)'", preferredStyle: UIAlertControllerStyle.Alert)
        controller!.addTextFieldWithConfigurationHandler { (textField:UITextField!) -> Void in
            textField.placeholder = "enter item name"
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.Default) { (alert:UIAlertAction!) -> Void in
            
            if let text = self.controller?.textFields {
                let aField = text as! [UITextField]
                let newItem = aField[0].text
                let newItemTup = (newItem!, 0)
                self.items.append(newItemTup)
                let query = PFQuery(className: "Items")
                query.getObjectInBackgroundWithId(self.obId) {
                    
                    object, error in
                    if error != nil {
                        println(error!.localizedDescription)
                    }
                    else {
                        object![self.upLoadHead] = self.convertTupToDictArray(self.items)
                        object!.saveInBackground()
                        self.controller = UIAlertController(title: "Item have been saved", message: "", preferredStyle: UIAlertControllerStyle.Alert)
                        let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) { (alert:UIAlertAction!) -> Void in
                            fetchUserOwnerPlaces()
                            self.tableView.reloadData()
                        }
                        self.controller?.addAction(action)
                        self.presentViewController(self.controller!, animated: true, completion: nil)
                    }
                }
                
            }
        }
        controller?.addAction(cancelAction)
        controller?.addAction(saveAction)
        self.presentViewController(controller!, animated: true, completion: nil)
    }
    
    // Save Button Pressed
    
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

    //MARK: Helpers
    
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
    
    
    func backBtnPressed(button:UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    
}
