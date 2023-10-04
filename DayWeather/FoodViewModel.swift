//
//  FoodPairingModelView.swift
//  DayWeather
//
//  Created by Jack Lee on 2023/10/02.
//

import Foundation

class FoodViewModel {
    var temperature: String?
    private var dataModel: FoodModel?
    private var term = ""
    
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
    
    func requestAPI() {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        
        var baseURL = URLComponents(string: "https://openapi.naver.com/v1/search/local")
        let param = URLQueryItem(name: "query", value: term)
        let display = URLQueryItem(name: "display", value: "100")
        
        baseURL?.queryItems = [param, display]
        
        guard let url = baseURL?.url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "Get"
        request.setValue("5jZ3ukktUdvCAob0qT3g", forHTTPHeaderField: "X-Naver-Client-Id")
        request.setValue("7GcxPHxBai", forHTTPHeaderField: "X-Naver-Client-Secret")
        
        let task = session.dataTask(with: request) { data, response, error in
            print((response as! HTTPURLResponse).statusCode)
            
            if let hasData = data {
                do {
                    self.dataModel = try JSONDecoder().decode(FoodModel.self, from: hasData)
                    DispatchQueue.main.async {
                        // 가져온 데이터 어떻게 처리를 할까
                        print("마! 이게 데이터다! \(hasData)")
//                        self.tableView.reloadData()
                    }
                } catch {
                    print("오류가 발생했습니다. \(error.localizedDescription)")
                }
            }
        }
        task.resume()
        session.finishTasksAndInvalidate()
    }
}
