//
//  QueryModel.swift
//  DayWeather
//
//  Created by Jack Lee on 2023/10/05.
//

import Foundation

struct QueryModel: Codable {
    let lastBuildDate: String
    var total:Int
    var start:Int
    var display:Int
    let items: [Item]
}

// MARK: - Item
struct Item: Codable {
    let title: String
    let address: String
}
