//
//  StoreCollectionViewCell.swift
//  DayWeather
//
//  Created by Jack Lee on 2023/10/05.
//

import UIKit

final class StoreTableviewCell: UITableViewCell {
    static let identifier = "StoreTableviewCell"
    
    let storeLabel = makeLabel(withText: "매장 이름", size: 20)
    let descriptionLabel = makeLabel(withText: "매장 설명", size: 16)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .black
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        [storeLabel, descriptionLabel].forEach{ contentView.addSubview($0)}
        
        storeLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).offset(2)
            make.top.equalTo(contentView.snp.top).offset(2)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.bottom.equalTo(contentView.snp.bottom).offset(-2)
            make.trailing.equalTo(contentView.snp.trailing).offset(-2)
        }
    }
    
    func updateLabel(with data: String) {
        storeLabel.text = data
        descriptionLabel.text = data
    }
}
