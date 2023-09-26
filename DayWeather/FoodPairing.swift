//
//  FoodPairing.swift
//  DayWeather
//
//  Created by Jack Lee on 2023/09/25.
//

import UIKit
import SnapKit
import NMapsMap

class FoodPairing: UIViewController {
    //MARK: - 전역 변수 선언
    let imageAsset: [String] = (1...5).map({"Food\($0)"})
    
    //MARK: - UIComponent 선언
    let backgroundImg = addImage(withImage: "foodPairBG")
    let subDescriptionLabel = makeLabel(withText: "이렇게", size: 12)
    let descriptionLabel = makeLabel(withText: "비가 오는 날이면...", size: 26)
    let secondaryDescriptionLabel = makeLabel(withText: "이 떠오르지 않나요?", size: 20)
    let naverMapView = NMFNaverMapView()
    
    private let flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        layout.itemSize = CGSize(width: 60, height: 60)
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: self.flowLayout)
        collection.dataSource = self
        collection.delegate = self
        collection.isScrollEnabled = true
        collection.showsHorizontalScrollIndicator = true
        collection.backgroundColor = .white
        collection.register(FoodCollectionViewCell.self, forCellWithReuseIdentifier: FoodCollectionViewCell.identifier)
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        [backgroundImg, subDescriptionLabel, descriptionLabel, collectionView, secondaryDescriptionLabel, naverMapView].forEach{ view.addSubview($0) }
        setBackground()
        setUIComponents()
        setCollectionView()
        setNaverMap()
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
        
        secondaryDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(9)
            make.leading.equalToSuperview().offset(26)
        }
    }
    
    func setCollectionView() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(19)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(60)
        }
    }
    
    func setNaverMap() {
        giveShadowAndRoundedCorners(to: naverMapView)

        naverMapView.snp.makeConstraints { make in
            make.top.equalTo(secondaryDescriptionLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.width.equalTo(353)
            make.height.equalTo(353)
        }
    }
}

    //MARK: - Extension
extension FoodPairing: UICollectionViewDelegateFlowLayout {
    
}

extension FoodPairing: UICollectionViewDelegate {
    
}

extension FoodPairing: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageAsset.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FoodCollectionViewCell.identifier, for: indexPath) as! FoodCollectionViewCell
        let imageName = imageAsset[indexPath.item]
        cell.setImage(with: imageName)
        return cell
    }
}
