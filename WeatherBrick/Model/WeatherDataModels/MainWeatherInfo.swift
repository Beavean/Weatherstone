//
//  MainWeatherInfo.swift
//  WeatherBrick
//
//  Created by Beavean on 10.01.2023.
//  Copyright © 2023 VAndrJ. All rights reserved.
//

import Foundation

struct MainWeatherInfo: Decodable {
    let temperature: Double

    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
    }
}
