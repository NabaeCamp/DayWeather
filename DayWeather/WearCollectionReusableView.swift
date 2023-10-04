//
//  WearCollectionReusableView.swift
//  DayWeather
//
//  Created by t2023-m0088 on 2023/09/27.
//

import UIKit

class WearCollectionReusableView: UICollectionReusableView {
    static let identifier = "WearCollectionReusableView"

    let titleLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont.boldSystemFont(ofSize: 14)
            label.textColor = UIColor.white
            label.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25)
            label.layer.shadowOpacity = 0.4
            label.layer.shadowRadius = 4
            label.layer.shadowOffset = CGSize(width: 0, height: 2)
            return label
        }()
        override init(frame: CGRect) {
            super.init(frame: frame)
            // Add the title label to the header view
            addSubview(titleLabel)
            // Set constraints for the title label
            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
                titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
                titleLabel.topAnchor.constraint(equalTo: topAnchor),
                titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
            ])
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
        
}
