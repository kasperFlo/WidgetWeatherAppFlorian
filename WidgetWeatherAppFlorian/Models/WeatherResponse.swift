//
//  WeatherResponse.swift
//  FlorianWeather
//
//  Created by Flrorian Kasperbauer on 2024-11-11.
//
import UIKit
 struct WeatherResponse: Codable {
    public let location: Location
    public let current: Current
    
    public init(location: Location, current: Current) {
        self.location = location
        self.current = current
    }
}

 struct Location: Codable {
     let name: String
     let country: String
     let region: String?
     let lat: Double?
     let lon: Double?
}

 struct Current: Codable {
     let tempC: Double
     let condition: Condition
     let humidity: Int
     let windKph: Double
     let feelslikeC: Double
     let isDay: Int
    
    enum CodingKeys: String, CodingKey {
        case tempC = "temp_c"
        case condition
        case humidity
        case windKph = "wind_kph"
        case feelslikeC = "feelslike_c"
        case isDay = "is_day"
    }
}

public struct Condition: Codable {
    public let text: String
    public let icon: String
}
