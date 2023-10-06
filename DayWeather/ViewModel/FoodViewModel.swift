//
//  FoodPairingModelView.swift
//  DayWeather
//
//  Created by Jack Lee on 2023/10/02.
//

import Foundation

class FoodViewModel {
    private var weatherDataManager = WeatherDataManager.shared
    var temperature: String?
    var queryData: QueryModel?
    var foodPairing: [FoodPairing] = []
    
    // 날씨 데이터 호출
    func fetchWeatherData(lon: Double, lat: Double, completion: @escaping () -> Void) {
        weatherDataManager.processWeatherData(lat: lat, lon: lon) { [weak self] (city, temp, error) in
            if let error = error {
                print("Error processing weather data: \(error.localizedDescription)")
                return
            }
            self?.temperature = temp
            completion()
        }
    }
    
    // 지역 API 호출 함수
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
    
    func requestFoodAPI(location: GeoLocationModel, food: String? = nil, completion: @escaping () -> Void) {
        let detailLocation = location.results[0].region.area2.name
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        
        var baseURL = URLComponents(string: "https://openapi.naver.com/v1/search/local")
        let param = URLQueryItem(name: "query", value: "\(detailLocation) \(food!)")
        let display = URLQueryItem(name: "display", value: "10")
        
        baseURL?.queryItems = [param, display]
        guard let url = baseURL?.url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("5jZ3ukktUdvCAob0qT3g", forHTTPHeaderField: "X-Naver-Client-Id")
        request.setValue("7GcxPHxBai", forHTTPHeaderField: "X-Naver-Client-Secret")
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error as? HTTPURLResponse {
                print("에러가 발생했습니다. \(error.statusCode)")
            }
            
            if let response = response as? HTTPURLResponse {
                print("확인되는 reponse는 아래와 같습니다 \(response.statusCode)")
            }
            
            if let hasData = data {
                print(String(data: hasData, encoding: .utf8))
                do {
                    let decoder = JSONDecoder()
                    if let queryModel = try? decoder.decode(QueryModel.self, from: hasData) as QueryModel {
                        self.queryData = queryModel
                        completion()
                    }
                } catch {
                    print(error)
                }
            }
        }
        task.resume()
        session.finishTasksAndInvalidate()
    }
}
