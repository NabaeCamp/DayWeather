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
    private let viewModel = FoodViewModel()
    let imageAsset: [String] = (1...5).map({"Food\($0)"})
    var infoWindow = NMFInfoWindow()
    var defaultInfoWindoImage = NMFInfoWindowDefaultTextSource.data()
    var locationManager = LocationManager()
    var location: CLLocationCoordinate2D?
    var locationData: GeoLocationModel?
    var storeData: QueryModel?
    
    //MARK: - UIComponent 선언
    let backgroundImg           = addImage(withImage: "foodPairBG")
    let subDescriptionLabel     = makeLabel(withText: "이렇게", size: 12)
    let descriptionLabel        = makeLabel(withText: "비가 오는 날이면...", size: 26)
    let secondDescriptionLabel  = makeLabel(withText: "이 떠오르지 않나요?", size: 20)
    let nearbyInfoLabel         = makeLabel(withText: "테스트 라벨", size: 15)
    let nearbyInfoLabel2        = makeLabel(withText: "테스트 라벨22", size: 15)
    let tempLabel               = makeLabel(withText: "온도는 몇도입니다.", size: 15)
    
    let locationButton          = makeButton(withImage: "magnifyingglass", action: #selector(buttonHandler), target: self)
    let exitButton              = makeButton(withImage: "x.circle.fill", action: #selector(exitButtonTapped), target: self)
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator               = false
        view.translatesAutoresizingMaskIntoConstraints  = false
        return view
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints  = false
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
    
    private lazy var naverMapView: NMFNaverMapView = {
        let map = NMFNaverMapView()
        map.showCompass             = true
        map.showLocationButton      = true
        map.showZoomControls        = true
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    lazy var nearbyTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(StoreTableviewCell.self, forCellReuseIdentifier: StoreTableviewCell.identifier)
        return tableView
    }()
    
    var mapView: NMFMapView {
        return naverMapView.mapView
    }
    
    //MARK: - UI Setup
    func setupUI() {
        [scrollView, backgroundImg, exitButton].forEach{ view.addSubview($0) }
        [locationButton, subDescriptionLabel, descriptionLabel, collectionView,
         secondDescriptionLabel, naverMapView, nearbyTableView, nearbyInfoLabel, nearbyInfoLabel2, tempLabel].forEach{ contentView.addSubview($0) }
        setBackground()
        enableScroll()
        setUIComponents()
        setCollectionView()
        setNaverMap()
        setNearbyTableView()
        setNearbyInfo()
        setupLocation()
    }
    
    func setBackground() {
        view.sendSubviewToBack(backgroundImg)
        backgroundImg.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
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
    
    func setUIComponents() {
        exitButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
        }
        
        locationButton.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).offset(26)
            make.top.equalTo(contentView.snp.top).offset(50)
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
        
        naverMapView.snp.makeConstraints { make in
            make.top.equalTo(secondDescriptionLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.width.height.equalTo(353)
        }
    }
    
    func setNearbyTableView() {
        giveShadowAndRoundedCorners(to: nearbyTableView)
        
        nearbyTableView.snp.makeConstraints { make in
            make.top.equalTo(naverMapView.snp.bottom).offset(20)
            make.leading.equalTo(contentView.snp.leading).offset(10)
            make.trailing.equalTo(contentView.snp.trailing).inset(10)
            make.height.equalTo(300)
        }
    }
    
    func setNearbyInfo() {
        nearbyInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(nearbyTableView.snp.bottom).offset(20)
            make.centerX.equalTo(contentView.snp.centerX)
        }
        
        nearbyInfoLabel2.snp.makeConstraints { make in
            make.top.equalTo(nearbyInfoLabel.snp.bottom).offset(5)
            make.centerX.equalTo(contentView.snp.centerX)
        }
        
        tempLabel.snp.makeConstraints { make in
            make.top.equalTo(nearbyInfoLabel2.snp.bottom).offset(5)
            make.centerX.equalTo(contentView.snp.centerX)
            make.bottom.equalToSuperview().inset(100)
        }
    }
    
    func setupLocation() {
        locationManager.fetchLocation { [weak self] (location, error) in
            self?.location = location
        }
        locationManager.stopUpdatingLocation()
    }
    
    // MARK: - 변경 사항 - 날씨를 싱글톤으로 구현된 인스턴스에서 가져옵니다.
    // 날씨 데이터를 가져오는 메서드
    func fetchWeatherData(lat: Double, lon: Double) {
        viewModel.fetchWeatherData(lat: lat, lon: lon) { [weak self] in
            DispatchQueue.main.async {
                self?.tempLabel.text = self?.viewModel.temperature
                self?.view.setNeedsDisplay()
                
                if let temperature = self?.viewModel.temperature {
                    let temperatureValue = temperature.replacingOccurrences(of: "º", with: "")
                    let newText: String
                    
                    if let tempValue = Double(temperatureValue) {
                        switch tempValue {
                        case ..<5: newText = "오늘 날씨가 춥네요!"
                        case 5..<15: newText = "오늘 날씨는 괜찮아 보이네요!"
                        case 15..<30: newText = "오늘 날씨가 덥네요!"
                        default: newText = "온도를 호출하는데 오류가 있어요 😢"
                        }
                    } else {
                        newText = "온도를 모르겠습니다."
                        print(temperatureValue)
                    }
                    self?.secondDescriptionLabel.text = newText
                }
            }
        }
    }
    
    @objc func buttonHandler(_ sender: UIButton) {
        if let unwrappedLocation = location {
            let latitude = unwrappedLocation.latitude
            let longitude = unwrappedLocation.longitude
            
            DispatchQueue.main.async {
                self.nearbyInfoLabel.text = String("위도는 \(latitude)")
                self.nearbyInfoLabel2.text = String("경도는 \(longitude)")
                
                print("위도는 \(latitude)")
                print("경도는 \(longitude)")
            }
            
            DispatchQueue.main.async {
                self.fetchWeatherData(lat: latitude, lon: longitude)
                
                // 데이터를 받고 있었지만, 모델을 데이터로 활용하고 있었던 점 + Model의 구조가 달랐기 때문에 발생하던 문제점
                self.viewModel.getLocation(locationX: longitude, locationY: latitude) { geoLocationModel in
                    if let geoLocationModel = geoLocationModel {
                        self.locationData = geoLocationModel
                    } else {
                        print("에러가 발생했습니다.")
                    }
                }
            }
            
            DispatchQueue.main.async {
                if let unwrappedData = self.locationData {
                    self.viewModel.requestAPI(location: unwrappedData)
                }
                
                self.viewModel.dataUpdated = { [weak self] in
                    self?.nearbyTableView.reloadData()
                }
            }
        } else {
            print("location is nil")
        }
    }
    
    @objc func exitButtonTapped() {
        print("닫기 버튼이 눌렸습니다.")
        dismiss(animated: true)
    }
    
    deinit {
        print("FoodPairing 화면이 내려갔습니다.")
    }
}

//MARK: - LifeCycle 정리
extension FoodPairing {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        //info 창 출력
        mapView.touchDelegate = self
        infoWindow.dataSource = defaultInfoWindoImage
        infoWindow.touchHandler = { [weak self] (overlay: NMFOverlay) -> Bool in
            self?.infoWindow.close()
            return true
        }
        infoWindow.mapView = mapView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("한번만 출력 가능한가요?")
        setupLocation()
    }
}

//MARK: - UICollectionView
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

//MARK: - UITableView
extension FoodPairing: UITableViewDelegate {
    
}

extension FoodPairing: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.storeData?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StoreTableviewCell.identifier, for: indexPath) as!  StoreTableviewCell
        if let titleResult = self.storeData?.items[indexPath.row].title {
            cell.updateTitle(with: titleResult)
            cell.descriptionLabel.text = self.storeData?.items[indexPath.row].address
        }
        return cell
    }
}

//MARK: - NMFMapViewTouchDelegate
extension FoodPairing: NMFMapViewTouchDelegate {
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        infoWindow.close()
        
        let latlngStr = String(format: "좌표:(%.5f, %.5f)", latlng.lat, latlng.lng)
        defaultInfoWindoImage.title = latlngStr
        infoWindow.position = latlng
        infoWindow.open(with: mapView)
    }
}

//MARK: - CLLocationManagerDelegate

extension FoodPairing: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("위치 업데이트")
            print("위도: \(location.coordinate.latitude)")
            print("경도: \(location.coordinate.longitude)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("에러가 발생했습니다: \(error.localizedDescription)")
    }
}
