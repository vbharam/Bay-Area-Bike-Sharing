//
//  MainViewController.swift
//  BikeSharing
//
//  Created by Vishal Bharam on 9/30/17.
//  Copyright © 2017 Vishal Bharam. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class MainViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchView: UIView!

    @IBOutlet weak var sourceLocation: MaterialTextField!
    @IBOutlet weak var destLocation: MaterialTextField!
    @IBOutlet weak var radiusSlider: UISlider!
    @IBOutlet weak var goButton: MaterialButtonView!

    var interactor: BikeStationInteractor!
    var initialData = [BikeStationViewModel]()
    var filteredData = [BikeStationViewModel]()
    var overLays = [MKCircle]()
    var currentLocation: CLLocationCoordinate2D!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        interactor = BikeStationInteractor()

        let initialLocation = CLLocation(latitude: Location.sharedInstance.latitude, longitude: Location.sharedInstance.latitude)
        let regionRadius: CLLocationDistance = 250
        centerMapOnLocation(location: initialLocation, regionRadius: regionRadius)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        mapView.delegate = self
        mapView.camera.pitch = 60
        mapView.setUserTrackingMode(.followWithHeading, animated: false)

        // Annotation:
        interactor.getAllBikeStationModels { (data) in
            self.initialData = data
            self.mapView.addAnnotations(self.initialData)
        }
    }

    func centerMapOnLocation(location: CLLocation, regionRadius: CLLocationDistance) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }

    /// MARK: MKMapView:
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? BikeStationViewModel else { return nil }
        let identifier = "marker"

        var view: MKPinAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKPinAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.pinTintColor = annotation.markerTintColor
            let mapsButton = UIButton(frame: CGRect(origin: CGPoint.zero,
                                                    size: CGSize(width: 30, height: 30)))
            mapsButton.setBackgroundImage(UIImage(named: "Maps-icon"), for: UIControlState())
            view.rightCalloutAccessoryView = mapsButton
        }
        return view
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! BikeStationViewModel
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDefault]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKCircleRenderer(overlay: overlay)
        renderer.fillColor = UIColor.gray.withAlphaComponent(0.1)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 2
        return renderer
    }


    func loadMapView(withCoord cords: CLLocationCoordinate2D, withRadius radius: Float, stations: [BikeStationViewModel], withIcon icon: String) {

        filteredData.append(contentsOf: stations)
        mapView.addAnnotations(stations)

        let overlay = MKCircle(center: cords, radius: Double(radius * 1.5)) // 1.5 is added for UI purpose only

        overLays.append(overlay)
        mapView.add(overlay)

        for station in stations {
            // Check if contains point to prevent duplicate annotations
            if !self.mapView.annotations.contains(where: station.isAnnotation) {
                mapView.addAnnotation(station)
            }
        }
    }

    @IBAction func findNearbyLocation(_ sender: Any) {
        let sourceAddress = sourceLocation.text ?? ""
        let destAddress = destLocation.text ?? ""
        let radius = radiusSlider.value * 100.0

        interactor.confirmAddress(address1: sourceAddress, address2: destAddress) { (locations, status) in
            if status == .success &&  locations.count >= 2 {

                self.mapView.removeAnnotations(self.initialData)
                self.mapView.removeAnnotations(self.filteredData)
                self.mapView.removeOverlays(self.overLays)

                let home = locations[0]
                self.updateUI(withLat: (home.coordinate.latitude), andLong: (home.coordinate.longitude), withRadius: radius, withIcon: "Home")

                let dest = locations[1]
                self.updateUI(withLat: (dest.coordinate.latitude), andLong: (dest.coordinate.longitude), withRadius: radius, withIcon: "Star")
            } else {
                let alertVC = UIAlertController(title: "Invalid Address", message: "Please Confirm both addresses", preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alertVC, animated: true, completion: nil)
            }
        }
    }


    func updateUI(withLat lat: Double, andLong long: Double, withRadius radius: Float, withIcon icon: String) {

        interactor.getBikeStationsWithinBounds(lat1: lat, long1: long, radius: radius) { (bikeStations, status) in
            if status == .success {
                let coord = CLLocationCoordinate2D(latitude: lat, longitude: long)

                // custom Pin:
                let pointAnnotation = MKPointAnnotation()
                pointAnnotation.coordinate = coord
                pointAnnotation.title = icon == "Home" ? icon : "Destination"
                self.mapView.addAnnotation(pointAnnotation)

                self.loadMapView(withCoord: coord, withRadius: radius, stations: bikeStations, withIcon: icon)
            } else {
                self.present(UIAlertController(title: "Eroor", message: "Bike station data is not available", preferredStyle: .alert), animated: true)
            }
        }

    }
}

