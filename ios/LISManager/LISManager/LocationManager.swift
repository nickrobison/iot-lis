//
//  LocationManager.swift
//  LISManager
//
//  Created by Nicholas Robison on 10/16/20.
//

import os
import Foundation
import MapKit
import CoreLocation
import Combine

private let logger = OSLog(subsystem: "com.nickrobison.iot_list.LISManager.LocationManager", category: "networking")

enum LocationError: Error {
    case unknown
    case location(CLError)
    case unauthorized
    case noLocations
}

class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    private let locationManager = CLLocationManager()
    private var isCompleted = false
    
    var postalCode = PassthroughSubject<String, LocationError>()
    
    override init() {
        super.init()
    }
    
    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            os_log("Have new location", log: logger, type: .error)
            let geocoder = CLGeocoder()
            
            geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                if error == nil {
                    guard let firstLocation = placemarks?[0] else {
                        self.postalCode.send(completion: .failure(.noLocations))
                        return
                    }
                    self.postalCode.send(firstLocation.postalCode!)
                    self.postalCode.send(completion: .finished)
                    
                } else {
                    os_log("Cannot reverse geocode location", log: logger, type: .error)
                }
            })
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        guard let clError = error as? CLError else {
            self.postalCode.send(completion: .failure(.unknown))
            return
        }
        self.postalCode.send(completion: .failure(.location(clError)))
    }
}
