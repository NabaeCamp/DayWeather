//
//  PlayListViewController.swift
//  DayWeather
//
//  Created by 랑 on 2023/09/25.
//

import UIKit
import SnapKit

class PlayListView: UIViewController {
    
    // MARK: - Properties
    
    private var weatherDataManager = WeatherDataManager.shared
    private var timer = Timer()
    private var backgroundImageView = UIImageView()
    private let dismissButton = UIButton()
    private var titleLabel = UILabel()
    private let subtitleLabel = UILabel() 
    private var iconImageView = UIImageView()
    private let playListCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return view
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataForPlayListView(lat: 37.5665, lon: 126.9780)
        setupUI()
//        let sunrise: Int = 1696368560
//        let sunriseTime = Date(timeIntervalSince1970: TimeInterval(sunrise))
//        let thirtyMinutesBeforeSunTime = sunriseTime.addingTimeInterval(-30 * 60)
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        dateFormatter.timeZone = TimeZone.current
//        guard let time = dateFormatter.string(for: thirtyMinutesBeforeSunTime) else { return }
//        print("\(sunriseTime)")
//        print("\(thirtyMinutesBeforeSunTime)")
//        guard let newDate = dateFormatter.date(from: time) else { return }
//        print("\(newDate)")
        
        //2023-10-03 21:29:20 +0000 +9시간을 더해야함 > 06:29:20
        //timezone: 32400  +09:00
        
    }
    
    // MARK: - UI
    
    func setupUI() {
        view.backgroundColor = .systemBackground
        setupBackgroundImageView()
        setupDismissButton()
        setupTitleLabel()
        setupSubtitleLabel()
        setupIconImageView()
        setupPlayListCollectionView()
    }
    
    func getDataForPlayListView(lat: Double, lon: Double) {
        weatherDataManager.fetchWeatherData(lat: lat, lon: lon) { [weak self] (data, _)  in
            guard let self else { return }
            guard let data = data else { return }
            
            let celsiusTemperature = data.main.feels_like - 273.15
            let sunriseTime = Date(timeIntervalSince1970: TimeInterval(data.sys.sunrise))
            let sunsetTime = Date(timeIntervalSince1970: TimeInterval(data.sys.sunset))
            let currentTime = Date()
            
            if celsiusTemperature < 5 && data.weather.first?.main != "Rain" {
                //추운 날
                DispatchQueue.main.async {
                    self.chageUIForColdWeather()
                }
            } else if celsiusTemperature > 30 && data.weather.first?.main != "Rain" {
                //더운 날
                DispatchQueue.main.async {
                    self.chageUIForHotWeather()
                }
            } else if data.weather.first?.main == "Rain" {
                //비오는 날
                DispatchQueue.main.async {
                    self.chageUIForRainyWeather()
                }
            } else if currentTime >= calculateSunTime(sunriseTime) && currentTime <= sunriseTime {
                //일출 30분 전부터 일출 때까지
                DispatchQueue.main.async {
                    self.chageUIForSunrise()
                }
            } else if currentTime >= calculateSunTime(sunsetTime) && currentTime <= sunsetTime {
                //일몰 30분 전부터 일출 때까지
                DispatchQueue.main.async {
                    self.chageUIForSunset()
                }
            } else {
                DispatchQueue.main.async {
                    self.backgroundImageView.image = UIImage(named: "summerImage")
                    self.titleLabel.text = "너무 더워요🥵"
                    self.iconImageView.image = UIImage(named: "sunIcon")
                }
            }
        }
    }
    
    func calculateSunTime(_ date: Date) -> Date {
        let thirtyMinutesBeforeSunTime = date.addingTimeInterval(-30 * 60)
        
        return thirtyMinutesBeforeSunTime
    }
    
    func chageUIForHotWeather() {
        backgroundImageView.image = UIImage(named: "summerImage")
        titleLabel.text = "너무 더워요🥵"
        iconImageView.image = UIImage(named: "sunIcon")
    }
    
    func chageUIForColdWeather() {
        backgroundImageView.image = UIImage(named: "winterImage")
        titleLabel.text = "얼어 죽겠어요🥶"
        iconImageView.image = UIImage(named:"coldIcon")
        
    }
    
    func chageUIForRainyWeather() {
        backgroundImageView.image = UIImage(named: "rainImage")
        titleLabel.text = "비가 내리네요"
        iconImageView.image = UIImage(named: "rainIcon2")
        
    }
    
    func chageUIForSunrise() {
        backgroundImageView.image = UIImage(named: "sunriseImage")
        titleLabel.text = "같이 일출 구경할까요?"
        iconImageView.image = UIImage(named: "sunriseIcon")
        
    }
    
    func chageUIForSunset() {
        backgroundImageView.image = UIImage(named: "sunsetImage")
        titleLabel.text = "같이 일몰 구경할까요?"
        iconImageView.image = UIImage(named: "sunsetIcon")
    }
    
    func setupBackgroundImageView() {
        //일출, 일몰, 날씨(추운 날, 더운 날, 비오는 날, 눈 내리는 날) 에 따라서 image 변경
        //바람부는 날: Wind.speed > 몇 이상
        //main: "Clear", description: "clear sky"
        
        //backgroundImageView.image = UIImage(named: "sunsetImage")
        view.addSubview(backgroundImageView)
        
        backgroundImageView.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview()
        }
    }
    
    func setupDismissButton() {
        dismissButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        dismissButton.tintColor = .white
        dismissButton.addTarget(self, action: #selector(didTapDismissButton), for: .touchUpInside)
        view.addSubview(dismissButton)
        
        dismissButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.right.equalToSuperview().offset(-20)
        }
    }
    
    func setupTitleLabel() {
        //일출, 일몰시간 & 날씨에 따라서 text 변경
        //일출: Sys.sunrise 해뜨기 전 30분 전부터 / 곧 일출이 시작돼요!
        //일몰: Sys.sunset 해지기 전 30분 전부터 / 곧 일몰이 시작돼요!
        //titleLabel.text = "일몰 시간이네요!"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 30)
        titleLabel.textColor = .white
        view.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(dismissButton.snp.bottom).offset(80)
            $0.centerX.equalToSuperview()
        }
    }
    
    func setupSubtitleLabel() {
        subtitleLabel.text = "이런 노래 어떠세요?"
        subtitleLabel.textColor = .white
        view.addSubview(subtitleLabel)
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
    }
    
    func setupIconImageView(){
        //일출, 일몰, 날씨에 따라서 icon 변경
        //iconImageView.image = UIImage(named: "sunsetIcon")
        view.addSubview(iconImageView)
        
        iconImageView.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(5)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(70)
        }
    }
    
    func setupPlayListCollectionView(){
        playListCollectionView.delegate = self
        playListCollectionView.dataSource = self
        playListCollectionView.register(PlayListCollectionViewCell.self, forCellWithReuseIdentifier: PlayListCollectionViewCell.identifier)
        
        playListCollectionView.backgroundColor = .clear
        view.addSubview(playListCollectionView)
        
        playListCollectionView.snp.makeConstraints {
            $0.top.equalTo(iconImageView.snp.bottom).offset(15)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Helpers
    
    @objc func didTapDismissButton() {
        dismiss(animated: true)
    }
    
}

extension PlayListView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("you tapped index: \(indexPath.row)!")
    }
}

extension PlayListView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = playListCollectionView.dequeueReusableCell(withReuseIdentifier: PlayListCollectionViewCell.identifier, for: indexPath) as? PlayListCollectionViewCell
        else { return UICollectionViewCell() }
        
        return cell
    }
}

extension PlayListView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
}
