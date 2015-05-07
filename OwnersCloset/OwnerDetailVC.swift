//
//  OwnerDetailVC.swift
//  CabTrack2.1
//
//  Created by Jim Aven on 4/9/15.
//  Copyright (c) 2015 Jim Aven. All rights reserved.
//

import UIKit

class OwnerDetailVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var headers = ["Kitchen", "Bath", "Bar", "Outdoor", "Game"]
    
    private var barItems:[[String:Int]]!
    private var kitchenItems:[[String:Int]]!
    private var bathItems:[[String:Int]]!
    private var gameItems:[[String:Int]]!
    private var outDoorItems:[[String:Int]]!
    
    
    var name:String!
    var curPlace:PFObject!
    var retrievedItems:[AnyObject]!
    var controller:UIAlertController?
    var objId:String!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.toolbar.hidden = true
        self.grabItems()
        let backBtn = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: "backBtnPressed:")
        backBtn.tintColor = UIColor.blackColor()
        backBtn.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Helvetica Neue", size: 15)!], forState: UIControlState.Normal)
        self.navigationItem.leftBarButtonItem = backBtn

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ownItemSegue" {
            let itemDetail:OwnerItemDetailVC = segue.destinationViewController as! OwnerItemDetailVC
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
   
    //MARK: TableView DataSource
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:OwnerDetailCell = tableView.dequeueReusableCellWithIdentifier("cell") as! OwnerDetailCell
        let path = self.headers[indexPath.row]
        
        cell.itemName.text = path
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.headers.count
    }
    
    //MARK: TableView Delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("ownItemSegue", sender: self)
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
    
    func backBtnPressed(button:UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    

}
