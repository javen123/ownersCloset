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

private func pfUserToUser(user:PFUser!) -> User {
    
    return User(id: user.objectId!, firstName: user.objectForKey("firstName") as! String, lastName: user.objectForKey("lastName") as! String, email: user.objectForKey("email") as! String, firstDate: user.objectForKey("firstLogDate") as! NSDate, user: user)
}

func curUser() -> User? {
    if let user = PFUser.currentUser() {
        return pfUserToUser(user)
    }
    return nil
}


// Fetch owner and guest places from parse

func fetchUserOwnerPlaces () {
    
    if let user = PFUser.currentUser() {
        
        var guestRelation = user.relationForKey("myGuestPlaces")
        guestRelation.query()?.findObjectsInBackgroundWithBlock({
        objects, error in
        
            if error != nil {
                println(error!.localizedDescription)
                return
            }
            else {
                myGuestPlacesArray.removeAll(keepCapacity: false)
                myGuestPlacesArray = objects!
                println(myGuestPlacesArray)
                
                var ownRelation = user.relationForKey("myOwnPlaces")
                ownRelation.query()?.findObjectsInBackgroundWithBlock({
                    owners, error in
                    if error != nil {
                        println(error!.localizedDescription)
                        return
                    }
                    else {
                        myPlaceResArray.removeAll(keepCapacity: false)
                        myPlaceResArray = owners!
                        println(myPlaceResArray)
                    }
                })
            }
        })
    }
}

// IAP helper

func isReadyToPurchase() {
    let date = NSDate()
    let user = PFUser.currentUser()
    
    let openDate:NSDate = user!.objectForKey("firstLogDate") as! NSDate
    
    
    let calendar = NSCalendar.currentCalendar()
    let comps = NSDateComponents()
    comps.day = 30
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
