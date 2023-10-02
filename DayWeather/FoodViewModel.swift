//
//  FoodPairingModelView.swift
//  DayWeather
//
//  Created by Jack Lee on 2023/10/02.
//

import Foundation

class FoodViewModel {
    var temperature: String?
    
    private var weatherDataManager = WeatherDataManager.shared // 싱글턴 인스턴스 사용
    
    func fetchWeatherData(lat: Double, lon: Double, completion: @escaping () -> Void) {
        weatherDataManager.processWeatherData(lat: lat, lon: lon) { [weak self] (city, temp, error) in
            if let error = error {
                print("Error processing weather data: \(error.localizedDescription)")
                return
            }
            
            self?.temperature = temp
            completion()
        }
    }
}
