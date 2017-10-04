//
//  BikeStation.swift
//  BikeSharing
//
//  Created by Vishal Bharam on 10/1/17.
//  Copyright © 2017 Vishal Bharam. All rights reserved.
//

import Foundation

enum BikeStationStatus {
    case InService
    case Empty
    case Full
    case NotInService
    case All
}



struct BikeStation {
    var id: Int
    var stationName: String
    var availableDocks: Int
    var totalDocks: Int
    var latitude: Double
    var longitude: Double
    var statusValue: String
    var statusKey: Int
    var availableBikes: Int
    var stAddress1: String
    var stAddress2: String
    var city: String
    var postalCode: String
    var location: String
    var altitude: String
    var testStation: Bool
    var lastCommunicationTime: String
    var landMark: String
}

