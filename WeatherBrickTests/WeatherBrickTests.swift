//
//  Created by Volodymyr Andriienko on 11/3/21.
//  Copyright © 2021 VAndrJ. All rights reserved.
//

import XCTest
@testable import WeatherBrick

final class WeatherBrickTests: XCTestCase {
    // swiftlint:disable implicitly_unwrapped_optional force_cast
    private var sut: WeatherViewController!

    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = (storyboard.instantiateViewController(withIdentifier: "WeatherViewController") as! WeatherViewController)
        sut.loadView()
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
    }

    func testSelectedCitySaving() {
        let inputCity = "London"
        sut.selectedCity = inputCity
        sut = nil
        sut = WeatherViewController()
        sut.getSelectedCity()
        XCTAssertEqual(inputCity, sut.selectedCity)
    }
}
