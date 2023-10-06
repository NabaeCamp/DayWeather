//
//  QueryModel.swift
//  DayWeather
//
//  Created by Jack Lee on 2023/10/05.
//

import Foundation

struct QueryModel: Codable {
    let lastBuildDate: String
    let total, start, display: Int
    let items: [Item]
}

// MARK: - Item
struct Item: Codable {
    let title: String
    let link: String
    let category, description, telephone, address: String
    let roadAddress, mapx, mapy: String
}
