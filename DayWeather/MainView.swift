//
//  ViewController.swift
//  DayWeather
//
//  Created by Jack Lee on 2023/09/25.
//

import UIKit
import NMapsMap
import SnapKit

class MainView: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBackgroundImage()
        setupBackgroundImage()
        setupNaverMapView()
        setupLocationLabel()
        setupCityLabel()
        setupTemperatureLabel()
        setupCustomButton()
        setupSecondCustomButton()
        setupThirdCustomButton()


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

        let naverMapView = NMFNaverMapView(frame: mapViewContainer.bounds)
        mapViewContainer.addSubview(naverMapView)
        naverMapView.showCompass = true
        naverMapView.showScaleBar = true
        naverMapView.showZoomControls = true
        naverMapView.showLocationButton = true

        naverMapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
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

    private func setupCityLabel()  {
        let label = UILabel()
        view.addSubview(label)

        label.text = "서울특별시"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 32)
        label.attributedText = NSMutableAttributedString(string: "서울특별시", attributes: [NSAttributedString.Key.kern: -0.54])

        // 그림자 효과
        label.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        label.layer.shadowOpacity = 1
        label.layer.shadowRadius = 2
        label.layer.shadowOffset = CGSize(width: 0, height: 2)

        // Auto layout 설정
        label.numberOfLines = 1
        label.snp.makeConstraints { make in
            // make.width.equalTo(200)  // 이 줄을 제거
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(160)
        }




    }

    private func setupTemperatureLabel()  {
        let label = UILabel()
        view.addSubview(label)

        label.text = "26º"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 32)
        label.attributedText = NSMutableAttributedString(string: "26º", attributes: [NSAttributedString.Key.kern: -1.53])

        // 그림자 효과
        label.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        label.layer.shadowOpacity = 1
        label.layer.shadowRadius = 4
        label.layer.shadowOffset = CGSize(width: 0, height: 4)

        // Auto layout 설정
        label.numberOfLines = 1
        label.snp.makeConstraints { make in
            // make.width.equalTo(100)  // 이 줄을 제거
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(220)
        }




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
        // 버튼이 클릭될 때 수행할 동작
        print("Button was tapped!")
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
        // 버튼이 클릭될 때 수행할 동작
        print("Second button was tapped!")
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

}


