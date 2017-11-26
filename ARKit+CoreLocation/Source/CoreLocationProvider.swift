//
//  LocationManager.swift
//  ARKit+CoreLocation
//
//  Created by Andrew Hart on 02/07/2017.
//  Copyright © 2017 Project Dent. All rights reserved.
//

import Foundation
import CoreLocation

/// CoreLocation (using CLLocationManager) implementation for LocationProvider.
///
/// Handles retrieving the location and heading from CoreLocation
/// Does not contain anything related to ARKit or advanced location
@objc class CoreLocationProvider: NSObject, CLLocationManagerDelegate, LocationProvider {
    weak var delegate: LocationProviderDelegate?
    
    private var locationManager: CLLocationManager?
    
    var currentLocation: CLLocation?
    
    var heading: CLLocationDirection = 0
    var headingAccuracy: CLLocationDegrees = 0
    
    override init() {
        super.init()
        
        self.locationManager = CLLocationManager()
        self.locationManager!.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        self.locationManager!.distanceFilter = kCLDistanceFilterNone
        self.locationManager!.headingFilter = kCLHeadingFilterNone
        self.locationManager!.pausesLocationUpdatesAutomatically = false
        self.locationManager!.delegate = self
        self.locationManager!.startUpdatingHeading()
        self.locationManager!.startUpdatingLocation()
        
        self.locationManager!.requestWhenInUseAuthorization()
        
        self.currentLocation = self.locationManager!.location
    }

    //TODO not used - remove or use?
//    func requestAuthorization() {
//        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways ||
//            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse {
//            return
//        }
//
//        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.denied ||
//            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.restricted {
//            return
//        }
//
//        self.locationManager?.requestWhenInUseAuthorization()
//    }

    //MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for location in locations {
            self.delegate?.locationProviderDidUpdateLocation(self, location: location)
        }
        
        self.currentLocation = manager.location
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        if newHeading.headingAccuracy >= 0 {
            self.heading = newHeading.trueHeading
        } else {
            self.heading = newHeading.magneticHeading
        }
        
        self.headingAccuracy = newHeading.headingAccuracy
        
        self.delegate?.locationProviderDidUpdateHeading(self, heading: self.heading, accuracy: newHeading.headingAccuracy)
    }
    
    func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
        return true
    }
}

