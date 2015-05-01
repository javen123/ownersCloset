//
//  OwnerAddItems.swift
//  CabTrack2.1
//
//  Created by Jim Aven on 4/9/15.
//  Copyright (c) 2015 Jim Aven. All rights reserved.
//

import Foundation
import UIKit

class OwnerAddItems:UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let items = OwnerItems()
    
    var user = PFUser.currentUser()
    var newResPassword:String!
    var newResNameUpload:String!
    var newResLocationUpload:PFGeoPoint!
    
        override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func saveBtnPressed(sender: UIBarButtonItem) {
        
        // iterate and add items to new array for uploading
        
        for item in items.tableItems {
            if item.1 == true {
                let x = item
                items.includedItemsArray[x.0] = 10
            }
        }
        
        
        //      prepare data for parse
        var aNewPlace = PFObject(className: "OwnerPlaces")
        aNewPlace["name"] = self.newResNameUpload
        aNewPlace["location"] = self.newResLocationUpload
        aNewPlace["items"] = items.includedItemsArray
        aNewPlace["password"] = self.newResPassword
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
                    })
                    alert.addAction(alertAction)
                    
                    self.presentViewController(alert, animated:true, completion: nil)
                    
                    // query and update OwnerVC table
                    
                    fetchUserOwnerPlaces()
                }
            }
        }

    }

    
    //MARK: TableView datasource
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell:AddItemsCell = tableView.dequeueReusableCellWithIdentifier("cell") as! AddItemsCell
        
        let itemName = items.tableItems[indexPath.row]
        
        cell.itemName.text = itemName.0
        cell.imageBool.image = UIImage(named: "checkMark")
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.tableItems.count
        
    }
    
    //TableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let check = UIImage(named: "checkMark")
        let xMark = UIImage(named: "xMark")

        if let curIndexPath = tableView.indexPathForSelectedRow() {
            let cell:AddItemsCell = tableView.cellForRowAtIndexPath(curIndexPath) as! AddItemsCell
            
            
            if cell.imageBool.image == check {
                cell.imageBool.image = xMark
                items.tableItems[curIndexPath.row].1 = false
                
            }
            else {
                cell.imageBool.image = check
                items.tableItems[curIndexPath.row].1 = true
            
            }
        }
    }
}
