//
//  MainViewModel.swift
//  DayWeather
//
//  Created by cheshire on 2023/09/25.
//

import Foundation

//enum TemperatureRange {
//
//    case freezing
//    case cold
//    case moderate
//    case warm
//    case hot
//    case scorching
//
//    func getDescription() -> String {
//        switch self {
//        case .freezing:
//            return "It's freezing!"
//        case .cold:
//            return "It's cold."
//        case .moderate:
//            return "The temperature is moderate."
//        case .warm:
//            return "It's warm."
//        case .hot:
//            return "It's hot!"
//        case .scorching:
//            return "It's scorching!"
//        }
//    }
//}


protocol WearingDelegate:AnyObject {
    
    func updateView()
    
}

class WearingViewModel {
    
    weak var delegate:WearingDelegate?
    
    var cityName: String?
    
    var temperature: String? {
        didSet {
            delegate?.updateView()
        }
    } // 온도를 String으로 저장
    
    // MARK: - 변경 사항 - 싱글톤 패턴의 사용
    private var weatherDataManager = WeatherDataManager.shared // 싱글턴 인스턴스 사용
    
    func fetchAndProcessWeatherData(lat: Double, lon: Double, completion: @escaping () -> Void) {
        weatherDataManager.processWearingData(lat: lat, lon: lon) { [weak self] (temp, error) in
            if let error = error {
                print("Error processing weather data: \(error.localizedDescription)")
                return
            }
            
            self?.temperature = temp
            completion()
            
//            DispatchQueue.main.async {
//                completion()
//            }
        }
    }
}

