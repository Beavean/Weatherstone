//
//  WeatherConditionsInfo.swift
//  WeatherBrick
//
//  Created by Beavean on 10.01.2023.
//  Copyright © 2023 VAndrJ. All rights reserved.
//

import Foundation

struct WeatherConditionsInfo: Decodable {
    let condition: String
    let id: Int

    enum CodingKeys: String, CodingKey {
        case condition = "main"
        case id
    }
}
