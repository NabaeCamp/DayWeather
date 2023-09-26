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
    let nearbyInfoLabel = makeLabel(withText: "테스트 라벨", size: 32)
    let nearbyInfoLabel2 = makeLabel(withText: "테스트 라벨22", size: 80)
    let naverMapView = NMFNaverMapView()
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
        setupUI()
    }
    
    func setupUI() {
        [scrollView, backgroundImg].forEach{ view.addSubview($0) }
        [subDescriptionLabel, descriptionLabel, collectionView, secondaryDescriptionLabel, naverMapView, nearbyInfoLabel, nearbyInfoLabel2 ].forEach{ contentView.addSubview($0) }
        enableScroll()
        setBackground()
        setUIComponents()
        setCollectionView()
        setNaverMap()
        setNearbyInfo()
    }
    
    func enableScroll() {
        scrollView.snp.makeConstraints { make in
            make.leading.top.trailing.bottom.equalToSuperview()
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
    }
    
    func setBackground() {
        view.sendSubviewToBack(backgroundImg)
        backgroundImg.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func setUIComponents() {
        subDescriptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).offset(26)
            make.top.equalTo(contentView.snp.top).offset(126)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(subDescriptionLabel.snp.bottom).offset(10)
            make.leading.equalTo(contentView.snp.leading).offset(26)
        }
        
        secondaryDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(9)
            make.leading.equalTo(contentView.snp.leading).offset(26)
        }
    }
    
    func setCollectionView() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(19)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
            make.height.equalTo(60)
        }
    }
    
    func setNaverMap() {
        giveShadowAndRoundedCorners(to: naverMapView)

        naverMapView.snp.makeConstraints { make in
            make.top.equalTo(secondaryDescriptionLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
//            make.leading.equalTo(contentView.snp.leading).offset(20)
//            make.trailing.equalTo(contentView.snp.trailing).offset(-20)
            make.width.equalTo(353)
            make.height.equalTo(353)
        }
    }
    
    func setNearbyInfo() {
        nearbyInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(naverMapView.snp.bottom).offset(20)
            make.centerX.equalTo(contentView.snp.centerX)
        }
        
        nearbyInfoLabel2.snp.makeConstraints { make in
            make.top.equalTo(nearbyInfoLabel.snp.bottom).offset(40)
            make.centerX.equalTo(contentView.snp.centerX)
            make.bottom.equalToSuperview().inset(100)
        }
    }
}

    //MARK: - Extension
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
