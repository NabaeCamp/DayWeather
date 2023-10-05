//
//  PlayListViewController.swift
//  DayWeather
//
//  Created by 랑 on 2023/09/25.
//

import UIKit
import SnapKit
import CoreLocation

class PlayListView: UIViewController {
    
    // MARK: - Properties
    
    private var weatherDataManager = WeatherDataManager.shared
    private let playListViewModel = PlayListViewModel()
    private let locationManager = CLLocationManager()
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
    lazy var playList: [PlayList] = [
    PlayList(albumCover: UIImage(named: "albumCover"), song: "우산(Feat.윤하)", singer: "에픽하이"),
    PlayList(albumCover: UIImage(named: "albumCover"), song: "빗소리", singer: "윤하"),
    PlayList(albumCover: UIImage(named: "albumCover"), song: "비 오는 날 듣기 좋은 노래(Feat.Colde)", singer: "에픽하이"),
    PlayList(albumCover: UIImage(named: "albumCover"), song: "북향(Feat.오혁)", singer: "다이나믹 듀오"),
    PlayList(albumCover: UIImage(named: "albumCover"), song: "비도 오고 그래서", singer: "헤이즈"),
    PlayList(albumCover: UIImage(named: "albumCover"), song: "잠 못 드는 밤 비는 내리고", singer: "김건모"),
    PlayList(albumCover: UIImage(named: "albumCover"), song: "비", singer: "폴킴"),
    PlayList(albumCover: UIImage(named: "albumCover"), song: "비가 오는 날엔", singer: "비스트"),
    PlayList(albumCover: UIImage(named: "albumCover"), song: "비가 오잖아", singer: "소유 & 오반"),
    PlayList(albumCover: UIImage(named: "albumCover"), song: "밤편지", singer: "아이유")
    ]
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoactionManager()
        setupUI()
    }
    
    // MARK: - UI
    
    func setupUI() {
        view.backgroundColor = .systemBackground
        setupBackgroundImageView()
        setupDismissButton()
        setupTitleLabel()
        setupSubtitleLabel()
        setupPlayListCollectionView()
    }
    
    func setupBackgroundImageView() {
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
    
    func setupPlayListCollectionView(){
        playListCollectionView.delegate = self
        playListCollectionView.dataSource = self
        playListCollectionView.register(PlayListCollectionViewCell.self, forCellWithReuseIdentifier: PlayListCollectionViewCell.identifier)
        
        playListCollectionView.backgroundColor = .clear
        view.addSubview(playListCollectionView)
        
        playListCollectionView.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Helpers
    
    func setupLoactionManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    @objc func didTapDismissButton() {
        dismiss(animated: true)
    }
    
}

extension PlayListView: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        print(lat, lon)
        
        playListViewModel.getDataForPlayListView(lat: lat, lon: lon) { [weak self] backgroundImage, titleText in
            guard let self else { return }
            
            DispatchQueue.main.async {
                self.backgroundImageView.image = backgroundImage
                self.titleLabel.text = titleText
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

extension PlayListView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("you tapped index: \(indexPath.row)!")
    }
}

extension PlayListView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = playListCollectionView.dequeueReusableCell(withReuseIdentifier: PlayListCollectionViewCell.identifier, for: indexPath) as? PlayListCollectionViewCell
        else { return UICollectionViewCell() }
        
        cell.albumCoverImageView.image = playList[indexPath.row].albumCover
        cell.songTitleLabel.text = playList[indexPath.row].song
        cell.singerNameLabel.text = playList[indexPath.row].singer
        
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
