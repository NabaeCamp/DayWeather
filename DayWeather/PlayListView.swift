//
//  PlayListViewController.swift
//  DayWeather
//
//  Created by 랑 on 2023/09/25.
//

import UIKit
import SnapKit

class PlayListView: UIViewController {
    
    private let dismissButton = UIButton()
    private var statusLabel = UILabel()
    private let defaultLabel = UILabel()
    private var iconImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }
    
    func setupUI() {
        setupDismissButton()
        setupStatusLabel()
        setupDefaultLabel()
        setupIconImageView()
    }
    
    func setupDismissButton() {
        dismissButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        dismissButton.addTarget(self, action: #selector(didTapDismissButton), for: .touchUpInside)
        view.addSubview(dismissButton)
        
        dismissButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.right.equalToSuperview().offset(-20)
        }
    }
    
    func setupStatusLabel() {
        //일출, 일몰시간 & 날씨에 따라서 text 변경
        statusLabel.text = "일몰 시간이네요!"
        statusLabel.font = UIFont.boldSystemFont(ofSize: 30)
        view.addSubview(statusLabel)
        
        statusLabel.snp.makeConstraints{
            $0.top.equalTo(dismissButton.snp.bottom).offset(80)
            $0.centerX.equalToSuperview()
        }
    }
    
    func setupDefaultLabel() {
        defaultLabel.text = "이런 노래 어떠세요?"
        view.addSubview(defaultLabel)
        
        defaultLabel.snp.makeConstraints {
            $0.top.equalTo(statusLabel.snp.bottom).offset(15)
            $0.centerX.equalToSuperview()
        }
    }
    
    func setupIconImageView(){
        //일출, 일몰, 날씨에 따라서 icon 변경
        iconImageView.image = UIImage(named: "sunset")
        view.addSubview(iconImageView)
        
        iconImageView.snp.makeConstraints {
            $0.top.equalTo(defaultLabel.snp.bottom).offset(15)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(70)
        }
    }
    
    @objc func didTapDismissButton() {
        dismiss(animated: true)
    }
    
}
