//
//  Location.swift
//  BikeSharing
//
//  Created by Vishal Bharam on 9/30/17.
//  Copyright © 2017 Vishal Bharam. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

struct Typealiases {
    typealias JSONDict = [String:Any]
}

class Location {
    static var sharedInstance = Location()

    private init() {}

    var latitude: Double { return self.asCLLocationCoordinate2D.latitude }
    var longitude: Double { return self.asCLLocationCoordinate2D.longitude }

    var currentLocation: CLLocation? { return self.locationManager.location }

    let locationManager = CLLocationManager()

    var asCLLocationCoordinate2D: CLLocationCoordinate2D {
        return self.currentLocation?.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0)
    }

    func getAddress(completion: @escaping (Typealiases.JSONDict) -> ()) {

    }
}
