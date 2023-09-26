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
        setupUI()
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
    
    func setupBackgroundImageView() {
        //일출, 일몰, 날씨에 따라서 image 변경
        backgroundImageView.image = UIImage(named: "sunsetImage")
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
        titleLabel.text = "일몰 시간이네요!"
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
        iconImageView.image = UIImage(named: "sunsetIcon")
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
