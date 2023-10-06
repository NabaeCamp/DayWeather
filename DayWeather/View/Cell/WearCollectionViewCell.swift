//
//  wearCollectionViewCell.swift
//  DayWeather
//
//  Created by t2023-m0088 on 2023/09/26.
//

import UIKit

class WearCollectionViewCell: UICollectionViewCell {
    static let identifier = "wearCollectionViewCell"
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        return view
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(imageView)
        contentView.layer.cornerRadius = 20
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        contentView.backgroundColor = UIColor.clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//        let label = UILabel()
//        private let stackView = UIStackView()
//
//        override init(frame: CGRect) {
//            super.init(frame: frame)
//            label.text = "쌀쌀해진 날씨에 필요한 자켓"
//            addSubview(stackView)
//            stackView.addArrangedSubview(label)
//            let button = UIButton(type: .system)
//            button.setTitle("More", for: .normal)
//            button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
//            stackView.addArrangedSubview(button)
//        }
//        override func layoutSubviews() {
//            super.layoutSubviews()
//            stackView.frame = bounds
//        }
//
//
//        required init?(coder: NSCoder) {
//            fatalError("init(coder:) has not been implemented")
//        }
    
    
    }


