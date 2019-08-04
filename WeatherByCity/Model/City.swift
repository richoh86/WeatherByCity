//
//  City.swift
//  WeatherByCity
//
//  Created by richard oh on 2019/08/01.
//  Copyright © 2019 richard oh. All rights reserved.
//

import Foundation

struct City: Decodable {

    let name: String
    let id: Int
    let weather: [Weather]
    let main: Main
    var visibility: Int?
    let wind: Wind
    let sys: Sys
    let timezone: Int
}

struct Weather: Decodable {
    
    let main: String
    let description: String
    let icon: String
    
}

struct Main: Decodable {

    let temp: Float
    let pressure: Float
    let humidity: Float
    let tempMin: Float
    let tempMax: Float
    var seaLevel: Float?
    var grndLevel: Float?

    private enum CodingKeys: String, CodingKey {
        case temp, pressure, humidity
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
    }
}

struct Wind: Decodable {
    var speed: Float?
    var deg: Float?
}

struct Sys: Decodable {
    let sunrise: Float
    let sunset: Float
}
