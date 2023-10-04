//
//  FoodPairingModelView.swift
//  DayWeather
//
//  Created by Jack Lee on 2023/10/02.
//

import Foundation

class FoodViewModel {
    var temperature: String?
    private var weatherDataManager = WeatherDataManager.shared
    private let clientID: String = "0rhfpo643h"
    private let clientSecretID: String = "lw4kFw37ygyaOqXkfkjaeyO3N7U5zy30Tl6NC524"
    
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
    
    func requestGeolocation(locationX longitude: Double, locationY latitude: Double) {
        let baseUrl = "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc"
        let urlString = "\(baseUrl)?request=coordstoaddr&coords=\(longitude),\(latitude)&output=json"
        guard let url = URL(string: urlString) else { print("URL이 없습니다.")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(clientID, forHTTPHeaderField: "X-NCP-APIGW-API-KEY-ID")
        request.setValue(clientSecretID, forHTTPHeaderField: "X-NCP-APIGW-API-KEY")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error { print("API 요청 실패, \(error.localizedDescription)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                let statusCode = httpResponse.statusCode
                print("상태는 이렇습니다. \(statusCode)")
            }
            
            if let data = data {
                do {
                    let locationData = try JSONDecoder().decode(FoodModel.self, from: data)
                    if let results = locationData.results.first {
                        let address = results.region.area1.name + " " + results.region.area2.name
                        print("좌표의 주소는 \(address)")
                    } else {
                        print("주소 정보를 찾을 수 없습니다.")
                    }
                } catch {
                    print("JSON Parsing 오류가 발생했습니다. \(error.localizedDescription)")
                }
            }
        }
        task.resume()
    }
}
