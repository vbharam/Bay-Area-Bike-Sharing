//
//  BikeStationViewModel.swift
//  BikeSharing
//
//  Created by Vishal Bharam on 10/3/17.
//  Copyright © 2017 Vishal Bharam. All rights reserved.
//

import Foundation
import MapKit
import Contacts


class BikeStationViewModel: NSObject, MKAnnotation, Comparable {
    var uid: Int = 0
    var stationName: String = ""
    var fullAddress: String = ""
    var stationStatus: BikeStationStatus = .All

    /// Location of the activity (coordinate is an alias) but use of this is prefered
    var location: CLLocation

    init(uid: Int, stationName: String, fullAddress: String, stationStatus: BikeStationStatus, location: CLLocation) {
        self.uid = uid
        self.stationName = stationName
        self.fullAddress = fullAddress
        self.stationStatus = stationStatus
        self.location = location
    }

    // markerTintColor for types
    var markerTintColor: UIColor  {
        switch stationStatus {
        case .InService:
            return .green
        case .Empty, .Full, .NotInService:
            return .red
        case .All:
            return .purple
        }
    }

    // MARK: - MKAnnotation

    /// Coordinate of activity. Alias of `self.location.coordinate`
    var coordinate: CLLocationCoordinate2D { return self.location.coordinate }

    /// Title of activity. Alias of `self.name`
    var title: String? { return self.stationName }

    /// Description of activity. Alias of `self.desx`
    var subtitle: String?

    func isAnnotation(_ annotation: MKAnnotation) -> Bool {
        if let bikeStation = annotation as? BikeStationViewModel {
            return bikeStation == self
        } else {
            return false
        }
    }

    func mapItem() -> MKMapItem {
        let addressDict = [CNPostalAddressStreetKey: fullAddress]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }

    // MARK: - Hashable
    override public var hashValue: Int { return self.uid.hashValue }

    public static func ==(lhs: BikeStationViewModel, rhs: BikeStationViewModel) -> Bool {
        return lhs.uid == rhs.uid
    }

    // MARK: - Comparable
    public static func <(lhs: BikeStationViewModel, rhs: BikeStationViewModel) -> Bool {
        let currentLocation = Location.sharedInstance.currentLocation!
        return lhs.location.distance(from: currentLocation) < rhs.location.distance(from: currentLocation)
    }
}
