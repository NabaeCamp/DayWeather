//
//  FoodModel.swift
//  DayWeather
//
//  Created by Jack Lee on 2023/10/04.
//

import Foundation

struct FoodModel: Codable {
    let lastBuildDate: String
    let total: Int
    let start: Int
    let display: Int
    let items: [Item]
}

struct Item: Codable {
    let title: String
    let link: String
    let category: String
    let address: String
    let mapx: String
    let mapy: String
}
