//
//  OwnerVC.swift
//  CabTrack2.1
//
//  Created by Jim Aven on 4/9/15.
//  Copyright (c) 2015 Jim Aven. All rights reserved.
//

import UIKit


class OwnerVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !gMyPlaceResArray.isEmpty {
             tableView.reloadData()
        }
        if self.revealViewController() != nil {
            menuBtn.target = self.revealViewController()
            menuBtn.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        self.navigationController?.toolbar.hidden = true
       
        
        
    }
    override func viewWillAppear(animated: Bool) {
        if !gMyPlaceResArray.isEmpty {
            tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ownDetailSegue" {
            
            let detailVC:OwnerDetailVC = segue.destinationViewController as! OwnerDetailVC
            let indexPath = self.tableView.indexPathForSelectedRow()
            let place:PFObject = gMyPlaceResArray[indexPath!.row] as! PFObject
            detailVC.curPlace = place
            
        }
    }
    
    //Buttons
    
  
    //MARK: TableViewDataSource

    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if gMyPlaceResArray.count > 0 {
            
            let tableRows = gMyPlaceResArray.count
            return tableRows
        }
        else {
            return 0
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:OwnerVCCell = tableView.dequeueReusableCellWithIdentifier("cell") as! OwnerVCCell
        let places:AnyObject = gMyPlaceResArray[indexPath.row]
        let name:String = places.valueForKey("name") as! String
        let upDate:NSDate = places.valueForKey("updatedAt") as! NSDate
        
        cell.ownResName.text = name
        cell.updateDate.text = self.dateConverter(upDate)
        return cell
    }
    
    //MARK: TableView delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        performSegueWithIdentifier("ownDetailSegue", sender: self)
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let objectDelete:PFObject = gMyPlaceResArray[indexPath.row] as! PFObject
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            gMyPlaceResArray.removeAtIndex(indexPath.row)
            var query = PFQuery(className: "OwnerPlaces")
            query.getObjectInBackgroundWithId(objectDelete.objectId!) {
                object, error in
                if error != nil {
                    println("Delete: \(error?.localizedDescription)")
                }
                else {
                    object?.deleteInBackground()
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func dateConverter(date:NSDate) -> String {
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        var dateString = dateFormatter.stringFromDate(date)
        return dateString
    }
}
