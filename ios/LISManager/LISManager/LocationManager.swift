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

private let logger = OSLog(subsystem: "com.nickrobison.iot_list.LISManager.LocationManager", category: "networking")

class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    private let locationManager = CLLocationManager()
    
    @Published var postalCode: String = ""
    
    override init() {
        super.init()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.requestLocation()
        }
    }
    
    public func updateLocation(withCounty county: String) {
        self.postalCode = county
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            os_log("Have new location", log: logger, type: .error)
            let geocoder = CLGeocoder()
            
            geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                if error == nil {
                    let firstLocation = placemarks?[0]
                    self.postalCode = (firstLocation?.postalCode)!
                } else {
                    os_log("Cannot reverse geocode location", log: logger, type: .error)
                }
            })
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        os_log("Get location failed: %s", log: logger, type: .error, error.localizedDescription)
    }
}
