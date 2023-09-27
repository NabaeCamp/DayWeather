//
//  FoodPairing.swift
//  DayWeather
//
//  Created by Jack Lee on 2023/09/25.
//

import UIKit
import SnapKit
import NMapsMap
import CoreLocation

class FoodPairing: UIViewController {
    //MARK: - 전역 변수 선언
    let imageAsset: [String] = (1...5).map({"Food\($0)"})
    var locationManger = CLLocationManager()
    
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
        naverMapView.showLocationButton = true
        naverMapView.showZoomControls = true
        locationManger.delegate = self
                
        giveShadowAndRoundedCorners(to: naverMapView)
//        giveMapLocationAction(to: naverMapView)
        naverMapView.snp.makeConstraints { make in
            make.top.equalTo(secondDescriptionLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.width.equalTo(353)
            make.height.equalTo(353)
        }
    }
    
    func giveMapLocationAction(to view: UIView) {
        locationManger.delegate = self
        locationManger.desiredAccuracy = kCLLocationAccuracyBest
        locationManger.requestWhenInUseAuthorization()
        
//        if CLLocationManager.locationServicesEnabled() {
//            print("위치 서비스 ON")
//            locationManger.startUpdatingLocation()
//            print("지금 위치는 여기입니다. \(locationManger.location?.coordinate)")
//
//            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: locationManger.location?.coordinate.latitude ?? 0,
//                                                                   lng: locationManger.location?.coordinate.longitude ?? 0))
//            cameraUpdate.animation = .easeIn
//            naverMapView.mapView.moveCamera(cameraUpdate)
//
//
//        } else {
//            print("위치 서비스 OFF")
//        }
    }
    
    // 현 위치 관련해서 허가
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager, didChangeAuthoration status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManger.startUpdatingLocation()
        } else {
            print("Location이 서비스 되지 않았습니다.")
        }
    }
    
    // 현 위치를 전달 받기
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            print("새로운 위치는 \(location.coordinate) 입니다.")
            
            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: location.coordinate.latitude,
                                                                   lng: location.coordinate.longitude))
            cameraUpdate.animation = .easeIn
            naverMapView.mapView.moveCamera(cameraUpdate)
            
            let marker = NMFMarker()
            marker.position = NMGLatLng(lat: locationManger.location?.coordinate.latitude ?? 0,
                                        lng: locationManger.location?.coordinate.longitude ?? 0)
            marker.mapView = naverMapView.mapView
        }
    }
    
    func setNearbyInfo() {
        nearbyInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(naverMapView.snp.bottom).offset(20)
            make.centerX.equalTo(contentView.snp.centerX)
            make.bottom.equalToSuperview().inset(100)
        }
    }
    
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
