//
//  FoodModel.swift
//  DayWeather
//
//  Created by Jack Lee on 2023/10/04.
//

import Foundation

struct GeoLocationModel: Codable {
    let results: [Result]
}

struct Result: Codable {
    let name: String
    let code: Code
    let region: Region
}

struct Code: Codable {
    let id: String
    let type: String
    let mappingId: String
}

struct Region: Codable {
    let area0: Area
    let area1: Area
    let area2: Area
    let area3: Area
    let area4: Area
}

struct Area: Codable {
    let name: String
    let coords: Coords
}

struct Coords: Codable {
    let center: Center
}

struct Center: Codable {
    let crs: String
    let x: Double
    let y: Double
}
