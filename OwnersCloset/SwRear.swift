//
//  SwRear.swift
//  OwnersCloset
//
//  Created by Jim Aven on 4/30/15.
//  Copyright (c) 2015 Jim Aven. All rights reserved.
//

import UIKit

class SwRear: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var tableItems = ["Guest", "Owner","About", "Logout", "Buy Now"]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.revealViewController().rearViewRevealWidth = 150
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.tableItems.count
    }

   
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:SwRearCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! SwRearCell

        let path = tableItems[indexPath.row]
        cell.indexName.text = path

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == 0 {
            self.performSegueWithIdentifier("guestSegue", sender: self)
        }
        else if indexPath.row == 1 {
            self.performSegueWithIdentifier("ownerSegue", sender: self)
        }
        else if indexPath.row == 2 {
            let vc:UIViewController = AboutVC()
            self.presentViewController(vc, animated: true, completion: nil)
        }
        else if indexPath.row == 3 {
            
            PFUser.logOutInBackgroundWithBlock({
                
                error in
                
                if error != nil {
                    println(error!.localizedDescription)
                }
                else {
                    self.navigationController?.popToRootViewControllerAnimated(true)
                }
            })
        }
        else if indexPath.row == 4 {
            self.performSegueWithIdentifier("iapSegue", sender: self)
        }
    }

}
