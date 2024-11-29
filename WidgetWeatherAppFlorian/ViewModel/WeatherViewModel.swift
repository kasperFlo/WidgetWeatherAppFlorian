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
    
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?
    
    private let weatherService : WeatherService
    
    init(weatherService : WeatherService = WeatherService(apiKey: "f9a1729049664ed6bc021706241211") ){
        self.weatherService = weatherService
    }
    
    func isValidCityName(_ name: String) async -> Bool {
        return await weatherService.isValidCityName(name)
    }
    
    func fetchCityWeather(CityName : String) async {
        Task {
            isLoading = true
            do {
                currentWeather = try await weatherService.fetchWeatherByCity(city: CityName) //Changed this to current location
                storedWeather = currentWeather
                
                error = nil
            } catch {
                self.error = error
                currentWeather = nil
            }
            isLoading = false
        }
    }
    
    func setError(_ error: Error) {
        self.error = error
    }
    
}
