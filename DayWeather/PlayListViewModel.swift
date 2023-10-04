//
//  PlayListViewModel.swift
//  DayWeather
//
//  Created by 랑 on 2023/10/04.
//

import Foundation

enum Status {
    case sunny
    case rainy
    //case snowy
    case windy
    case sunrise
    case sunset
    
    func changeStatus() {
        switch self {
        case .sunny:
            break
        case .rainy:
            break
//        case .snowy:
//            break
        case .windy:
            break
        case .sunrise:
            break
        case .sunset:
            break
        }
    }
    
    //각 case마다 backgroundImageView.image, titleLabel.text, iconImageView.image, 플레이리스트 배열 변경하는 함수 부르기
}
