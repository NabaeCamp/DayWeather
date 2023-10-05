//
//  PlayListViewModel.swift
//  DayWeather
//
//  Created by 랑 on 2023/10/05.
//

import UIKit

class PlayListViewModel {
    
    private var weatherDataManager = WeatherDataManager.shared
    
    func getDataForPlayListView(lat: Double, lon: Double, completion: @escaping (UIImage?, String?, UIImage?) -> Void) {
        weatherDataManager.fetchWeatherData(lat: lat, lon: lon) { [weak self] (data, _)  in
            guard let self else { return }
            guard let data = data else { return }
            
            let celsiusTemperature = data.main.feels_like - 273.15
            let sunriseTime = Date(timeIntervalSince1970: TimeInterval(data.sys.sunrise))
            let sunsetTime = Date(timeIntervalSince1970: TimeInterval(data.sys.sunset))
            let currentTime = Date()
            
            if celsiusTemperature < 5 && data.weather.first?.main != "Rain" {
                //추운 날
                completion(UIImage(named: "winterImage"), "얼어 죽겠어요🥶", UIImage(named: "coldIcon"))
            } else if celsiusTemperature > 30 && data.weather.first?.main != "Rain" {
                //더운 날
                completion(UIImage(named: "summerImage"), "너무 더워요🥵", UIImage(named: "sunIcon"))
            } else if data.weather.first?.main == "Rain" {
                //비오는 날
                completion(UIImage(named: "rainImage"), "비가 내리네요", UIImage(named: "rainIcon2"))
            } else if currentTime >= calculateSunTime(sunriseTime) && currentTime <= sunriseTime {
                //일출 30분 전부터 일출 때까지
                completion(UIImage(named: "sunriseImage"), "같이 일출 구경할까요?", UIImage(named: "sunriseIcon"))
            } else if currentTime >= calculateSunTime(sunsetTime) && currentTime <= sunsetTime {
                //일몰 30분 전부터 일출 때까지
                completion(UIImage(named: "sunsetImage"), "같이 일몰 구경할까요?", UIImage(named: "sunsetIcon"))
            } else {
                //변경하기
                completion(UIImage(named: "summerImage"), "너무 더워요🥵", UIImage(named: "sunIcon"))
            }
        }
    }
    
    private func calculateSunTime(_ date: Date) -> Date {
        let thirtyMinutesBeforeSunTime = date.addingTimeInterval(-30 * 60)
        return thirtyMinutesBeforeSunTime
    }
}
