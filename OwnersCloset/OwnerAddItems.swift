//
//  OwnerAddItems.swift
//  CabTrack2.1
//
//  Created by Jim Aven on 4/9/15.
//  Copyright (c) 2015 Jim Aven. All rights reserved.
//

import Foundation
import UIKit

class OwnerAddItems: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let items = OwnerItems()
    
    @IBOutlet weak var tableView: UITableView!
    
    let itemHeaderArray = ["Kitchen", "Bathroom", "Bar", "Outdoors",  "Gameroom"]
    
    var user = PFUser.currentUser()
    var newResPassword:String!
    var newResNameUpload:String!
    var newResLocationUpload:PFGeoPoint!
    
    var sectionTitleArray = NSMutableArray()
    
        override func viewDidLoad() {
        super.viewDidLoad()
        let backBtn = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: "backBtnPressed:")
        backBtn.tintColor = UIColor.blackColor()
        backBtn.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Helvetica Neue", size: 15)!], forState: UIControlState.Normal)
        self.navigationItem.leftBarButtonItem = backBtn


       
    }
    
    // MARK: Save btn
    
    @IBAction func saveBtnPressed(sender: UIBarButtonItem) {
        
       // set up items array
        
        if kitItems != nil {
            gKitchenUpdate = self.updateItemsForUpload(kitItems)
            
        }
        else {
            gKitchenUpdate = self.updateItemsForUpload(self.items.kitchenItems)
        }
        
        if batItems != nil {
            gBathUpdate = self.updateItemsForUpload(batItems)
            
        }
        else {
            gBathUpdate = self.updateItemsForUpload(self.items.bathItems)
        }
        
        if barItems != nil {
            gBarUpdate = self.updateItemsForUpload(barItems)
            
        }
        else {
            gBarUpdate = self.updateItemsForUpload(self.items.barItems)
        }
        
        if gameItems != nil {
            gGameUpdate = self.updateItemsForUpload(gameItems)
            
        }
        else {
            gGameUpdate = self.updateItemsForUpload(self.items.gameItems)
        }
        
        if outItems != nil {
            gOutDoorUpdate = self.updateItemsForUpload(outItems)
            
        }
        else {
            gOutDoorUpdate = self.updateItemsForUpload(self.items.outDoorItems)
        }


        //   set new items
        
        let newItems = PFObject(className: "Items")
        newItems["kitchen"] = gKitchenUpdate
        newItems["bath"] = gBathUpdate
        newItems["bar"] = gBarUpdate
        newItems["game"] = gGameUpdate
        newItems["outDoor"] = gOutDoorUpdate
        
        var aNewPlace = PFObject(className: "OwnerPlaces")
        aNewPlace["name"] = self.newResNameUpload
        aNewPlace["location"] = self.newResLocationUpload
        let date = NSDate()
        aNewPlace["password"] = self.newResPassword
        
        
        var array = [PFObject]()
        array.append(aNewPlace)
        array.append(newItems)
        
        PFObject.saveAllInBackground(array, block: {
            
            success, error in
            
            if error != nil {
                
                println(error!.localizedDescription)
            }
            else {
                
                // relations
                
                let itemsRelation:PFRelation = aNewPlace.relationForKey("myItems")
                itemsRelation.addObject(newItems)
                let relation:PFRelation = self.user!.relationForKey("myOwnPlaces")
                relation.addObject(aNewPlace)
                
                var relArray = [PFObject]()
                relArray.append(self.user!)
                relArray.append(aNewPlace)
                
                PFObject.saveAllInBackground(relArray, block: {
                    
                    success, error in
                    
                        fetchUserOwnerPlaces()
                        if error != nil {
                            println(error!.localizedDescription)
                        }
                        else {
                            var alert:UIAlertController = UIAlertController(title: "Adjust initial quantities from the Owner's page",
                        message: "Have your guest look up \(self.newResNameUpload) to update your items for you",
                        preferredStyle: UIAlertControllerStyle.Alert)
                    
                    let alertAction:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                        self.navigationController?.popToRootViewControllerAnimated(true)
                        gKitchenUpdate = nil
                        gBathUpdate = nil
                        gBarUpdate = nil
                        gGameUpdate = nil
                        gOutDoorUpdate = nil
                    })
                    alert.addAction(alertAction)
                    
                    self.presentViewController(alert, animated:true, completion: nil)
                    }
                })
            }
        })
    }
    

    // MARK: Prepare for segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let indexPath = self.tableView.indexPathForSelectedRow()?.row
        let bath = self.items.bathItems

        if segue.identifier == "itemDetailSegue" {
            
            let detailVC:ItemDetail = segue.destinationViewController as! ItemDetail
            
            if indexPath == 0 {
                
                if kitItems != nil {
                    detailVC.display = kitItems
                }
                else {
                    detailVC.display = self.items.kitchenItems
                }
               detailVC.cat = 0
            }
            
            if indexPath == 1 {
                
                if batItems != nil {
                    detailVC.display = batItems
                }
                else {
                    detailVC.display = self.items.bathItems
                }
                detailVC.cat = 1
            }
            
            if indexPath == 2 {
                
                if barItems != nil {
                    detailVC.display = barItems
                }
                else {
                    detailVC.display = self.items.barItems
                }
                detailVC.cat = 2
            }
            
            if indexPath == 3 {
                
                if outItems != nil {
                    detailVC.display = outItems
                }
                else {
                    detailVC.display = self.items.outDoorItems
                }
                detailVC.cat = 3
            }
            
            if indexPath == 4 {
                
                if gameItems != nil {
                    detailVC.display = gameItems
                }
                else {
                    detailVC.display = self.items.gameItems
                }
                detailVC.cat = 4
            }
        }
    }
    
    
    //MARK: TableView datasource
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell:AddItemsCell = tableView.dequeueReusableCellWithIdentifier("cell") as! AddItemsCell
        
        let itemName = itemHeaderArray[indexPath.row]
        
        cell.itemName.text = itemName
        cell.imageBool.image = UIImage(named: "rightArrow")
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemHeaderArray.count
        
    }
    
    // TableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
      self.performSegueWithIdentifier("itemDetailSegue", sender: self)
       
    }
    
    //MARK: SaveBtnConverters
    
    func saveBtnConverter(dict:[String:[String]]) -> [String:[[String : Int]]] {
        
        var key = dict
        var rDict = [String : [[String : Int]]]()
        var aDict = [[String:Int]]()
        
        for (x, value) in dict {
           let a = value
            for i in a {
                let y = [i:0]
                aDict.append(y)
                rDict = [x:aDict]
            }
        }
        return rDict
    }
    
    private func updateItemsForUpload (array :[String]) -> [[String: Int]] {
        
        var temp = [[String:Int]]()
        var aTemp = [String:Int]()
        
        for x in array {
            aTemp = [x:0]
            temp.append(aTemp)
        }
        return temp
    }
    
    func backBtnPressed(button:UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }

}
    

