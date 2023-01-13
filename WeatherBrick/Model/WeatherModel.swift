//
//  WeatherModel.swift
//  WeatherBrick
//
//  Created by Beavean on 26.12.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import Foundation

struct WeatherModel: Codable {
    let cityName: String
    let locationName: String
    let conditionId: Int
    let temperature: Double
    
    var temperatureString: String {
        return String(format: "%.1f", temperature) + "º"
    }
    
    var condition: WeatherCondition {
        switch conditionId {
        case 200...531:
            return temperature > 0.0 ? .rain : .snow
        case 600...622:
            return temperature > 0.0 ? .rain : .snow
        case 701...762:
            return .fog
        case 771...781:
            return .wind
        case 800:
            return temperature < 25.0 ? .sunny : .hot
        case 801...804:
            return .sunny
        default:
            return .sunny
        }
    }
}
