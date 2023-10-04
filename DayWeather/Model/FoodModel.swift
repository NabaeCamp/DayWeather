//
//  FoodModel.swift
//  DayWeather
//
//  Created by Jack Lee on 2023/10/04.
//

import Foundation

// MARK: - Welcome
struct FoodModel: Codable {
    let status: Status
    let results: [Result]
}

// MARK: - Result
struct Result: Codable {
    let name: String
    let code: Code
    let region: Region
}

// MARK: - Code
struct Code: Codable {
    let id, type, mappingID: String

    enum CodingKeys: String, CodingKey {
        case id, type
        case mappingID = "mappingId"
    }
}

// MARK: - Region
struct Region: Codable {
    let area0: Area
    let area1: Area1
    let area2, area3, area4: Area
}

// MARK: - Area
struct Area: Codable {
    let name: String
    let coords: Coords
}

// MARK: - Coords
struct Coords: Codable {
    let center: Center
}

// MARK: - Center
struct Center: Codable {
    let crs: CRS
    let x, y: Double
}

enum CRS: String, Codable {
    case empty = ""
    case epsg4326 = "EPSG:4326"
}

// MARK: - Area1
struct Area1: Codable {
    let name: String
    let coords: Coords
    let alias: String
}

// MARK: - Status
struct Status: Codable {
    let code: Int
    let name, message: String
}

//struct FoodModel: Codable {
//    let code: Int
//    let name: String
//    let message: String
//}
//
//struct Result: Codable {
//    let name: String
//    let code: Code
//    let region: Region
//}
//
//struct Code: Codable {
//    let id: String
//    let type: String
//    let mappingId: String
//}
//
//struct Region: Codable {
//    let area0: Area
//    let area1: Area
//    let area2: Area
//    let area3: Area
//    let area4: Area
//}
//
//struct Area: Codable {
//    let name: String
//    let coords: Coords
//}
//
//struct Coords: Codable {
//    let center: Center
//}
//
//struct Center: Codable {
//    let crs: String
//    let x: Double
//    let y: Double
//}
