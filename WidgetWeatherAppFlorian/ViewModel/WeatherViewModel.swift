//
//  WeatherViewModel.swift
//  FlorianWeather
//
//  Created by Flrorian Kasperbauer on 2024-11-11.
//
import SwiftUI
import Combine
import CoreLocation

@MainActor
class WeatherViewModel : ObservableObject {
    
    @Published private(set) var currentWeather: WeatherResponse?
    @Published private(set) var storedWeather: WeatherResponse?
    @Published private(set) var hourlyForecasts: [HourlyData] = []
    
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?
    
    private let weatherService : WeatherService
    
    init(weatherService : WeatherService = WeatherService(apiKey: "oHx9m62jbUGleij7WHxyQ49mThpQyrrJ") ){
        self.weatherService = weatherService
    }
    
    func isValidCityName(_ name: String) async -> Bool {
        return await weatherService.isValidCityName(name)
    }
    
    func fetchCityWeather(CityName : String) async {
        isLoading = true
        do {
            currentWeather = try await weatherService.fetchWeatherByCity(city: CityName) //Changed this to current location
            storedWeather = currentWeather
            if let weather = currentWeather {
                hourlyForecasts = Array(weather.timelines.hourly.prefix(7))
            }
            error = nil
        } catch {
            self.error = error
            currentWeather = nil
            hourlyForecasts = []
        }
        isLoading = false
    }
    
    func getWeatherIcon(for code: Int) -> String {
        switch code {
            
        case 1000: return "sun.max" // Clear, Sunny
        case 1001: return "sun.max.fill" // Clear
        case 1100: return "cloud.sun" // Mostly Clear
        case 1101: return "cloud.sun.fill" // Partly Cloudy
        case 1102: return "cloud.fill" // Mostly Cloudy
        case 1103: return "cloud.fill" // Overcast
            
            // Fog/Low Visibility
        case 2000: return "cloud.fog" // Fog
        case 2100: return "cloud.fog.fill" // Light Fog
            
            // Wind
        case 3000: return "wind" // Light Wind
        case 3001: return "wind.circle" // Wind
        case 3002: return "tornado" // Strong Wind
            
            // Rain
        case 4000: return "cloud.drizzle" // Drizzle
        case 4001: return "cloud.rain" // Rain
        case 4200: return "cloud.rain.fill" // Light Rain
        case 4201: return "cloud.heavyrain.fill" // Heavy Rain
            
            // Snow
        case 5000: return "cloud.snow" // Light Snow
        case 5001: return "cloud.snow.fill" // Snow
        case 5100: return "cloud.sleet" // Light Sleet
        case 5101: return "cloud.sleet.fill" // Heavy Sleet
            
            // Freezing Rain
        case 6000: return "cloud.hail" // Freezing Drizzle
        case 6001: return "cloud.hail.fill" // Freezing Rain
        case 6200: return "cloud.hail.circle" // Light Freezing Rain
        case 6201: return "cloud.hail.circle.fill" // Heavy Freezing Rain
            
            // Thunderstorm
        case 8000: return "cloud.bolt" // Thunderstorm
        case 8001: return "cloud.bolt.fill" // Lightning Without Thunder
        case 8002: return "cloud.bolt.rain.fill" // Lightning With Rain
            
        default: return "questionmark.circle"
        }
    }

    func setError(_ error: Error) {
        self.error = error
    }
    
}
