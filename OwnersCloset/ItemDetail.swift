//
//  ItemDetail.swift
//  OwnersCloset
//
//  Created by Jim Aven on 5/1/15.
//  Copyright (c) 2015 Jim Aven. All rights reserved.
//

import UIKit

class ItemDetail: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    var display:[String]!
    var tempDisplay:[(String,Int)]!
    var cat:Int!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tempDisplay = self.displayedItems(self.display)
        self.navigationController?.toolbar.hidden = false
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveBtnPressed(sender: UIBarButtonItem) {
        
        if self.cat == 0 {
            kitItems = self.saveBtnHelper()
        }
        else if self.cat == 1 {
            batItems = self.saveBtnHelper()
        }
        else if self.cat == 2 {
            barItems = self.saveBtnHelper()
        }
        else if self.cat == 3 {
            outItems = self.saveBtnHelper()
        }
        else if self.cat == 4 {
           gameItems = self.saveBtnHelper()
        }
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
     
        let cell:ItemCell = tableView.dequeueReusableCellWithIdentifier("cell") as! ItemCell
        let path = tempDisplay[indexPath.row]
        cell.itemName.text = path.0
        cell.imageBool.image = UIImage(named: "checkMark")
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tempDisplay.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let checkMark = UIImage(named: "checkMark")
        let xMark = UIImage(named: "xMark")
        var path = self.tempDisplay[indexPath.row]
        
        if path.1 == 0 {
            path.1 = 1
            self.tempDisplay[indexPath.row] = path
            println(self.tempDisplay)
        }
        else {
            path.1 = 0
            self.tempDisplay[indexPath.row] = path
            println(self.tempDisplay)
        }
        
        if let curPath = tableView.indexPathForSelectedRow() {
            
            let cell:ItemCell = tableView.cellForRowAtIndexPath(curPath) as! ItemCell
            if cell.imageBool.image == checkMark {
                cell.imageBool.image = xMark
                
                
            }
            else if cell.imageBool.image == xMark {
                cell.imageBool.image = checkMark
                
                println(self.tempDisplay)
            }
        }
    }
    
    // table helper
    
    func displayedItems(items:[String]) -> [(String, Int)] {
        var array = [(String, Int)]()
        for x in items {
            let a = x
            let u = 0
            let j = (a, u)
            array.append(j)
            
        }
        return array
    }
    
    func saveBtnHelper() -> [String] {
        
        var temp = [String]()
        
        for x in self.tempDisplay {
            if x.1 == 0 {
                let i = x.0
                temp.append(i)
            }
        }
        return temp
    }
}
