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
            
            if let weatherData = viewModel.currentWeather {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Current Weather for \(weatherData.location.name)")
                                    .font(.headline)
                                
                                Text("Temperature: \(String(format: "%.1f", weatherData.timelines.hourly[0].values.temperature))°C")
                                
                                Divider()
                                
                                Text("Next 7 Hours Forecast:")
                                    .font(.subheadline)
                                    .padding(.top)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 20) {
                                        ForEach(viewModel.hourlyForecasts, id: \.time) { hourly in
                                            VStack {
                                                Text(formatTime(hourly.time))
                                                    .font(.caption)
                                                Text("\(String(format: "%.1f", hourly.values.temperature))°C")
                                                    .font(.body)
                                                Image(systemName: viewModel.getWeatherIcon(for: hourly.values.weatherCode))
                                                    .font(.caption)
                                                    .foregroundColor(.secondary)
                                            }
                                            .padding()
                                            .background(Color.gray.opacity(0.1))
                                            .cornerRadius(10)
                                        }
                                    }
                                }
                            }
                            .padding()
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
    
    private func formatTime(_ timeString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        guard let date = formatter.date(from: timeString) else {
            return timeString
        }
        
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
}

