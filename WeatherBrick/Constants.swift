//
//  Constants.swift
//  WeatherBrick
//
//  Created by Beavean on 30.12.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import UIKit

enum Constants {
    enum UserDefaults {
        static let selectedCityKey = "selectedCity"
    }

    enum UserInterface {
        static let baseCornerRadius: CGFloat = 15
        static let mainLightFontName = "SF Pro Display Light"
        static let mainSemiboldFontName = "SF Pro Display Semibold"
    }

    enum URLComponents {
        static let scheme = "https"
        static let host = "api.openweathermap.org"
        static let path = "/data/2.5/weather"
        static let appIdKey = "appid"
        static let appIdValue = "4339d45edaace5c33af4112d3f83272e"
        static let unitsKey = "units"
        static let unitsValue = "metric"
        static let searchQueryKey = "q"
        static let latitudeQueryKey = "lat"
        static let longitudeQueryKey = "lon"
    }
}
