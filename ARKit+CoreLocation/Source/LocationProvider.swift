//
//  LocationProvider.swift
//  ARKit+CoreLocation
//
//  Created by Matti Dahlbom on 16/11/2017.
//  Copyright © 2017 Project Dent. All rights reserved.
//

import Foundation
import CoreLocation

/// Defines the callback interface for LocationProvider data
@objc public protocol LocationProviderDelegate: class {
    func locationProviderDidUpdateLocation(_ locationProvider: LocationProvider, location: CLLocation)
    func locationProviderDidUpdateHeading(_ locationProvider: LocationProvider, heading: CLLocationDirection, accuracy: CLLocationDirection)
}

/// Defines a location provider; the outputs (via the delegate) are
/// GPS locations and compass heading values.
@objc public protocol LocationProvider {
    /// Our delegate for data callbacks
    weak var delegate: LocationProviderDelegate? { get set }

    /// Latest location value
    var currentLocation: CLLocation? { get }

    /// Latest heading value
    var heading: CLLocationDirection { get }

    /// Latest heading accuracy value
    var headingAccuracy: CLLocationDegrees { get }
}

