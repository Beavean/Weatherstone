//
//  Created by Volodymyr Andriienko on 11/3/21.
//  Copyright © 2021 VAndrJ. All rights reserved.
//

import XCTest
import SnapshotTesting
@testable import WeatherBrick

final class WeatherBrickUITests: XCTestCase {
    // swiftlint:disable implicitly_unwrapped_optional
    private var app: XCUIApplication!
    private lazy var searchButton = app.buttons["SearchButton"]
    private lazy var infoButton = app.buttons["InfoButton"]
    private lazy var hideButton = app.buttons["HideButton"]
    private lazy var infoView = app.otherElements["InfoView"]

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDown() {
        app = nil
        super.tearDown()
    }

    func testWeatherScreen() {
        searchButton.tap()
        app.typeText("eye")
        let result = XCTWaiter.wait(for: [expectation(description: #function)], timeout: 3.0)
        if result == XCTWaiter.Result.timedOut {
            searchButton.tap()
            let weatherViewScreenshot = app.screenshot().image
            assertSnapshot(matching: weatherViewScreenshot, as: .image(precision: 0.99))
        } else {
            XCTFail("Delay interrupted")
        }
    }

    func testInfoViewShowAndHide() {
        let mainViewScreenshot = app.screenshot().image
        infoButton.tap()
        let showResult = XCTWaiter.wait(for: [expectation(description: #function)], timeout: 1.0)
        if showResult == XCTWaiter.Result.timedOut {
            let infoViewSnapshot = self.infoView.screenshot().image
            assertSnapshot(matching: infoViewSnapshot, as: .image(precision: 0.99))
        } else {
            XCTFail("Delay interrupted")
        }
        hideButton.tap()
        let hideResult = XCTWaiter.wait(for: [expectation(description: #function)], timeout: 1.0)
        if hideResult == XCTWaiter.Result.timedOut {
            assertSnapshot(matching: mainViewScreenshot, as: .image(precision: 0.99))
        } else {
            XCTFail("Delay interrupted")
        }
    }
}
