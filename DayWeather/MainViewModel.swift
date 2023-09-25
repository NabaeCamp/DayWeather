//
//  MainViewModel.swift
//  DayWeather
//
//  Created by cheshire on 2023/09/25.
//

import Foundation

class WeatherViewModel {
    private var weatherDataManager = WeatherDataManager()
    var temperature: String? // 온도를 String으로 저장

    // 날씨 데이터를 가져오는 메서드
    func fetchWeatherData(lat: Double, lon: Double, completion: @escaping () -> Void) {
        weatherDataManager.fetchWeatherData(lat: lat, lon: lon) { [weak self] (data, error) in
            if let error = error {
                print("Error fetching weather data: \(error.localizedDescription)")
                return
            }

            if let data = data {
                let celsiusTemperature = data.main.temp - 273.15
                self?.temperature = "\(Int(celsiusTemperature))º"
                completion()
            }

        }
    }
}
