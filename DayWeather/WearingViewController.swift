//
//  WearingViewController.swift
//  DayWeather
//
//  Created by t2023-m0088 on 2023/09/25.
//

import UIKit
import SwiftUI
import SnapKit

class WearingViewController: UIViewController {
    
    var nowTemp = "26"
    
    var allScreen : UIImageView = {
        var view = UIImageView()
        view.image = UIImage(named: "clothBack")
        return view
    }()
    var xBtn : UIButton = {
        var view = UIButton()
        view.setImage(UIImage(named: "xBtn"), for: .normal)
        return view
    }()
    var tempLabel : UILabel = {
        var view = UILabel()
        view.text = "26˚"
        view.font = UIFont.systemFont(ofSize: 20)
        view.textColor = .white
        view.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25)
        view.layer.shadowOpacity = 0.4
        view.layer.shadowRadius = 4
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        return view
    }()
    var titleLabel : UILabel = {
        var view = UILabel()
        view.text = "날씨가 흐리네요"
        view.font = UIFont.systemFont(ofSize: 36)
        view.textColor = .white
        view.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25)
        view.layer.shadowOpacity = 0.4
        view.layer.shadowRadius = 4
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        return view
    }()
    var subTitle : UILabel = {
        var view = UILabel()
        view.text = "이런 옷은 어떠세요?"
        view.font = UIFont.systemFont(ofSize: 12)
        view.textColor = .white
        view.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25)
        view.layer.shadowOpacity = 0.4
        view.layer.shadowRadius = 4
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        return view
    }()
    var noticeView : UIView = {
        var view = UIView()
        view.backgroundColor = UIColor(red: 0.525, green: 0.525, blue: 0.525, alpha: 0.2)
        view.layer.cornerRadius = 20
        return view
    }()
    var noticeIcon : UIImageView = {
        var view = UIImageView()
        view.image = UIImage(named: "rainIcon")
        return view
    }()
    var noticeLabel : UILabel = {
        var view = UILabel()
        view.text = "우산을 챙기셔야겠는데요?"
        view.font = UIFont.systemFont(ofSize: 14)
        view.textColor = .white
        view.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25)
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 4
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        return view
    }()
    var clothViewType1 : UIImageView = {
        var view = UIImageView()
        view.backgroundColor = UIColor(red: 0.525, green: 0.525, blue: 0.525, alpha: 0.2)
        view.layer.cornerRadius = 20
        view.image = UIImage(named: "cloth1")
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()
    var clothViewLabel1 : UILabel = {
        var view = UILabel()
        view.text = "그린 레터링 맨투맨"
        view.font = UIFont.systemFont(ofSize: 14)
        view.textColor = .white
        view.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25)
        view.layer.shadowOpacity = 0.7
        view.layer.shadowRadius = 4
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        return view
    }()
    var clothViewType2 : UIImageView = {
        var view = UIImageView()
        view.backgroundColor = UIColor(red: 0.525, green: 0.525, blue: 0.525, alpha: 0.2)
        view.layer.cornerRadius = 20
        view.image = UIImage(named: "cloth2")
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()
    var clothViewLabel2 : UILabel = {
        var view = UILabel()
        view.text = "레이 스트링 카고팬츠"
        view.font = UIFont.systemFont(ofSize: 14)
        view.textColor = .white
        view.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25)
        view.layer.shadowOpacity = 0.7
        view.layer.shadowRadius = 4
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        return view
    }()
    var clothViewType3 : UIImageView = {
        var view = UIImageView()
        view.backgroundColor = UIColor(red: 0.525, green: 0.525, blue: 0.525, alpha: 0.2)
        view.layer.cornerRadius = 20
        view.image = UIImage(named: "cloth3")
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()
    var clothViewLabel3 : UILabel = {
        var view = UILabel()
        view.text = "어반 숏 스티치 비니"
        view.font = UIFont.systemFont(ofSize: 20)
        view.textColor = .white
        view.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25)
        view.layer.shadowOpacity = 0.7
        view.layer.shadowRadius = 4
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        return view
    }()
    var clothViewType4 : UIImageView = {
        var view = UIImageView()
        view.backgroundColor = UIColor(red: 0.525, green: 0.525, blue: 0.525, alpha: 0.2)
        view.layer.cornerRadius = 20
        view.image = UIImage(named: "cloth4")
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()
    var clothViewLabel4 : UILabel = {
        var view = UILabel()
        view.text = "레거시 와이어 데님 팬츠"
        view.font = UIFont.systemFont(ofSize: 14)
        view.textColor = .white
        view.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25)
        view.layer.shadowOpacity = 0.7
        view.layer.shadowRadius = 4
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        return view
    }()
    var clothViewType5 : UIImageView = {
        var view = UIImageView()
        view.backgroundColor = UIColor(red: 0.525, green: 0.525, blue: 0.525, alpha: 0.2)
        view.layer.cornerRadius = 20
        view.image = UIImage(named: "cloth5")
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()
    var clothViewType6 : UIImageView = {
        var view = UIImageView()
        view.backgroundColor = UIColor(red: 0.525, green: 0.525, blue: 0.525, alpha: 0.2)
        view.layer.cornerRadius = 20
        view.image = UIImage(named: "cloth6")
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubViewAll()
        xBtn.addTarget(self, action: #selector(dismissBtnClick), for: .touchUpInside)
        

    }
    
    @objc func dismissBtnClick(){
        self.dismiss(animated: true)
    }

    
    func addSubViewAll(){
        [allScreen,xBtn,tempLabel,titleLabel,subTitle,noticeView,noticeIcon,noticeLabel,clothViewType1,clothViewLabel1,clothViewType2,clothViewLabel2,clothViewType3,clothViewLabel3,clothViewType4,clothViewLabel4,clothViewType5,clothViewType6].forEach{
            view?.addSubview($0)}
        configureAllScreen()
        configureXBtn()
        configureTemp()
        configureTitle()
        configureSubTitle()
        configureNotice()
        configureNoticeIcon()
        configureNoticeLabel()
        configureClothType1()
        configureClothLabel1()
        configureClothType2()
        configureClothLabel2()
        configureClothType3()
        configureClothLabel3()
        configureClothType4()
        configureClothLabel4()
        configureClothType5()
        configureClothType6()
        
    }
    func configureAllScreen(){
        allScreen.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    func configureXBtn(){
        xBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(60)
        }
    }
    func configureTemp(){
        tempLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(110)
        }
    }
    func configureTitle(){
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(tempLabel.snp.bottom).offset(10)
        }
    }
    func configureSubTitle(){
        subTitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
        }
    }
    func configureNotice(){
        noticeView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(subTitle.snp.bottom).offset(26)
            make.width.equalTo(353)
            make.height.equalTo(50)
        }
    }
    func configureNoticeIcon(){
        noticeIcon.snp.makeConstraints { make in
            make.centerY.equalTo(noticeView.snp.centerY)
            make.leading.equalTo(noticeView.snp.leading).offset(16)
            make.width.equalTo(16)
            make.height.equalTo(16)
        }
    }
    func configureNoticeLabel(){
        noticeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(noticeView.snp.centerY)
            make.leading.equalTo(noticeIcon.snp.trailing).offset(12)
        }
    }
    func configureClothType1(){
        clothViewType1.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(noticeView.snp.bottom).offset(10)
            make.width.equalTo(170)
            make.height.equalTo(170)
        }
    }
    func configureClothLabel1(){
        clothViewLabel1.snp.makeConstraints { make in
            make.centerX.equalTo(clothViewType1.snp.centerX)
            make.bottom.equalTo(clothViewType1.snp.bottom).offset(-10)
        }
    }
    func configureClothType2(){
        clothViewType2.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(noticeView.snp.bottom).offset(10)
            make.width.equalTo(170)
            make.height.equalTo(170)
        }
    }
    func configureClothLabel2(){
        clothViewLabel2.snp.makeConstraints { make in
            make.centerX.equalTo(clothViewType2.snp.centerX)
            make.bottom.equalTo(clothViewType2.snp.bottom).offset(-10)
        }
    }
    func configureClothType3(){
        clothViewType3.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(clothViewType1.snp.bottom).offset(10)
            make.height.equalTo(200)
        }
    }
    func configureClothLabel3(){
        clothViewLabel3.snp.makeConstraints { make in
            make.centerX.equalTo(clothViewType3.snp.centerX)
            make.bottom.equalTo(clothViewType3.snp.bottom).offset(-10)
        }
    }
    func configureClothType4(){
        clothViewType4.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(clothViewType3.snp.bottom).offset(10)
            make.width.equalTo(170)
            make.height.equalTo(280)
        }
    }
    func configureClothLabel4(){
        clothViewLabel4.snp.makeConstraints { make in
            make.centerX.equalTo(clothViewType4.snp.centerX)
            make.bottom.equalTo(clothViewType4.snp.bottom).offset(-10)
        }
    }
    func configureClothType5(){
        clothViewType5.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(clothViewType3.snp.bottom).offset(10)
            make.width.equalTo(82)
            make.height.equalTo(280)
        }
    }
    func configureClothType6(){
        clothViewType6.snp.makeConstraints { make in
            make.trailing.equalTo(clothViewType5.snp.leading).offset(-6)
            make.top.equalTo(clothViewType3.snp.bottom).offset(10)
            make.width.equalTo(82)
            make.height.equalTo(280)
        }
    }
    
    

}

#if DEBUG

struct ViewControllerRepresentable: UIViewControllerRepresentable{
    
    //    update
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
    @available(iOS 13.0, *)
    func makeUIViewController(context: Context) -> UIViewController {
        WearingViewController()
    }
    //    makeui
    
}


struct ViewController_Previews: PreviewProvider{
    static var previews: some View{
        ViewControllerRepresentable()
            .previewDisplayName("아이폰 14")
        
    }
}


#endif
