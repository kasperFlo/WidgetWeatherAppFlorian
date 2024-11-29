// The Swift Programming Language
// https://docs.swift.org/swift-book

 enum WeatherError : Error {
    case invalidURL
    case invalidResponse
    case networkError
    case decodingError
    case locationError
}
