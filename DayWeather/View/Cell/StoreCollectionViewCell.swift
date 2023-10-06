//
//  StoreCollectionViewCell.swift
//  DayWeather
//
//  Created by Jack Lee on 2023/10/05.
//

import UIKit

final class StoreTableviewCell: UITableViewCell {
    static let identifier   = "StoreTableviewCell"
    
    let storeLabel = makeLabel(withText: "매장 이름", size: 14)
    let descriptionLabel    = makeLabel(withText: "매장 설명", size: 10)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor     = UIColor(red: 0.254, green: 0.254, blue: 0.254, alpha: 0.4)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        [storeLabel, descriptionLabel].forEach{ contentView.addSubview($0)}
        
        storeLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).offset(5)
            make.centerY.equalTo(contentView.snp.centerY)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.trailing.equalTo(contentView.snp.trailing).inset(5)
        }
    }
    
    func updateTitle(with data: String) {
        storeLabel.text = data
    }
    
    func updateDescription(with data: String) {
        descriptionLabel.text = data
    }
}
