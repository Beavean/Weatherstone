//
//  WeatherData.swift
//  WeatherBrick
//
//  Created by Beavean on 26.12.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import Foundation

struct WeatherData: Decodable {
    let cityName: String
    let mainInfo: MainWeatherInfo
    let conditionsInfo: [WeatherConditionsInfo]
    let additionalInfo: AdditionalWeatherInfo

    enum CodingKeys: String, CodingKey {
        case cityName = "name"
        case mainInfo = "main"
        case conditionsInfo = "weather"
        case additionalInfo = "sys"
    }
}
