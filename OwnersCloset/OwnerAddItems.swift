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
    
    var user = PFUser.currentUser()
    var newResPassword:String!
    var newResNameUpload:String!
    var newResLocationUpload:PFGeoPoint!
    
    private var includedItemsArray = [String : Int]()
    var tableItems = [
        
        ("Mayo", true),
        ("Mustard - yellow", true),
        ("Mustard - dijon", true),
        ("Steak sauce", true),
        ("Salad dressing - ranch", true),
        ("Salad dressing - italian",true),
        ("Salad dressing - vinagrette",true),
        ("Pickles",true),
        ("Peanut butter",true),
        ("Butter",true),
        ("Soy sauce",true),
        ("Teriyaki sauce",true),
        ("Worcestershire sauce",true),
        ("Soup - cream of mushroom",true),
        ("Soup - cream of chicken",true),
        ("Soup - chicken & noodles",true),
        ("Salsa",true),
        ("Bbq sauce",true),
        ("Tobasco",true),
        ("Chocolate sauce",true),
        ("Jelly",true),
        ("Honey",true),
        ("Pickle relish",true),
        ("Olive oil",true),
        ("Canola oil",true),
        ("Juice - orange",true),
        ("Juice - apple",true),
        ("Juice - cranberry",true),
        ("Popcorn",true),
        ("Salt",true),
        ("Pepper",true),
        ("Garlic powder",true),
        ("Paprika",true),
        ("Chili powder",true),
        ("Coffee",true),
        ("Coffee filters",true),
        ("Toilet paper",true),
        ("Aluminum foil",true),
        ("Charcoal",true),
        ("Lighter fluid",true),
        ("Matches/lighter",true),
        ("Bottled water",true),
        ("Paper towels",true),
        ("Laundry detergent",true),
        ("Fabric softener",true),
        ("Dish soap",true),
        ("Shampoo",true),
        ("Conditioner",true),
        ("Toothpaste",true),
        ("Mouthwash",true),
        ("Soft drinks",true),
        ("Gatorade",true),
        ("Beer",true),
        ("Wine",true),
        ("Vodka",true),
        ("Bourbon",true),
        ("Scotch",true),
        ("Tequila",true)
    ]

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func saveResBtnPressed(sender: UIButton) {
      
        // iterate and add items to new array for uploading
        
        for item in tableItems {
            if item.1 == true {
               let x = item
                self.includedItemsArray[x.0] = 10
            }
        }
        
        
//      prepare data for parse
        
       
        
        var aNewPlace = PFObject(className: "OwnerPlaces")
        aNewPlace["name"] = self.newResNameUpload
        aNewPlace["location"] = self.newResLocationUpload
        aNewPlace["items"] = self.includedItemsArray
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
                        self.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(false, completion: {
                            println(myPlaceResArray)
                        })
                    })
                    alert.addAction(alertAction)
                    
                    self.presentViewController(alert, animated:true, completion: nil)
                    
                    // query and update OwnerVC table
                    
                   fetchUserOwnerPlaces()
                }
            }
        }
    }
    
    @IBAction func backBtnPressed(sender: AnyObject) {
        self.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: TableView datasource
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell:AddItemsCell = tableView.dequeueReusableCellWithIdentifier("itemCell") as! AddItemsCell
        
        let itemName = self.tableItems[indexPath.row]
        
        cell.itemName.text = itemName.0
        cell.imageBool.image = UIImage(named: "checkMark")
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableItems.count
        
    }
    
    //TableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let check = UIImage(named: "checkMark")
        let xMark = UIImage(named: "xMark")

        if let curIndexPath = tableView.indexPathForSelectedRow() {
            let cell:AddItemsCell = tableView.cellForRowAtIndexPath(curIndexPath) as! AddItemsCell
            
            
            if cell.imageBool.image == check {
                cell.imageBool.image = xMark
                self.tableItems[curIndexPath.row].1 = false
                
            }
            else {
                cell.imageBool.image = check
                self.tableItems[curIndexPath.row].1 = true
            
            }
        }
    }
}
