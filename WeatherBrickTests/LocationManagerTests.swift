//
//  LocationManagerTests.swift
//  WeatherBrickTests
//
//  Created by Beavean on 17.01.2023.
//  Copyright © 2023 VAndrJ. All rights reserved.
//

import XCTest
import CoreLocation
@testable import WeatherBrick

final class LocationManagerTests: XCTestCase {
    var hasUpdatedLocation = false
    var expectation: XCTestExpectation?

    override func setUp() {
        super.setUp()
        expectation = expectation(description: "testLocationUpdate")
    }

    override func tearDown() {
        super.tearDown()
        expectation = nil
    }

    func testLocationUpdate() {
        let manager = LocationManager()
        manager.delegate = self
        manager.requestLocation()
        waitForExpectations(timeout: 5)
        XCTAssertTrue(hasUpdatedLocation)
    }
}

// MARK: - LocationManagerDelegate

extension LocationManagerTests: LocationManagerDelegate {
    func failedToUpdateLocation() {
        if expectation != nil {
            self.hasUpdatedLocation = false
        }
        expectation?.fulfill()
    }

    func didUpdateLocationWith(coordinates: CLLocationCoordinate2D) {
        if expectation != nil {
            self.hasUpdatedLocation = true
        }
        expectation?.fulfill()
    }
}
