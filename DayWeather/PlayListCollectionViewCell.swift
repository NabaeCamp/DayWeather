//
//  PlayListCollectionViewCell.swift
//  DayWeather
//
//  Created by 랑 on 2023/09/25.
//

import UIKit
import SnapKit

class PlayListCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PlayListCollectionViewCell"
    
    private let playListView = UIView()
    private var albumCoverImageView = UIImageView()
    private var songTitleLabel = UILabel()
    private var singerNameLabel = UILabel()
    private let musicInfoStackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        setupPlayListView()
        setupAlbumCoverImageView()
        setupSongtitleLabel()
        setupSingerNameLabel()
        setupMusicInfoStackView()
        setupMusicStackView()
    }
    
    func setupPlayListView() {
        playListView.backgroundColor = UIColor(red: 0.254, green: 0.254, blue: 0.254, alpha: 0.4)
        playListView.layer.cornerRadius = 20
        playListView.clipsToBounds = true   // 뷰 셀 경계에 맞게 설정
        addSubview(playListView)
        
        playListView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(80)
        }
    }
    
    func setupAlbumCoverImageView() {
        albumCoverImageView.image = UIImage(named: "albumCover")
        albumCoverImageView.layer.cornerRadius = 18
        albumCoverImageView.clipsToBounds = true
        playListView.addSubview(albumCoverImageView)
        
        albumCoverImageView.snp.makeConstraints {
            $0.height.width.equalTo(60)
        }
    }
    
    func setupSongtitleLabel() {
        songTitleLabel.text = "How You Like That"
        songTitleLabel.textColor = .white
        songTitleLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
    }
    
    func setupSingerNameLabel() {
        singerNameLabel.text = "BLACKPINK"
        singerNameLabel.textColor = .white
        singerNameLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
    }
    
    func setupMusicInfoStackView() {
        musicInfoStackView.axis = .vertical
        musicInfoStackView.alignment = .leading
        musicInfoStackView.distribution = .fillEqually
        musicInfoStackView.spacing = 6
        musicInfoStackView.addArrangedSubview(songTitleLabel)
        musicInfoStackView.addArrangedSubview(singerNameLabel)
    }
    
    func setupMusicStackView() {
        let musicStackView = UIStackView()
        musicStackView.axis = .horizontal
        musicStackView.alignment = .center
        musicStackView.spacing = 14
        musicStackView.addArrangedSubview(albumCoverImageView)
        musicStackView.addArrangedSubview(musicInfoStackView)
        playListView.addSubview(musicStackView)
        
        musicStackView.snp.makeConstraints {
            $0.top.left.equalToSuperview().offset(10)
        }
    }
}
