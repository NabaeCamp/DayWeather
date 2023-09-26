//
//  FoodPairing.swift
//  DayWeather
//
//  Created by Jack Lee on 2023/09/25.
//

import UIKit
import SnapKit

class FoodPairing: UIViewController {
    
    //MARK: - UIComponent 선언
    let backgroundImg = addImage(withImage: "foodPairBG")
    let subDescriptionLabel = makeLabel(withText: "이렇게", size: 12)
    let descriptionLabel = makeLabel(withText: "비가 오는 날이면...", size: 26)
    
    private let flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        return layout
    }()
    
//    lazy var collectionView: UICollectionView = {
//        let collection = UICollectionView(frame: .zero, collectionViewLayout: self.flowLayout)
//        collection.dataSource = self
//        collection.delegate = self
//        return collection
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        [backgroundImg, subDescriptionLabel, descriptionLabel].forEach{ view.addSubview($0) }
        setBackground()
        setUIComponents()
    }
    
    func setBackground() {
        backgroundImg.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func setUIComponents() {
        subDescriptionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(26)
            make.top.equalToSuperview().offset(126)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(subDescriptionLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(26)
        }
    }
}

    //MARK: - Extension
extension FoodPairing: UICollectionViewDelegateFlowLayout {
    
}

//extension FoodPairing: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        <#code#>
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        <#code#>
//    }
//}
