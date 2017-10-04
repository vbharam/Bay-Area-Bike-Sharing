//
//  BikeStationInteractor.swift
//  BikeSharing
//
//  Created by Vishal Bharam on 10/1/17.
//  Copyright © 2017 Vishal Bharam. All rights reserved.
//

import Foundation
import CoreLocation


enum BikeStationInteractorResult {
    case success
    case fail
}

class BikeStationInteractor {

    // To make REST Service call
    private let dataManager = JSONService()
    private var bikeStationData = [BikeStation]()
    var bikeStationDataModel = [BikeStationViewModel]()

    init() {
    }

    func getAllBikeStations(url: String, completionHandler: @escaping(_ response: [BikeStation])-> Void) {
        DispatchQueue.global(qos: .default).async {
            self.dataManager.getData(url: BikeStations_API_URL) { responseJSONData in
                if let json = responseJSONData {
                    // Check the any error returning from Remote API
                    let response = json["stationBeanList"] as! [[String:Any]]
                    if !response.isEmpty {
                        let data = response.map({ (station) -> BikeStation in
                            return BikeStation(id: station["id"] as! Int, stationName: station["stationName"] as! String, availableDocks: station["availableDocks"] as! Int, totalDocks: station["totalDocks"] as! Int, latitude: station["latitude"] as! Double, longitude: station["longitude"] as! Double, statusValue: station["statusValue"] as! String, statusKey: station["statusKey"] as! Int, availableBikes: station["availableBikes"] as! Int, stAddress1: station["stAddress1"] as! String, stAddress2: station["stAddress2"] as! String, city: station["city"] as! String, postalCode: station["postalCode"] as! String, location: station["location"] as! String, altitude: station["altitude"] as! String, testStation: station["testStation"] as! Bool, lastCommunicationTime: station["lastCommunicationTime"] as! String, landMark: station["landMark"] as! String)
                        })

                        completionHandler(data)
                    } else {
                        completionHandler([])
                    }
                } else {
                    completionHandler([])
                }
            }
        }
    }


    func getAllBikeStationModels (completionHandler: @escaping(_ response: [BikeStationViewModel])-> Void) {
        getAllBikeStations(url: BikeStations_API_URL) { (data) in
            self.bikeStationData = data

            self.bikeStationDataModel = self.bikeStationData.map { (station) -> BikeStationViewModel in
                let fullAddress = station.stAddress1 + station.stAddress2
                var stationStatus: BikeStationStatus {
                    if station.availableDocks == 0 { return .Full }
                    if station.availableBikes == 0 { return .Empty }

                    switch station.statusValue {
                    case "In Service":
                        return .InService
                    case "Not In Service":
                        return .NotInService
                    default:
                        return .InService
                    }
                }

                return BikeStationViewModel(uid: station.id, stationName: station.stationName, fullAddress: fullAddress, stationStatus: stationStatus, location: CLLocation(latitude: station.latitude, longitude: station.longitude))
            }
            completionHandler(self.bikeStationDataModel)
        }
    }


    func confirmAddress(address1: String, address2: String,completionHandler: @escaping(_ location: [CLLocation], _ error: BikeStationInteractorResult)-> Void) {
        if (!address1.isEmpty && !address1.isEmpty) {

            var result: [CLLocation] = []

            getLatLongFromAddress(address: address1, completionHandler: { (sourceLocation) in
                if let sourceLocation = sourceLocation {
                    result.append(sourceLocation)
                }

                self.getLatLongFromAddress(address: address2, completionHandler: { (destLocation) in
                    if let destLocation = destLocation {
                        result.append(destLocation)
                        completionHandler(result, .success)
                    } 
                })
            })
        } else {
            completionHandler([], .fail)
        }
    }

    func getBikeStationsWithinBounds(lat1: Double, long1: Double, radius: Float, completionHandler: @escaping(_ response: [BikeStationViewModel], _ error: BikeStationInteractorResult)-> Void) {

        let filterBikeStations = bikeStationDataModel
            .filter { haversineDinstance(la1: lat1, lo1: long1, la2: $0.location.coordinate.latitude, lo2: $0.location.coordinate.longitude) < Double(radius) }

        completionHandler(filterBikeStations, .success)
    }

    private func getLatLongFromAddress(address: String, completionHandler: @escaping(_ location: CLLocation?)-> Void) {

        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard let placemarks = placemarks, let location = placemarks.first?.location else {
                // handle no location found
                return
            }
            completionHandler(location)
        }
        completionHandler(nil)
    }


    private func haversineDinstance(la1: Double, lo1: Double, la2: Double, lo2: Double, radius: Double = 6367444.7) -> Double {

        let haversin = { (angle: Double) -> Double in
            return (1 - cos(angle))/2
        }

        let ahaversin = { (angle: Double) -> Double in
            return 2*asin(sqrt(angle))
        }

        // Converts from degrees to radians
        let dToR = { (angle: Double) -> Double in
            return (angle / 360) * 2 * Double.pi
        }

        let lat1 = dToR(la1)
        let lon1 = dToR(lo1)
        let lat2 = dToR(la2)
        let lon2 = dToR(lo2)
        
        let distInKm = radius * ahaversin(haversin(lat2 - lat1) + cos(lat1) * cos(lat2) * haversin(lon2 - lon1))
        return getDistanceInMiles(from: distInKm)
    }

    private func getDistanceInMiles(from dist: Double) -> Double {
        return dist * 0.621371
    }
}
