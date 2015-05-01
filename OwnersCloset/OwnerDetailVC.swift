//
//  OwnerDetailVC.swift
//  CabTrack2.1
//
//  Created by Jim Aven on 4/9/15.
//  Copyright (c) 2015 Jim Aven. All rights reserved.
//

import UIKit

class OwnerDetailVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var name:String!
    var itemsDict:NSDictionary!
    private var iDictArray:[(String, Int)]!
    private var includedItemsArray = [String : Int]()
    var controller:UIAlertController?
    private var isSLiderEnabled = false
    
    
    @IBOutlet weak var changePassLabel: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var updateBtnLabel: UIButton!
    @IBOutlet weak var saveBtnLabel: UIButton!
    
    override func viewWillAppear(animated: Bool) {
        self.iDictArray = self.convertDictToTuple(self.itemsDict)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
 
            tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    //MARK: Buttons
    

    @IBAction func changePasswordBtnPressed(sender: UIButton) {
        
        
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
                                self.controller = UIAlertController(title: "Password Saved", message: "your guest can now update items", preferredStyle: UIAlertControllerStyle.Alert)
                                let oKAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil);                            self.controller?.addAction(oKAction)
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
   
    @IBAction func updateBtnPressed(sender: UIButton) {
        
        controller = UIAlertController(title: "Change item values", message: "Use the slider to update amounts", preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) { (alert:UIAlertAction!) -> Void in
            self.isSLiderEnabled = true
            self.changePassLabel.hidden = false
            self.updateBtnLabel.hidden = true
            
            self.saveBtnLabel.hidden = false
            self.tableView.reloadData()
        }
        controller?.addAction(action)
        self.presentViewController(self.controller!, animated: true, completion: nil)
    }
    @IBAction func saveBtnPressed(sender: UIButton) {
        
        self.includedItemsArray = self.convertTupleToDictArray(self.iDictArray)
        let query = PFQuery(className: "OwnerPlaces")
        query.whereKey("name", equalTo: name)
        query.getFirstObjectInBackgroundWithBlock {
            object, error in
            if error != nil {
                
                println(error!.localizedDescription)
            }
            else {
                let date = NSDate()
                object!["updated"] = date
                object!["items"] = self.includedItemsArray
                object!.saveInBackgroundWithBlock({
                    success, error in
                    if success == true {
                        
                        fetchUserOwnerPlaces()
                        
                        
                        self.controller! = UIAlertController(title: "Thank you",
                            message: "Items have been updated",
                            preferredStyle: UIAlertControllerStyle.Alert)
                        
                        let alertAction:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                            self.isSLiderEnabled = false
                            self.changePassLabel.hidden = true
                            self.updateBtnLabel.hidden = false
                            
                            self.saveBtnLabel.hidden = true
                            self.tableView.reloadData()
                            self.navigationController?.popToRootViewControllerAnimated(true)
                        })
                        self.controller!.addAction(alertAction)
                        self.presentViewController(self.controller!, animated: true, completion: nil)
                    }
                    else {
                        var alert:UIAlertController = UIAlertController(title: "There was an error saving",
                            message: "\(error?.localizedDescription)",
                            preferredStyle: UIAlertControllerStyle.Alert)
                        
                        let alertAction:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
                            self.navigationController?.popToRootViewControllerAnimated(true)                        })
                        alert.addAction(alertAction)
                        
                        self.presentViewController(alert, animated:true, completion: nil)                    }
                })
                
            }
        }
        
    }
    
    //MARK: TableView DataSource
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:OwnerDetailCell = tableView.dequeueReusableCellWithIdentifier("cell") as! OwnerDetailCell
        let path = self.iDictArray[indexPath.row]
        
        
        
        cell.itemName.text = path.0
        cell.slider.continuous = false
        cell.slider.tag = indexPath.row
        cell.slider.value = Float(path.1)
        
        if self.isSLiderEnabled == false {
            cell.slider.enabled = false
        }
        else {
            cell.slider.enabled = true
            cell.slider.addTarget(self, action: "sliderValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
        }
        
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemsDict.count
    }
    
    //MARK: TableView Delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
    }
    
    // Table dict helper
    
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
