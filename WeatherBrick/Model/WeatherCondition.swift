//
//  WeatherCondition.swift
//  WeatherBrick
//
//  Created by Beavean on 11.01.2023.
//  Copyright © 2023 VAndrJ. All rights reserved.
//

import Foundation

enum WeatherCondition: CaseIterable {
    case rain
    case sunny
    case fog
    case hot
    case snow
    case wind
    case empty

    var infoLabelText: String {
        switch self {
        case .rain:
            return "Brick is wet - raining"
        case .sunny:
            return "Brick is dry - sunny"
        case .fog:
            return "Brick is hard to see - fog"
        case .hot:
            return "Brick with cracks - very hot"
        case .snow:
            return "Brick with snow - snow"
        case .wind:
            return "Brick is swinging - windy"
        case .empty:
            return "Brick is gone - No internet"
        }
    }

    var weatherConditionLabelText: String {
        switch self {
        case .rain:
            return "rain"
        case .sunny:
            return "sunny"
        case .fog:
            return "fog"
        case .hot:
            return "hot"
        case .snow:
            return "snow"
        case .wind:
            return "wind"
        case .empty:
            return ""
        }
    }

    var imageName: String {
        switch self {
        case .rain:
            return "image_stone_wet"
        case .sunny:
            return "image_stone_normal"
        case .fog:
            return "image_stone_normal"
        case .hot:
            return "image_stone_cracks"
        case .snow:
            return "image_stone_snow"
        case .wind:
            return "image_stone_normal"
        case .empty:
            return "image_stone_normal"
        }
    }
}
