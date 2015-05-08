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

// purchase app 


var purchased = 0

var needToPurchase = false

// owner items

var gMyOwnItemsSaved =  [[String : [[String : Int]]]]()
var gKitchenUpdate:[[String:Int]]!
var gBathUpdate:[[String:Int]]!
var gOutDoorUpdate:[[String:Int]]!
var gBarUpdate:[[String:Int]]!
var gGameUpdate:[[String:Int]]!


//temp items for upload

var kitItems:[String]!
var batItems:[String]!
var barItems:[String]!
var outItems:[String]!
var gameItems:[String]!

var ads = true



