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
    
    var name:String!
    var curPlace:PFObject!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.toolbar.hidden = true
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
                itemDetail.place = self.segueHelper(0)
                itemDetail.upLoadHead = "kitchen"
            }
            else if path == 1 {
                itemDetail.place = self.segueHelper(1)
                itemDetail.upLoadHead = "bath"
            }
            else if path == 2 {
                itemDetail.place = self.segueHelper(2)
                itemDetail.upLoadHead = "bar"
            }
            else if path == 3 {
                itemDetail.place = self.segueHelper(3)
                itemDetail.upLoadHead = "outDoor"
            }
            else if path == 4 {
                itemDetail.place = self.segueHelper(4)
                itemDetail.upLoadHead = "game"
            }
        }

        func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            
            let cell:GuestDetailCell = tableView.dequeueReusableCellWithIdentifier("cell") as! GuestDetailCell
            let path = self.headers[indexPath.row]
            
            cell.itemName.text = path
            
            return cell
        }
        
        func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.headers.count
        }
        
        //MARK: TableView Delegate
        
        func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            self.performSegueWithIdentifier("guestItemSegue", sender: self)
        }
        
        // Segue Helper
        
        func segueHelper (path:Int) -> [[String:Int]] {
            var tempArray = [[String:Int]]()
            
            let i = self.curPlace["items"] as! [AnyObject]
            let k: NSMutableDictionary = i[path] as! NSMutableDictionary
            for (key, value) in k {
                let j:NSArray = value as! NSArray
                for l in j {
                    let d:[String:Int] = l as! [String: Int]
                    tempArray.append(d)
                }
            }
            return tempArray
        }
    }
}
