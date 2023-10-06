//
//  MainViewModel.swift
//  DayWeather
//
//  Created by cheshire on 2023/09/25.
//

import Foundation

protocol WearingDelegate:AnyObject {
    
    func updateView()
    
}

class WearingViewModel {
    
    weak var delegate:WearingDelegate?
    
    var cityName: String?
    
    var condition: String?
    
    var temperature: String? {
        didSet {
            delegate?.updateView()
        }
    } // 온도를 String으로 저장
    
    // MARK: - 변경 사항 - 싱글톤 패턴의 사용
    private var weatherDataManager = WeatherDataManager.shared // 싱글턴 인스턴스 사용
    
    func fetchAndProcessWeatherData(lat: Double, lon: Double, completion: @escaping () -> Void) {
        weatherDataManager.processWearingData(lat: lat, lon: lon) { [weak self] (temp,condition, error) in
            if let error = error {
                print("Error processing weather data: \(error.localizedDescription)")
                return
            }
            
            self?.temperature = temp
            self?.condition = condition
            
            completion()
        }
    }
}

