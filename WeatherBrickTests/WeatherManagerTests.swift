//
//  WeatherManagerTests.swift
//  WeatherBrickTests
//
//  Created by Beavean on 17.01.2023.
//  Copyright © 2023 VAndrJ. All rights reserved.
//

import XCTest
import CoreLocation
@testable import WeatherBrick

final class WeatherManagerTests: XCTestCase {
    var weather: WeatherModel?
    var expectation: XCTestExpectation?

    override func setUp() {
        super.setUp()
        expectation = expectation(description: "testWeatherManager")
    }

    override func tearDown() {
        super.tearDown()
        expectation = nil
    }

    func testUpdateWeatherUsingSearch() {
        var manager = WeatherManager()
        let cityName = "London"
        manager.delegate = self
        manager.fetchWeatherUsingSearch(searchQuery: "London")
        waitForExpectations(timeout: 10)
        XCTAssertEqual(cityName, weather?.cityName)
    }

    func testUpdateWeatherUsingLocation() {
        var manager = WeatherManager()
        let cityName = "Abbey Wood"
        let coordinates = CLLocationCoordinate2D(latitude: 51.5072, longitude: 0.1276)
        manager.delegate = self
        manager.fetchWeatherUsingLocation(coordinates: coordinates)
        waitForExpectations(timeout: 10)
        XCTAssertEqual(cityName, weather?.cityName)
    }
}

// MARK: - LocationManagerDelegate

extension WeatherManagerTests: WeatherManagerDelegate {
    func didUpdate(weather: WeatherBrick.WeatherModel) {
        if expectation != nil {
            self.weather = weather
        }
        expectation?.fulfill()
    }

    func failedToUpdateWeather() {
        if expectation != nil {
            self.weather = nil
        }
        expectation?.fulfill()
    }
}
