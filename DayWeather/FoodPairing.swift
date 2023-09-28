//
//  FoodPairing.swift
//  DayWeather
//
//  Created by Jack Lee on 2023/09/25.
//

import UIKit
import SnapKit
import NMapsMap
// 현 위치를 가져오기 위한 모듈?
import CoreLocation

class FoodPairing: UIViewController {
    //MARK: - 전역 변수 선언
    let imageAsset: [String] = (1...5).map({"Food\($0)"})
    var locationManager = CLLocationManager()
    
    //MARK: - UIComponent 선언
    let backgroundImg           = addImage(withImage: "foodPairBG")
    let subDescriptionLabel     = makeLabel(withText: "이렇게", size: 12)
    let descriptionLabel        = makeLabel(withText: "비가 오는 날이면...", size: 26)
    let secondDescriptionLabel  = makeLabel(withText: "이 떠오르지 않나요?", size: 20)
    let nearbyInfoLabel         = makeLabel(withText: "테스트 라벨", size: 32)
    let nearbyInfoLabel2        = makeLabel(withText: "테스트 라벨22", size: 80)
    let exitButton              = makeButton(withImage: "x.circle.fill", action: #selector(exitButtonTapped), target: self)
    lazy var naverMapView       = NMFNaverMapView(frame: view.frame)
    
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
        let layout              = UICollectionViewFlowLayout()
        layout.scrollDirection  = .horizontal
        layout.minimumInteritemSpacing = 8
        layout.itemSize         = CGSize(width: 60, height: 60)
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: self.flowLayout)
        collection.dataSource       = self
        collection.delegate         = self
        collection.isScrollEnabled  = true
        collection.showsHorizontalScrollIndicator = true
        collection.backgroundColor  = .clear
        collection.alpha            = 1
        collection.register(FoodCollectionViewCell.self, forCellWithReuseIdentifier: FoodCollectionViewCell.identifier)
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        [scrollView, backgroundImg, exitButton].forEach{ view.addSubview($0) }
        [subDescriptionLabel, descriptionLabel, collectionView,
         secondDescriptionLabel, naverMapView, nearbyInfoLabel].forEach{ contentView.addSubview($0) }
        enableScroll()
        setBackground()
        setUIComponents()
        setCollectionView()
//        setLocationManager()
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
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func setUIComponents() {
        exitButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
        }
        
        subDescriptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).offset(26)
            make.top.equalTo(contentView.snp.top).offset(126)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(subDescriptionLabel.snp.bottom).offset(10)
            make.leading.equalTo(contentView.snp.leading).offset(26)
        }
        
        secondDescriptionLabel.snp.makeConstraints { make in
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
        naverMapView.showLocationButton = true
        
        naverMapView.snp.makeConstraints { make in
            make.top.equalTo(secondDescriptionLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.width.height.equalTo(353)
        }
        setLocationData()
    }
    
    func setNearbyInfo() {
        nearbyInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(naverMapView.snp.bottom).offset(20)
            make.centerX.equalTo(contentView.snp.centerX)
            make.bottom.equalToSuperview().inset(100)
        }
    }
    
    func setLocationData() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let latitude = locationManager.location?.coordinate.latitude ?? 0
        let longitude = locationManager.location?.coordinate.longitude ?? 0
        
        let camerUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: latitude, lng: longitude))
        naverMapView.mapView.moveCamera(camerUpdate)
        camerUpdate.animation = .easeIn
        
//        let coord = NMGLatLng(lat: 37.5670135, lng: 126.9783740)
        //        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: 37.5666102, lng: 126.9783881))
        //        naverMapView.mapView.moveCamera(cameraUpdate)
//        print("위도 \(coord.lat), 경도: \(coord.lng)")
        //        print("현재 위치는 \(cameraUpdate)")
    }
    
//    func setLocationManager() {
//        locationManager.delegate = self
//        locationManager = CLLocationManager()
//        // 거리 정확도
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//
//        // 위치 사용 허용 알림
//        locationManager.requestWhenInUseAuthorization()
//
//        if CLLocationManager.locationServicesEnabled() {
//            print("위치 서비스 허용 ON!")
//            locationManager.startUpdatingLocation()
//        } else {
//            print("위치 서비스 허용 OFF!")
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.first {
//            print("위치 업데이트")
//            print("위도: \(location.coordinate.latitude)")
//            print("경도: \(location.coordinate.longitude)")
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("에러 - \(error)")
//    }
//
    @objc func exitButtonTapped() {
        print("닫기 버튼이 눌렸습니다.")
        dismiss(animated: true)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("음식 \(indexPath.item + 1)번이 눌렸습니다.")
    }
}

extension FoodPairing: CLLocationManagerDelegate {
    
}

extension FoodPairing: NMFMapViewCameraDelegate {
    func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
        let latitude = mapView.cameraPosition.target.lat
        let longitude = mapView.cameraPosition.target.lng
        
        print(latitude)
    }
}
