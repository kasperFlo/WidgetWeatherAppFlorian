//
//  WeatherService.swift
//  WidgetWeatherFlorian
//
//  Created by Flrorian Kasperbauer on 2024-11-28.
//
import Foundation
import CoreLocation

 class WeatherService {
    private let baseURL = "https://api.tomorrow.io/v4/weather/forecast"
    private let apiKey: String
    
     init(apiKey: String) {
        self.apiKey = apiKey
    }
    
     public func fetchWeatherByCity(city: String) async throws -> WeatherResponse {
         
         guard let url = URL(string : "\(baseURL)?location=\(city)&units=metric&timesteps=1h&apikey=\(apiKey)") else {
             throw WeatherError.invalidURL
         }
         
         do {
             print(url)
             let (data, response) = try await URLSession.shared.data(from: url)
             
             guard let httpResponse = response as? HTTPURLResponse,
                   (200...299).contains(httpResponse.statusCode) else {
                 throw WeatherError.invalidResponse
             }
             
             let decoder = JSONDecoder()
             return try decoder.decode(WeatherResponse.self, from: data)
         } catch {
             throw WeatherError.networkError
         }
         
     }
     
     func isValidCityName(_ name: String) async -> Bool {
        guard !name.isEmpty else { return false }
        do {
            _ = try await fetchWeatherByCity(city: name)
            return true
        } catch {
            return false
        }
    }
     
     
}

