//
//  ItemDetail.swift
//  OwnersCloset
//
//  Created by Jim Aven on 5/1/15.
//  Copyright (c) 2015 Jim Aven. All rights reserved.
//

import UIKit

class ItemDetail: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    var itemsToDisplay = [:]
    var displayedArray = [String]()
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println("items to display:\(itemsToDisplay)")
        self.navigationController?.toolbar.hidden = false
        for (x, value) in itemsToDisplay {
            self.displayedArray = value as! [String]
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveBtnPressed(sender: UIBarButtonItem) {
        
        var filtered = [String]()
        
        for x in self.displayedArray {
            if x != "1" {
                filtered.append(x)
                self.displayedArray = filtered
            }
        }
       
        let items = OwnerItems()
        
        if (self.itemsToDisplay.valueForKey("kitchen") != nil) {
            gKitchenUpdate = ["kitchen":self.displayedArray]
            
        }
        else if (self.itemsToDisplay.valueForKey("bath") != nil) {
           gBathUpdate = ["bath":self.displayedArray]
            
        }
        else if (self.itemsToDisplay.valueForKey("outDoor") != nil) {
           gOutDoorUpdate = ["outDoor":self.displayedArray]
           
        }
        else if (self.itemsToDisplay.valueForKey("bar") != nil) {
            gBarUpdate = ["bar":self.displayedArray]
            
        }
        else if (self.itemsToDisplay.valueForKey("game") != nil) {
            gGameUpdate = ["game":self.displayedArray]
            
        }
        self.navigationController?.popViewControllerAnimated(true)
        
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
     
        let cell:ItemCell = tableView.dequeueReusableCellWithIdentifier("cell") as! ItemCell
        let path = displayedArray[indexPath.row]
        cell.itemName.text = path
        cell.imageBool.image = UIImage(named: "checkMark")
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.displayedArray.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let checkMark = UIImage(named: "checkMark")
        let xMark = UIImage(named: "xMark")
        
        if let curPath = tableView.indexPathForSelectedRow() {
            let cell:ItemCell = tableView.cellForRowAtIndexPath(curPath) as! ItemCell
            if cell.imageBool.image == checkMark {
                cell.imageBool.image = xMark
                self.displayedArray[curPath.row] = "1"
                
            }
            else if cell.imageBool.image == xMark {
                cell.imageBool.image = checkMark
                let item = self.displayedArray[curPath.row]
                self.displayedArray[curPath.row] = cell.itemName.text!
                
            }
        }
    }
}
