//
//  LocationManager.swift
//  WeatherBrick
//
//  Created by Beavean on 16.01.2023.
//  Copyright © 2023 VAndrJ. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationManagerDelegate: AnyObject {
    func failedToUpdateLocation()
    func didUpdateLocationWith(coordinates: CLLocationCoordinate2D)
}

final class LocationManager: NSObject, CLLocationManagerDelegate {
    private let locationProvider = CLLocationManager()
    weak var delegate: LocationManagerDelegate?

    func requestPermission() {
        locationProvider.requestWhenInUseAuthorization()
    }

    func requestLocation() {
        locationProvider.requestLocation()
    }

    override init() {
        super.init()
        self.locationProvider.delegate = self
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last?.coordinate else { return }
        locationProvider.stopUpdatingLocation()
        self.delegate?.didUpdateLocationWith(coordinates: location)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.delegate?.failedToUpdateLocation()
    }
}
