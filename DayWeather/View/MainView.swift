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
//    private var noticeV: UIView!
//    private var noticeLabel: UILabel!
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
        setupSunnyIcon()
        setupCustomButton()
        setupSecondCustomButton()
        setupThirdCustomButton()
        setupNoticeIcon()
        noticeView()
        noticeText()


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
        mapViewContainer.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        mapViewContainer.layer.shadowOpacity = 1
        mapViewContainer.layer.shadowRadius = 4
        mapViewContainer.layer.shadowOffset = CGSize(width: 0, height: 4)
        mapViewContainer.clipsToBounds = false  // 이 부분은 모서리 반올림 부분을 잘라내기 위해 추가

        mapViewContainer.snp.makeConstraints { make in
            make.height.equalTo(320)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20) // 화면 오른쪽 끝에서 20의 간격을 유지
            make.top.equalToSuperview().offset(340)
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
//        let location = recognizer.location(in: naverMapView.mapView)
//        let coordinate = naverMapView.mapView.projection.latlng(from: location)
//
//        // 기존 마커를 제거
//        marker?.mapView = nil
//
//        // 새로운 마커를 추가
//        marker = NMFMarker()
//        marker?.position = coordinate
//        marker?.mapView = naverMapView.mapView
//
//        // 날씨 데이터 조회
//        fetchWeatherData(at: coordinate.lat, lon: coordinate.lng)
//
//        // 위치 업데이트 중지
//        locationManager.stopUpdatingLocation()
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
        label.font = UIFont.systemFont(ofSize: 36)
        label.attributedText = NSMutableAttributedString(string: "나의 위치", attributes: [NSAttributedString.Key.kern: -0.04])

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
            make.top.equalToSuperview().offset(140)
        }




    }

    private func setupCityLabel() {
        cityLabel = UILabel()
        view.addSubview(cityLabel)

        cityLabel.text = "서울특별시"
        cityLabel.textColor = .white
        cityLabel.font = UIFont.systemFont(ofSize: 14)
        cityLabel.attributedText = NSMutableAttributedString(string: "서울특별시", attributes: [NSAttributedString.Key.kern: -0.04])

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
            make.top.equalToSuperview().offset(176)
        }
    }


    private func setupTemperatureLabel() {
        temperatureLabel = UILabel()
        view.addSubview(temperatureLabel)

        temperatureLabel.text = "2º"
        temperatureLabel.textColor = .white
        temperatureLabel.font = UIFont.systemFont(ofSize: 40)
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
            make.centerX.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(210)
        }
        
    }
    
    private func setupSunnyIcon() {
        let setupSunnyIcon = UIImageView()
        view.addSubview(setupSunnyIcon)
        
        setupSunnyIcon.image = UIImage(named: "sunnyIcon")
        
        setupSunnyIcon.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.width.equalTo(24)
            make.centerY.equalTo(temperatureLabel.snp.centerY)
            make.trailing.equalTo(temperatureLabel.snp.leading).offset(-4)
        }
    }
    private func setupNoticeIcon() {
        let setupSunnyIcon = UIImageView()
        view.addSubview(setupSunnyIcon)
        
        setupSunnyIcon.image = UIImage(named: "notice")
        
        setupSunnyIcon.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.width.equalTo(24)
            make.top.equalTo(temperatureLabel.snp.bottom).offset(26)
            make.leading.equalToSuperview().offset(36)
        }
    }
    
    private func noticeView() {
        let noticeV = UIView()
        view.addSubview(noticeV)
        
        noticeV.backgroundColor = UIColor(red: 0.525, green: 0.525, blue: 0.525, alpha: 0.2)
        noticeV.layer.cornerRadius = 20
        
        noticeV.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(temperatureLabel.snp.bottom).offset(10)
            make.width.equalTo(353)
            make.height.equalTo(50)
        }
    }
    
    private func noticeText() {
        let noticeLabel = UILabel()
        view.addSubview(noticeLabel)
        noticeLabel.text = "자켓을 챙기는게 좋겠어요!"
        noticeLabel.font = UIFont.systemFont(ofSize: 14)
        noticeLabel.textColor = .white
        noticeLabel.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25)
        noticeLabel.layer.shadowOpacity = 0.1
        noticeLabel.layer.shadowRadius = 4
        noticeLabel.layer.shadowOffset = CGSize(width: 0, height: 4)

        noticeLabel.snp.makeConstraints { make in
            make.top.equalTo(temperatureLabel.snp.bottom).offset(27)
            make.leading.equalToSuperview().offset(70)
        }
    }
    
    private func setupRefreshButton() {
        let refreshButton = UIButton()
        view.addSubview(refreshButton)

        // 이미지로 버튼 설정
        refreshButton.setImage(UIImage(named: "Refresh"), for: .normal)  // "refreshIcon"은 Assets에 추가한 이미지 이름입니다.

        refreshButton.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25)
        refreshButton.layer.cornerRadius = 12

        // Auto layout 설정
        refreshButton.snp.makeConstraints { make in
            make.width.equalTo(24)  // 이미지의 크기에 따라 조정
            make.height.equalTo(24)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(80)
        }

        // 버튼 액션 추가
        refreshButton.addTarget(self, action: #selector(refreshButtonTapped), for: .touchUpInside)
    }


    @objc private func refreshButtonTapped() {
        let center = naverMapView.mapView.cameraPosition.target
        fetchWeatherData(at: center.lat, lon: center.lng)

        // 위치 업데이트 재시작
        locationManager.startUpdatingLocation()
    }


    let image1 = UIImage(named: "Frame 16")
    let image2 = UIImage(named: "Frame 15")
    let image3 = UIImage(named: "Frame 17")



    private func setupCustomButton() {
        let button = UIButton()
        view.addSubview(button)

        button.backgroundColor = UIColor(red: 0.525, green: 0.525, blue: 0.525, alpha: 0.2)
        button.layer.cornerRadius = 20
        
        button.setImage(image1, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 40) // 원하는 크기로 설정



        // 첫 번째 버튼의 Auto layout 설정
        button.snp.makeConstraints { make in
            make.width.equalTo(111)
            make.height.equalTo(110)
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(686)
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

        // 버튼에 텍스트 설정
        button.setImage(image2, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 40) // 원하는 크기로 설정



        // 두 번째 버튼의 Auto layout 설정
        button.snp.makeConstraints { make in
            make.width.equalTo(111)
            make.height.equalTo(110)
            make.leading.equalTo(self.view).offset(141)
            make.top.equalToSuperview().offset(686)
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
        
        button.setImage(image3, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 40) // 원하는 크기로 설정



        // 세 번째 버튼의 Auto layout 설정
        button.snp.makeConstraints { make in
            make.width.equalTo(111)
            make.height.equalTo(110)
            make.leading.equalTo(self.view).offset(262)
            make.top.equalToSuperview().offset(686)
        }

        // 버튼 액션 추가 (필요한 경우)
        button.addTarget(self, action: #selector(thirdButtonTapped), for: .touchUpInside)
    }

    @objc private func thirdButtonTapped() {
        // 버튼이 클릭될 때 수행할 동작
        print("Third button was tapped!")

        let wearingVC = FoodPairing()

        // 모달로 표시합니다.
        self.present(wearingVC, animated: true, completion: nil)
    }

    // MARK: - 변경 사항 - 날씨를 싱글톤으로 구현된 인스턴스에서 가져옵니다.
    // 날씨 데이터를 가져오는 메서드
    func fetchWeatherData(at lat: Double, lon: Double) {
        viewModel.fetchAndProcessWeatherData(lat: lat, lon: lon) { [weak self] in
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

            // 여기서 현재 위치의 날씨 데이터를 가져옵니다.
            fetchWeatherData(at: coordinate.latitude, lon: coordinate.longitude)
        }
    }
}




//// MARK: - NMFMapViewCameraDelegate Extension
//extension MainView: NMFMapViewCameraDelegate {
//    func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
//        let center = mapView.cameraPosition.target
//        fetchWeatherData(at: center.lat, lon: center.lng)
//    }
//}
