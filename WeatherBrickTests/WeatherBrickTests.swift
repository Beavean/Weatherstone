//
//  Created by Volodymyr Andriienko on 11/3/21.
//  Copyright © 2021 VAndrJ. All rights reserved.
//

import XCTest
@testable import WeatherBrick

class WeatherBrickTests: XCTestCase {
    // swiftlint:disable implicitly_unwrapped_optional force_cast
    private var sut: WeatherViewController!

    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = (storyboard.instantiateViewController(withIdentifier: "WeatherViewController") as! WeatherViewController)
        sut.loadView()
        sut.locationManager.delegate = sut
        sut.weatherManager.delegate = sut
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
    }

    func testSelectedCitySaving() {
        let inputCity = "London"
        sut.selectedCity = inputCity
        sut.saveSelectedCity()
        sut = nil
        sut = WeatherViewController()
        sut.getSelectedCity()
        XCTAssertEqual(inputCity, sut.selectedCity)
    }

    func testFetchWeather() {
        sut.selectedCity = nil
        sut.getWeather()
        let result = XCTWaiter.wait(for: [expectation(description: #function)], timeout: 3)
        if result == XCTWaiter.Result.timedOut {
            XCTAssertNotNil(sut.selectedCity)
        } else {
            XCTFail("Delay interrupted")
        }
    }

    func testFetchWeatherForSelectedCity() {
        let inputCity = "kiev"
        let fetchedCity = "Kyiv"
        sut.selectedCity = inputCity
        sut.getWeather()
        let result = XCTWaiter.wait(for: [expectation(description: #function)], timeout: 3)
        if result == XCTWaiter.Result.timedOut {
            XCTAssertEqual(sut.selectedCity, fetchedCity)
        } else {
            XCTFail("Delay interrupted")
        }
    }
}
