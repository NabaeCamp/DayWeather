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
    
    func getLocation(locationX longitude: Double, locationY latitude: Double, handler: @escaping (GeoLocationModel?) -> Void) {
        let clientID: String = "0rhfpo643h"
        let clientSecretID: String = "lw4kFw37ygyaOqXkfkjaeyO3N7U5zy30Tl6NC524"
        
        let headers = [
            "X-NCP-APIGW-API-KEY-ID": clientID,
            "X-NCP-APIGW-API-KEY": clientSecretID
        ]
        
        let baseUrl = "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc"
        
        let coords = "\(longitude),\(latitude)"
        let urlString = "\(baseUrl)?coords=\(coords)&output=json"
        
        guard let url = URL(string: urlString) else { print("URL이 없습니다"); return }
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("API 호출이 실패했습니다. \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("HTTP Response가 없습니다.")
                return
            }
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let geoLocationModel = try? decoder.decode(GeoLocationModel.self, from: data)
                    handler(geoLocationModel)
                } catch {
                    print("JSON Parsing에 오류가 발생했습니다.")
                }
            } else {
                print("HTTP Request를 실패했습니다. \(httpResponse.statusCode)")
            }
        }
        task.resume()
    }
}
