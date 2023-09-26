//
//  MainViewModel.swift
//  DayWeather
//
//  Created by cheshire on 2023/09/25.
//

import Foundation

class WeatherViewModel {

    var cityName: String?
    var temperature: String? // 온도를 String으로 저장

    // MARK: - 변경 사항 - 싱글톤 패턴의 사용
    private var weatherDataManager = WeatherDataManager.shared // 싱글턴 인스턴스 사용

    func fetchAndProcessWeatherData(lat: Double, lon: Double, completion: @escaping () -> Void) {
        weatherDataManager.processWeatherData(lat: lat, lon: lon) { [weak self] (city, temp, error) in
            if let error = error {
                print("Error processing weather data: \(error.localizedDescription)")
                return
            }

            self?.cityName = city
            self?.temperature = temp
            completion()
        }
    }
}
