//
//  Factory.swift
//  DayWeather
//
//  Created by Jack Lee on 2023/09/25.
//

import UIKit

func addImage(withImage image: String) -> UIImageView {
    let iv = UIImageView()
    let image = UIImage(named: image)
    iv.image = image
    iv.translatesAutoresizingMaskIntoConstraints = false
    return iv
}

func makeLabel(withText text: String, size: CGFloat) -> UILabel {
    let label = UILabel()
    label.text = text
    label.font = UIFont.systemFont(ofSize: size)
    label.shadowColor = .black
    label.shadowOffset = CGSize(width: 0, height: -1)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
}

func makeButton(withText text: String) -> UIButton {
    let button = UIButton()
    button.setTitle(text, for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
}
