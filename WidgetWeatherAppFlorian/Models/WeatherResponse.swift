//
//  WeatherResponse.swift
//  FlorianWeather
//
//  Created by Flrorian Kasperbauer on 2024-11-11.
//
import UIKit

public struct WeatherResponse: Codable {
    public let timelines: Timelines
    public let location: Location
    
    public init(timelines: Timelines, location: Location) {
        self.timelines = timelines
        self.location = location
    }
}

public struct Timelines: Codable {
    public let hourly: [HourlyData]
}

public struct HourlyData: Codable {
    public let time: String
    public let values: WeatherValues
}

public struct WeatherValues: Codable {
    public let temperature: Double
    public let humidity: Double
    public let windSpeed: Double
    public let weatherCode: Int
    
    enum CodingKeys: String, CodingKey {
        case temperature
        case humidity
        case windSpeed
        case weatherCode
    }
    
}

public struct Location: Codable {
    public let name: String
    public let lat: Double
    public let lon: Double
}
