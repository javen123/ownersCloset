//
//  Globals.swift
//  OwnersCloset
//
//  Created by Jim Aven on 5/1/15.
//  Copyright (c) 2015 Jim Aven. All rights reserved.
//

import Foundation
// array for guest places upon request
var gMyGuestPLacesArray = [AnyObject]()

// array for owners upon request
var gMyPlaceResArray = [AnyObject]()

//GeoPoint for Parse/Mapkit
var mapCoord:(Double, Double)!

//push notification
var sendGuestNotification = false
var sendOwnerNotification = false


var purchased = false
var needToPurchase = false
var includedItemsArray = [String : Int]()

var gMyOwnItemsSaved =  [[String : [[String : Int]]]]()

var gKitchenUpdate:[String: [String]]!
var gBathUpdate:[String: [String]]!
var gOutDoorUpdate:[String: [String]]!
var gBarUpdate:[String: [String]]!
var gGameUpdate:[String: [String]]!





    


