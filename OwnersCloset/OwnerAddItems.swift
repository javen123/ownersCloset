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
    
    let itemHeaderArray = ["Kitchen", "Bathroom", "Outdoors", "Bar", "Gameroom"]
    
    var user = PFUser.currentUser()
    var newResPassword:String!
    var newResNameUpload:String!
    var newResLocationUpload:PFGeoPoint!
    
    var sectionTitleArray = NSMutableArray()
    
        override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func saveBtnPressed(sender: UIBarButtonItem) {
        
        if gKitchenUpdate != nil {
            gMyOwnItemsSaved.append(self.saveBtnConverter(gKitchenUpdate))
        }
        else {
            gMyOwnItemsSaved.append(self.saveBtnConverter(self.items.kitchenItems))
        }
        if gBathUpdate != nil {
            gMyOwnItemsSaved.append(self.saveBtnConverter(gBathUpdate))
        }
        else {
            gMyOwnItemsSaved.append(self.saveBtnConverter(self.items.bathItems))
        }
        if gBarUpdate != nil {
            gMyOwnItemsSaved.append(self.saveBtnConverter(gBarUpdate))
        }
        else {
            gMyOwnItemsSaved.append(self.saveBtnConverter(self.items.barItems))
        }
        if gOutDoorUpdate != nil {
            gMyOwnItemsSaved.append(self.saveBtnConverter(gOutDoorUpdate))
        }
        else {
            gMyOwnItemsSaved.append(self.saveBtnConverter(self.items.outDoorItems))
        }
        if gGameUpdate != nil {
            gMyOwnItemsSaved.append(self.saveBtnConverter(gGameUpdate))
        }
        else {
            gMyOwnItemsSaved.append(self.saveBtnConverter(self.items.gameItems))
        }
        println(gMyOwnItemsSaved)
        
        //      prepare data for parse
        var aNewPlace = PFObject(className: "OwnerPlaces")
        aNewPlace["name"] = self.newResNameUpload
        aNewPlace["location"] = self.newResLocationUpload
        aNewPlace["items"] = gMyOwnItemsSaved
        let date = NSDate()
        aNewPlace["updated"] = date
        if self.newResPassword != nil {
            aNewPlace["password"] = self.newResPassword
        }
        
        aNewPlace["myOwner"] = user
        
        aNewPlace.saveInBackgroundWithBlock {
            success, error in
            
            if error != nil {
                println(error?.localizedDescription)
            }
            else {
                
                if success == true {
                    
                    var relation = self.user!.relationForKey("myOwnPlaces")
                    relation.addObject(aNewPlace)
                    self.user?.saveInBackground()
                    
                    var alert:UIAlertController = UIAlertController(title: "Congratulations your place has been saved",
                        message: "Have your guest look up \(self.newResNameUpload) to update your items for you",
                        preferredStyle: UIAlertControllerStyle.Alert)
                    
                    let alertAction:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                        self.navigationController?.popToRootViewControllerAnimated(true)
                        gMyOwnItemsSaved.removeAll(keepCapacity: false)
                        gKitchenUpdate = nil
                        gBathUpdate = nil
                        gBarUpdate = nil
                        gOutDoorUpdate = nil
                        
                    })
                    alert.addAction(alertAction)
                    
                    self.presentViewController(alert, animated:true, completion: nil)
                    
                    // query and update OwnerVC table
                    
                    fetchUserOwnerPlaces()
                }
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let indexPath = self.tableView.indexPathForSelectedRow()?.row
        let bath = self.items.bathItems

        if segue.identifier == "itemDetailSegue" {
            
            let detailVC:ItemDetail = segue.destinationViewController as! ItemDetail
            
            if indexPath == 0 {
                if gKitchenUpdate != nil {
                   detailVC.itemsToDisplay = gKitchenUpdate
                }
                else {
                    detailVC.itemsToDisplay = self.items.kitchenItems
                }
            }
            else if indexPath == 1 {
                if gBathUpdate != nil{
                    detailVC.itemsToDisplay = gBathUpdate
                }
                else {
                    detailVC.itemsToDisplay = self.items.bathItems
                }
            }
            else if indexPath == 2 {
                if gOutDoorUpdate == nil {
                    detailVC.itemsToDisplay = self.items.outDoorItems
                }
                else {
                    detailVC.itemsToDisplay = gOutDoorUpdate
                }
            }
            else if indexPath == 3 {
                if gBarUpdate == nil {
                    detailVC.itemsToDisplay = self.items.barItems
                }
                else {
                    detailVC.itemsToDisplay = gBarUpdate
                }
            }
            else if indexPath == 4 {
                if gGameUpdate == nil {
                    detailVC.itemsToDisplay = self.items.gameItems
                }
                else {
                    detailVC.itemsToDisplay = gGameUpdate
                }
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
}
    

