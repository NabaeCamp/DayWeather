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
    
    private let viewModel = FoodViewModel()
    private let imageAsset: [(image: String, food: String)] = [
        ("Food1", "순대국"),
        ("Food2", "피자"),
        ("Food3", "치킨"),
        ("Food4", "아이스크림"),
        ("Food5", "샐러드"),
    ]
    var infoWindow = NMFInfoWindow()
    var defaultInfoWindoImage = NMFInfoWindowDefaultTextSource.data()
    var locationManager = LocationManager()
    var location: CLLocationCoordinate2D?
    private var circleView: UIView!
    private var tableviewDataSource: [String] = []
//    private var marker: NMFMarker?
    
    //MARK: - UIComponent 선언
    let backgroundImg           = addImage(withImage: "foodPairBG")
    let topDescriptionLabel     = makeThickLabel(withText: "비가 오는 날,", size: 30)
    let descriptionLabel        = makeLabel(withText: "이 떠오르지 않나요?", size: 12)
//    let secondDescriptionLabel  = makeLabel(withText: "이 떠오르지 않나요?", size: 12)
    let exitButton              = makeButton(withImage: "xmark", action: #selector(exitButtonTapped), target: self)
    
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
    
    lazy var foodCollectionView: UICollectionView = {
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
        tableView.dataSource        = self
        tableView.delegate          = self
        tableView.register(StoreTableviewCell.self, forCellReuseIdentifier: StoreTableviewCell.identifier)
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    var mapView: NMFMapView {
        return naverMapView.mapView
    }
    
    //MARK: - UI Setup
    func setupUI() {
        [scrollView, backgroundImg, exitButton].forEach{ view.addSubview($0) }
        [topDescriptionLabel, descriptionLabel, foodCollectionView,
         naverMapView, nearbyTableView].forEach{ contentView.addSubview($0) }
        setBackground()
        enableScroll()
        setUIComponents()
        setCollectionView()
        setNaverMap()
        setNearbyTableView()
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
        
        topDescriptionLabel.snp.makeConstraints { make in
            make.centerX.equalTo(contentView.snp.centerX)
            make.top.equalTo(contentView.snp.top).offset(85)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(topDescriptionLabel.snp.bottom).offset(10)
            make.centerX.equalTo(contentView.snp.centerX)
        }
        
//        secondDescriptionLabel.snp.makeConstraints { make in
//            make.top.equalTo(foodCollectionView.snp.bottom).offset(9)
//            make.leading.equalTo(contentView.snp.leading).offset(26)
//        }
    }
    
    func setCollectionView() {
        foodCollectionView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(19)
            make.leading.equalTo(contentView.snp.leading).offset(10)
            make.trailing.equalTo(contentView.snp.trailing).inset(10)
            make.height.equalTo(60)
        }
    }
    
    func setNaverMap() {
        giveShadowAndRoundedCorners(to: naverMapView)
        
        naverMapView.snp.makeConstraints { make in
            make.top.equalTo(foodCollectionView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(353)
        }
    }
    
    func setNearbyTableView() {
        giveShadowAndRoundedCorners(to: nearbyTableView)
        
        nearbyTableView.snp.makeConstraints { make in
            make.top.equalTo(naverMapView.snp.bottom).offset(20)
            make.leading.equalTo(contentView.snp.leading).offset(10)
            make.trailing.equalTo(contentView.snp.trailing).inset(10)
            make.height.equalTo(250)
            make.bottom.equalTo(contentView.snp.bottom).offset(10)
        }
    }
    
    func updateTableviewWithPickableListStre(pickableStr: String) {
        tableviewDataSource.append(pickableStr)
        nearbyTableView.reloadData()
    }
    
    func drawCircle(_ point: CGPoint) {
        if circleView == nil {
            circleView = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
            circleView.layer.cornerRadius = circleView.frame.width/2
            circleView.backgroundColor = .green
            circleView.alpha = 0.3
            circleView.isUserInteractionEnabled = false
            naverMapView.addSubview(circleView)
        }
        circleView.center = point
    }
    
    func setupLocation() {
        self.locationManager.fetchLocation { [weak self] (location, error) in
            self?.location = location
        }
        locationManager.stopUpdatingLocation()
    }
    
    // MARK: - 날씨 데이터
    // 날씨 데이터를 가져오는 메서드
    func fetchWeatherData(lon: Double, lat: Double) {
        viewModel.fetchWeatherData(lon: lon, lat: lat) { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else { return }
                guard let temperature = self.viewModel.temperature,
                      let tempValue = Double(temperature.replacingOccurrences(of: "º", with: "")) else {
                    self.descriptionLabel.text = "온도를 모르겠습니다."
                    return
                }
                let newText = self.getWeatherDescription(forTemperature: tempValue)
                self.descriptionLabel.text = newText
            }
        }
    }
    
    // 날씨 데이터를 활용해서 String 변환
    func getWeatherDescription(forTemperature temperature: Double) -> String {
        switch temperature {
        case ..<5: return "오늘 날씨가 춥네요!"
        case 5..<15: return "오늘 날씨는 괜찮아 보이네요!"
        case 15..<30: return "오늘 날씨가 덥네요!"
        default: return "온도를 호출하는데 오류가 있어요 😢"
        }
    }
    
    // MARK: - 검색 데이터(음식)
    func getFoodLocation(location: GeoLocationModel, food: String? = nil, completion: @escaping () -> Void) {
        viewModel.requestFoodAPI(location: location, food: food) {
            completion()
            print("값이 던져지고")
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

//MARK: - LifeCycle
extension FoodPairing {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        infoWindow.dataSource = defaultInfoWindoImage
        infoWindow.touchHandler = { [weak self] (overlay: NMFOverlay) -> Bool in
            self?.infoWindow.close()
            return true
        }
        infoWindow.mapView = mapView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupLocation() // 일회성 현재 위치 확인
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let unwrappedLocation = location {
            let latitude = unwrappedLocation.latitude
            let longitude = unwrappedLocation.longitude
            fetchWeatherData(lon: longitude, lat: latitude) // 날씨 상황 업데이트 -> 화면 표시
        }
    }
}

//MARK: - UICollectionView
extension FoodPairing: UICollectionViewDelegate {
    
}

extension FoodPairing: UICollectionViewDelegateFlowLayout {
    
}

extension FoodPairing: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageAsset.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FoodCollectionViewCell.identifier, for: indexPath) as! FoodCollectionViewCell
        let imageName = imageAsset[indexPath.row].image
        cell.setImage(with: imageName)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("음식 \(indexPath.item + 1)번이 눌렸습니다.")
        let foodName = imageAsset[indexPath.row].food
        print(foodName)
        
        if let unwrappedLocation = location {
            let latitude = unwrappedLocation.latitude
            let longitude = unwrappedLocation.longitude
            
            self.viewModel.getLocation(locationX: longitude, locationY: latitude) { geoLocationModel in
                if let geoLocationModel = geoLocationModel {
                    self.getFoodLocation(location: geoLocationModel, food: foodName) {
                        DispatchQueue.main.async {
                            self.nearbyTableView.reloadData()
                        }
                    }
                }
            }
        } else {
            print("에러가 발생했습니다.")
        }
    }
}

//MARK: - UITableView
extension FoodPairing: UITableViewDelegate {
    
}

extension FoodPairing: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let itemCount = viewModel.queryData?.items.count {
            return itemCount
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StoreTableviewCell.identifier, for: indexPath) as!  StoreTableviewCell
        if let item = viewModel.queryData?.items[indexPath.row] {
            cell.storeLabel.text = item.title
            cell.descriptionLabel.text = item.address
        }
        return cell
    }
}
