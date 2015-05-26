//
//  User.swift
//  CabTrack2.1
//
//  Created by Jim Aven on 4/9/15.
//  Copyright (c) 2015 Jim Aven. All rights reserved.
//

import Foundation

struct User {
    
    let id:String
    let firstName:String
    let lastName:String
    let email:String
    let firstDate:NSDate
    private let user:PFUser
}



// Fetch owner and guest places from parse

func fetchUserOwnerPlaces () {
    
    if let user = PFUser.currentUser() {
        
        var guestRelation = user.relationForKey("myGuestPlaces")
        guestRelation.query()?.orderByDescending("updatedAt")
        guestRelation.query()?.findObjectsInBackgroundWithBlock({
        objects, error in
        
            if error != nil {
                println(error!.localizedDescription)
                return
            }
            else {
                if let bought:AnyObject = user["purchased"] {
                    purchased = bought as! Bool

                }
                gMyGuestPLacesArray.removeAll(keepCapacity: false)
                gMyGuestPLacesArray = objects!
//                println(gMyGuestPLacesArray)
                
                var ownRelation = user.relationForKey("myOwnPlaces")
                ownRelation.query()?.orderByDescending("updatedAt")
                ownRelation.query()?.findObjectsInBackgroundWithBlock({
                    owners, error in
                    if error != nil {
                        println(error!.localizedDescription)
                        return
                    }
                    else {
                        gMyPlaceResArray.removeAll(keepCapacity: false)
                        gMyPlaceResArray = owners!
                        println(gMyPlaceResArray)
                    }
                })
            }
        })
    }
}

// IAP helper

func isReadyToPurchase() {
    
    let date = NSDate()
    if let user = PFUser.currentUser() {
        
        if let aDate: AnyObject = user.createdAt {
        let openDate:NSDate = aDate as! NSDate
        let calendar = NSCalendar.currentCalendar()
        let comps = NSDateComponents()
        comps.day = 21
        let date2 = calendar.dateByAddingComponents(comps, toDate: openDate, options: NSCalendarOptions.allZeros)
        
            if date.compare(date2!) == NSComparisonResult.OrderedDescending {
                needToPurchase = true
                println("\(date2), today's date is: \(date)")
            }
            else {
                println("Else: \(date2), today's date is: \(date)")
                return
            }
        }
    }
}
