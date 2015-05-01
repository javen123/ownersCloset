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
        
        if !myPlaceResArray.isEmpty {
             tableView.reloadData()
        }
        if self.revealViewController() != nil {
            menuBtn.target = self.revealViewController()
            menuBtn.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
       
        
    }
    override func viewWillAppear(animated: Bool) {
        if !myPlaceResArray.isEmpty {
            tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toDetailSegue" {
            
            let detailVC:OwnerDetailVC = segue.destinationViewController as! OwnerDetailVC
            let indexPath = self.tableView.indexPathForSelectedRow()
            let curPlace:AnyObject = myPlaceResArray[indexPath!.row]
            detailVC.name = curPlace.valueForKey("name") as! String
            detailVC.itemsDict = curPlace.valueForKey("items") as! NSDictionary
        }
    }
    
    //Buttons
    
  
    //MARK: TableViewDataSource

    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if myPlaceResArray.count > 0 {
            
            let tableRows = myPlaceResArray.count
            return tableRows
        }
        else {
            return 0
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:OwnerVCCell = tableView.dequeueReusableCellWithIdentifier("cell") as! OwnerVCCell
        let places:AnyObject = myPlaceResArray[indexPath.row]
        let name:String = places.valueForKey("name") as! String
        
        cell.ownResName.text = name
        
        return cell
    }
    
    //MARK: TableView delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        performSegueWithIdentifier("toDetailSegue", sender: self)
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let objectDelete:PFObject = myPlaceResArray[indexPath.row] as! PFObject
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            myPlaceResArray.removeAtIndex(indexPath.row)
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
    
    // Mark: IAP helper
    
        
    
    

    
    
    
}
