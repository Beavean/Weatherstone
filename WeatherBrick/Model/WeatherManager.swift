//
//  WeatherManager.swift
//  WeatherBrick
//
//  Created by Beavean on 26.12.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate: AnyObject {
    func didUpdate(weather: WeatherModel)
    func failedToUpdateWeather()
}

struct WeatherManager {
    // MARK: - Properties

    weak var delegate: WeatherManagerDelegate?
    private let urlComponents: URLComponents = {
        var components = URLComponents()
        components.scheme = Constants.URLComponents.scheme
        components.host = Constants.URLComponents.host
        components.path = Constants.URLComponents.path
        components.queryItems = [
            URLQueryItem(name: Constants.URLComponents.appIdKey, value: Constants.URLComponents.appIdValue),
            URLQueryItem(name: Constants.URLComponents.unitsKey, value: Constants.URLComponents.unitsValue)
        ]
        return components
    }()

    // MARK: - Weather fetch methods
    
    func fetchWeatherUsingSearch(searchQuery: String) {
        var components = urlComponents
        let urlQuery = URLQueryItem(name: Constants.URLComponents.searchQueryKey, value: searchQuery)
        components.queryItems?.append(urlQuery)
        performRequest(with: components.url)
    }

    func fetchWeatherUsingLocation(coordinates: CLLocationCoordinate2D) {
        let latitude = coordinates.latitude
        let longitude = coordinates.longitude
        var components = urlComponents
        let latitudeQuery = URLQueryItem(name: Constants.URLComponents.latitudeQueryKey, value: "\(latitude)")
        let longitudeQuery = URLQueryItem(name: Constants.URLComponents.longitudeQueryKey, value: "\(longitude)")
        components.queryItems?.append(contentsOf: [latitudeQuery, longitudeQuery])
        performRequest(with: components.url)
    }

    // MARK: - Helpers

    private func performRequest(with url: URL?) {
        guard let url else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, _, error in
            if error != nil {
                delegate?.failedToUpdateWeather()
                return
            }
            if let data, let weather = self.parseJSON(data) {
                self.delegate?.didUpdate(weather: weather)
            }
        }
        task.resume()
    }
    
    private func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        var decodedData: WeatherData?
        do {
            decodedData = try decoder.decode(WeatherData.self, from: weatherData)
        } catch {
            delegate?.failedToUpdateWeather()
        }
        guard let decodedData, let id = decodedData.conditionsInfo.first?.id else { return nil }
        let temp = decodedData.mainInfo.temperature
        let cityAndCountryName = decodedData.cityName + ", " + decodedData.additionalInfo.country
        let cityName = decodedData.cityName
        let fullLocationName = decodedData.additionalInfo.country.isEmpty ? cityName : cityAndCountryName
        let weather = WeatherModel(
            cityName: cityName,
            locationName: fullLocationName,
            conditionId: id,
            temperature: temp)
        return weather
    }
}
