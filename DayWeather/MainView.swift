//
//  ViewController.swift
//  DayWeather
//
//  Created by Jack Lee on 2023/09/25.
//

import UIKit
import NMapsMap
import SnapKit
import CoreLocation

class MainView: UIViewController {

    private let viewModel = WeatherViewModel()
    private var temperatureLabel: UILabel!
    private var cityLabel: UILabel!
    private var naverMapView: NMFNaverMapView!
    private var locationManager: CLLocationManager!
    private var marker: NMFMarker?




    override func viewDidLoad() {
        super.viewDidLoad()

        setupBackgroundImage()
        setupBackgroundImage()
        setupNaverMapView()

        // CLLocationManager를 설정하고 시작합니다.
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()



        setupLocationLabel()
        setupCityLabel()
        setupTemperatureLabel()
        setupCustomButton()
        setupSecondCustomButton()
        setupThirdCustomButton()


        fetchWeatherData(at: 37.5665, lon: 126.9780)

        setupRefreshButton()


    }

    private func setupBackgroundImage() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "MainImage")
        backgroundImage.contentMode = .scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)

        backgroundImage.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    private func setupNaverMapView() {
        let mapViewContainer = UIView()
        view.addSubview(mapViewContainer)

        mapViewContainer.snp.makeConstraints { make in
            make.width.equalTo(353)
            make.height.equalTo(351)
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(305)
        }

        addShadowAndRoundedCorners(to: mapViewContainer)

        naverMapView = NMFNaverMapView(frame: mapViewContainer.bounds) // 여기서 naverMapView를 초기화합니다.
        mapViewContainer.addSubview(naverMapView)
        naverMapView.showCompass = true
        naverMapView.showScaleBar = true
        naverMapView.showZoomControls = true
        naverMapView.showLocationButton = true

        naverMapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        // 탭 제스처 인식기 설정
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleMapTap(_:)))
        naverMapView.mapView.addGestureRecognizer(tapRecognizer)
    }

    @objc private func handleMapTap(_ recognizer: UITapGestureRecognizer) {
        let location = recognizer.location(in: naverMapView.mapView)
        let coordinate = naverMapView.mapView.projection.latlng(from: location)

        // 기존 마커를 제거
        marker?.mapView = nil

        // 새로운 마커를 추가
        marker = NMFMarker()
        marker?.position = coordinate
        marker?.mapView = naverMapView.mapView

        // 날씨 데이터 조회
        fetchWeatherData(at: coordinate.lat, lon: coordinate.lng)
    }


    private func addShadowAndRoundedCorners(to view: UIView) {
        view.layer.cornerRadius = 10  // 이 값을 조절하여 모서리 반올림 크기를 변경
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 4
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.clipsToBounds = true  // 이 부분은 모서리 반올림 부분을 잘라내기 위해 추가
    }




    private func setupLocationLabel()  {
        let label = UILabel()
        view.addSubview(label)

        label.text = "나의 위치"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 32)
        label.attributedText = NSMutableAttributedString(string: "나의 위치", attributes: [NSAttributedString.Key.kern: -1.44])

        // 그림자 효과
        label.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        label.layer.shadowOpacity = 1
        label.layer.shadowRadius = 4
        label.layer.shadowOffset = CGSize(width: 0, height: 4)

        // Auto layout 설정
        label.numberOfLines = 1
        label.snp.makeConstraints { make in
            // make.width.equalTo(120)  // 이 줄을 제거
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(100)
        }




    }

    private func setupCityLabel() {
        cityLabel = UILabel()
        view.addSubview(cityLabel)

        cityLabel.text = "서울특별시"
        cityLabel.textColor = .white
        cityLabel.font = UIFont.systemFont(ofSize: 32)
        cityLabel.attributedText = NSMutableAttributedString(string: "서울특별시", attributes: [NSAttributedString.Key.kern: -0.54])

        // 그림자 효과
        cityLabel.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        cityLabel.layer.shadowOpacity = 1
        cityLabel.layer.shadowRadius = 2
        cityLabel.layer.shadowOffset = CGSize(width: 0, height: 2)

        // Auto layout 설정
        cityLabel.numberOfLines = 1
        cityLabel.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(160)
        }
    }


    private func setupTemperatureLabel() {
        temperatureLabel = UILabel()
        view.addSubview(temperatureLabel)

        temperatureLabel.text = "2º"
        temperatureLabel.textColor = .white
        temperatureLabel.font = UIFont.systemFont(ofSize: 32)
        temperatureLabel.attributedText = NSMutableAttributedString(string: "2º", attributes: [NSAttributedString.Key.kern: -1.53])

        // 그림자 효과
        temperatureLabel.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        temperatureLabel.layer.shadowOpacity = 1
        temperatureLabel.layer.shadowRadius = 4
        temperatureLabel.layer.shadowOffset = CGSize(width: 0, height: 4)

        // Auto layout 설정
        temperatureLabel.numberOfLines = 1
        temperatureLabel.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(220)
        }
    }

    private func setupRefreshButton() {
        let refreshButton = UIButton()
        view.addSubview(refreshButton)

        // 이미지로 버튼 설정
        refreshButton.setImage(UIImage(named: "Refresh"), for: .normal)  // "refreshIcon"은 Assets에 추가한 이미지 이름입니다.

        refreshButton.backgroundColor = UIColor(red: 0.525, green: 0.525, blue: 0.525, alpha: 0.7)
        refreshButton.layer.cornerRadius = 10

        // Auto layout 설정
        refreshButton.snp.makeConstraints { make in
            make.width.equalTo(40)  // 이미지의 크기에 따라 조정
            make.height.equalTo(40)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(60)
        }

        // 버튼 액션 추가
        refreshButton.addTarget(self, action: #selector(refreshButtonTapped), for: .touchUpInside)
    }


    @objc private func refreshButtonTapped() {
        let center = naverMapView.mapView.cameraPosition.target
        fetchWeatherData(at: center.lat, lon: center.lng)
    }




    private func setupCustomButton() {
        let button = UIButton()
        view.addSubview(button)

        button.backgroundColor = UIColor(red: 0.525, green: 0.525, blue: 0.525, alpha: 0.2)
        button.layer.cornerRadius = 20

        // Auto layout 설정
        button.snp.makeConstraints { make in
            make.width.equalTo(111)
            make.height.equalTo(110)
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(679)
        }

        // 버튼 액션 추가 (필요한 경우)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }



    @objc private func buttonTapped() {
        // WearingViewController의 인스턴스를 생성합니다.
        let wearingVC = WearingViewController()

        // 모달로 표시합니다.
        self.present(wearingVC, animated: true, completion: nil)
    }


    private func setupSecondCustomButton() {
        let button = UIButton()
        view.addSubview(button)

        button.backgroundColor = UIColor(red: 0.525, green: 0.525, blue: 0.525, alpha: 0.2)
        button.layer.cornerRadius = 20

        // Auto layout 설정
        button.snp.makeConstraints { make in
            make.width.equalTo(111)
            make.height.equalTo(110)
            make.leading.equalToSuperview().offset(141)
            make.top.equalToSuperview().offset(679)
        }

        // 버튼 액션 추가 (필요한 경우)
        button.addTarget(self, action: #selector(secondButtonTapped), for: .touchUpInside)
    }

    @objc private func secondButtonTapped() {
        // WearingViewController의 인스턴스를 생성합니다.
        let wearingVC = PlayListView()

        // 모달로 표시합니다.
        self.present(wearingVC, animated: true, completion: nil)
    }


    private func setupThirdCustomButton() {
        let button = UIButton()
        view.addSubview(button)

        button.backgroundColor = UIColor(red: 0.525, green: 0.525, blue: 0.525, alpha: 0.2)
        button.layer.cornerRadius = 20

        // Auto layout 설정
        button.snp.makeConstraints { make in
            make.width.equalTo(111)
            make.height.equalTo(110)
            make.leading.equalToSuperview().offset(262)
            make.top.equalToSuperview().offset(679)
        }

        // 버튼 액션 추가 (필요한 경우)
        button.addTarget(self, action: #selector(thirdButtonTapped), for: .touchUpInside)
    }

    @objc private func thirdButtonTapped() {
        // 버튼이 클릭될 때 수행할 동작
        print("Third button was tapped!")
    }


    // 날씨 데이터를 가져오는 메서드
    func fetchWeatherData(at lat: Double, lon: Double) {
        viewModel.fetchWeatherData(lat: lat, lon: lon) { [weak self] in
            DispatchQueue.main.async {
                self?.temperatureLabel.text = self?.viewModel.temperature
                self?.cityLabel.text = self?.viewModel.cityName
                self?.view.setNeedsDisplay()
            }
        }
    }



}

// MARK: - CLLocationManagerDelegate Extension
extension MainView: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last, let mapView = naverMapView {
            let coordinate = location.coordinate

            // 기존 마커를 제거
            marker?.mapView = nil

            // 새로운 마커를 추가
            marker = NMFMarker()
            marker?.position = NMGLatLng(lat: coordinate.latitude, lng: coordinate.longitude)
            marker?.mapView = mapView.mapView

            // 지도의 중심을 현재 위치로 이동합니다.
            mapView.mapView.moveCamera(NMFCameraUpdate(scrollTo: NMGLatLng(lat: coordinate.latitude, lng: coordinate.longitude)))
        }
    }
}




// MARK: - NMFMapViewCameraDelegate Extension
extension MainView: NMFMapViewCameraDelegate {
    func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
        let center = mapView.cameraPosition.target
        fetchWeatherData(at: center.lat, lon: center.lng)
    }
}
