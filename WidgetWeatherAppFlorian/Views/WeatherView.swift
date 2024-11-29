//
//  WeatherView.swift
//  WidgetWeatherFlorian
//
//  Created by Flrorian Kasperbauer on 2024-11-28.
//

import SwiftUI
struct WeatherView: View {
    
    @StateObject private var viewModel  = WeatherViewModel()
    @State private var cityName = ""
    @State private var isValidating = false
    @State private var isCityInvalid = false
    
    var body: some View {
        VStack {
            TextField("Enter City Name", text: $cityName)
                .textFieldStyle(.roundedBorder)
                .padding()
                .onSubmit {
                    Task{
                        await validateAndFetchWeather()
                    }
                    
                }
            
            if isValidating {
                ProgressView()
                    .padding()
            } else if isCityInvalid {
                Text("Invalid city name. Please try again.")
                    .foregroundColor(.red)
                    .padding()
            }
            
            if let weatherData = viewModel.storedWeather {
                // Display weather information here
                Text("City: \(weatherData.location.name)")
                Text("Temperature: \(String(format: "%.1f", weatherData.current.tempC))°C")
                Text("Feels Like: \(String(format: "%.1f", weatherData.current.feelslikeC))°C")
            } else {
                // Display loading indicator or error message
                if viewModel.isLoading {
                    ProgressView()
                } else if let error = viewModel.error {
                    Text("Error: \(error.localizedDescription)")
                } else {
                    Text("Enter a city name to view weather.")
                }
            }
        }
        .padding()
    }
    
    private func validateAndFetchWeather() async {
        isValidating = true
        isCityInvalid = false
        
        if await viewModel.isValidCityName(cityName) {
            await viewModel.fetchCityWeather(CityName: cityName)
        } else {
            isCityInvalid = true
            viewModel.setError(WeatherError.invalidResponse)
        }
        isValidating = false
    }
    
}


