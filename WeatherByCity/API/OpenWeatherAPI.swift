//
//  OpenWeatherAPI.swift
//  WeatherByCity
//
//  Created by richard oh on 2019/08/01.
//  Copyright © 2019 richard oh. All rights reserved.
//

import Foundation

class OpenWeatherAPI {
    
    static let shared = OpenWeatherAPI()
    
    // OpenWeather API Key
    fileprivate let openWeatherApiKey = "3484af2ead84732c2f27141a44f43042"
    
    init() {}
    
    // 해당 위치의 좌표로 날씨 가져오는 API 호출 함수
    func fetchWeatherDataByCoordinate(latitude: Double, longitude: Double, completion: @escaping (City?, Error?) -> ()) {
        let urlString = "http://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&units=metric&APPID=\(openWeatherApiKey)"
        print(urlString)
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, res, err) in
            if let err = err {
                print(err.localizedDescription)
                print("Failed to fetch weather data...")
                return
            }
            do {
                let jsonResult = try JSONDecoder().decode(City.self, from: data!)
                completion(jsonResult, nil)
            } catch let err {
                completion(nil, err)
            }
        }.resume()
    }
}
