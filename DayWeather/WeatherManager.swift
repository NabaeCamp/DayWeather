//
//  WeatherManager.swift
//  DayWeather
//
//  Created by cheshire on 2023/09/25.
//

import Foundation

struct WeatherData: Codable {
    let coord: Coordinate
    let weather: [Weather]
    let main: Main
    let visibility: Int
    let wind: Wind
    let rain: Rain?
    let clouds: Clouds
    let dt: Int
    let sys: Sys
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
}

struct Coordinate: Codable {
    let lon: Double
    let lat: Double
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Main: Codable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Int
    let humidity: Int
    let sea_level: Int?
    let grnd_level: Int?
}

struct Wind: Codable {
    let speed: Double
    let deg: Int
    let gust: Double?
}

struct Rain: Codable {
    let h1: Double?
}

struct Clouds: Codable {
    let all: Int
}

struct Sys: Codable {
    let type: Int
    let id: Int
    let country: String
    let sunrise: Int
    let sunset: Int
}


class WeatherDataManager {
    let baseURL = "https://api.openweathermap.org/data/2.5/weather"

    private var apiKey: String {
        get {
            // 생성한 .plist 파일 경로 불러오기
            guard let filePath = Bundle.main.path(forResource: "Property List", ofType: "plist") else {
                fatalError("Couldn't find file 'Property List.plist'.")
            }

            // .plist를 딕셔너리로 받아오기
            let plist = NSDictionary(contentsOfFile: filePath)

            // 딕셔너리에서 값 찾기
            guard let value = plist?.object(forKey: "openweathermap_KEY") as? String else {
                fatalError("Couldn't find key 'openweathermap_KEY' in 'Property List.plist'.")
            }
            return value
        }
    }


    func fetchWeatherData(lat: Double, lon: Double, completion: @escaping (WeatherData?, Error?) -> Void) {
        let urlString = "\(baseURL)?lat=\(lat)&lon=\(lon)&appid=\(apiKey)"
        guard let url = URL(string: urlString) else {
            completion(nil, NSError(domain: "Invalid URL", code: 400, userInfo: nil))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Request Error: \(error.localizedDescription)")  // 요청 에러 출력
                completion(nil, error)
                return
            }

            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let weatherData = try decoder.decode(WeatherData.self, from: data)
                    print("Fetched Weather Data: \(weatherData)")  // 성공적으로 가져온 날씨 데이터 출력
                    completion(weatherData, nil)
                } catch {
                    print("Decoding Error: \(error.localizedDescription)")  // 디코딩 에러 출력
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }

}

