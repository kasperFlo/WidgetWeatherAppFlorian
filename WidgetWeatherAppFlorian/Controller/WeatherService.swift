//
//  WeatherService.swift
//  WidgetWeatherFlorian
//
//  Created by Flrorian Kasperbauer on 2024-11-28.
//
import Foundation
import CoreLocation

 class WeatherService {
    private let baseURL = "https://api.weatherapi.com/v1"
    private let apiKey: String
    
     init(apiKey: String) {
        self.apiKey = apiKey
    }
    
     func fetchWeatherByCity(city: String) async throws -> WeatherResponse {
        guard let url = URL(string: "\(baseURL)/current.json?key=\(apiKey)&q=\(city)")
        else { throw WeatherError.invalidURL }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode)
            else { throw WeatherError.invalidResponse }
            
            let decoder = JSONDecoder()
            return try decoder.decode(WeatherResponse.self, from: data)
        } catch let error as DecodingError {
            throw WeatherError.decodingError
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

