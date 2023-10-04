//
//  WearingViewController.swift
//  DayWeather
//
//  Created by t2023-m0088 on 2023/09/25.
//

import UIKit
import SwiftUI
import SnapKit
import CoreLocation

class WearingViewController: UIViewController {
    
    var sectionHeaderTitle = "현재 날씨에 알맞는 옷을 추천드립니다"
    
    
    
    private let viewModel = WearingViewModel()
    
    let locationManager = CLLocationManager()
    //    var weatherManager = WeatherManager()
    
    struct Item {
        let image: UIImage
    }
    
    var images: [UIImage] = [
        UIImage(named: "cloth1")!,
        UIImage(named: "cloth2")!,
        UIImage(named: "cloth3")!,
        UIImage(named: "cloth4")!,
        UIImage(named: "cloth5")!,
    ]
    
    var nowTemp = "26"
    
    var item = ["1","2","3","4","5"]
    
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
        view.text = "80˚"
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
    var wearCollectionView : UICollectionView = {
        var view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.backgroundColor = .clear
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        addSubViewAll()
        xBtn.addTarget(self, action: #selector(dismissBtnClick), for: .touchUpInside)
        self.wearCollectionView.delegate = self
        self.wearCollectionView.dataSource = self
        self.wearCollectionView.register(WearCollectionViewCell.self, forCellWithReuseIdentifier: WearCollectionViewCell.identifier)
        self.wearCollectionView.register(WearCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "WearCollectionReusableView")
        compositionalLayout()
        
        viewModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    @objc func dismissBtnClick(){
        self.dismiss(animated: true)
    }
    
    
    
    func addSubViewAll(){
        [allScreen,xBtn,tempLabel,titleLabel,subTitle,noticeView,noticeIcon,noticeLabel,wearCollectionView].forEach{
            view?.addSubview($0)}
        configureAllScreen()
        configureXBtn()
        configureTemp()
        configureTitle()
        configureSubTitle()
        configureNotice()
        configureNoticeIcon()
        configureNoticeLabel()
        configureWearingCollection()
        compositionalLayout()
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
    func configureWearingCollection(){
        wearCollectionView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(noticeView.snp.bottom).offset(10)
            make.bottom.equalToSuperview().offset(-40)
            
        }
    }
    
    func compositionalLayout(){
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            switch sectionIndex {
            case 0, 1, 2, 3, 4:
                // Define a horizontal group (가로 스크롤) for sections 0 and 1
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(0.86))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .fractionalHeight(0.4))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.interGroupSpacing = 0
                // Add a header to the section
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(30))
                let headerElement = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                section.boundarySupplementaryItems = [headerElement]
                return section
            default:
                return nil
            }
        }
        // Set the compositional layout to the collection view
        wearCollectionView.collectionViewLayout = layout
    }
    
    private func supplementaryHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50)),
              elementKind: UICollectionView.elementKindSectionHeader, alignment: .top
        )
    }
    
}

extension WearingViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "wearCollectionViewCell", for: indexPath) as! WearCollectionViewCell
        let image = images[indexPath.item]
        cell.imageView.image = image
        let cellWidth = cell.bounds.width
        let cellHeight = cell.bounds.height
        let scaledImage = image.resized(to: CGSize(width: cellWidth, height: cellHeight))
        cell.imageView.image = scaledImage
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "WearCollectionReusableView", for: indexPath) as! WearCollectionReusableView
            headerView.setTitle(sectionHeaderTitle)
            return headerView
        } else {
            return UICollectionReusableView()
        }
    }
    
    
}
extension WearingViewController: UICollectionViewDelegateFlowLayout{
    
}
extension UIImage {
    func resized(to targetSize: CGSize) -> UIImage {
        let size = self.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        let newSize = widthRatio > heightRatio ?
        CGSize(width: size.width * heightRatio, height: size.height * heightRatio) :
        CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
extension WearingViewController:CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first{
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            //        print(lat,lon)
            viewModel.fetchAndProcessWeatherData(lat: lat, lon: lon, completion: updateView)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}

extension WearingViewController:WearingDelegate{
    
    func updateView() {
        DispatchQueue.main.async {
            //            let temperature = self.viewModel.temperature
            
            let noticeMent: String
            let titleMent: String
            var headerMent = self.sectionHeaderTitle
            if let temperature = self.viewModel.temperature{
                let temperatureValue = temperature.replacingOccurrences(of: "º", with: "")
                if let value = Double(temperatureValue){
                    switch value {
                    case ..<0:
                        noticeMent = "저라면 나가지않을것 같은 추위군요"
                        titleMent = "강 추위 입니다"
                        headerMent = "살아남기 위한 따뜻한 룩"
                    case 0...10:
                        noticeMent = "겁먹은것 처럼 보이지않으려면 패딩을 챙기세요"
                        titleMent = "상당한 추위네요"
                        headerMent = "추위에 견디기 딱 좋은 룩"
                    case 11...25:
                        noticeMent = "자켓을 챙기는게 좋겠어요!"
                        titleMent = "일교차가 커요"
                        headerMent = "큰 일교차에 걸맞는 룩"
                    case 26...30:
                        noticeMent = "우산을 챙겨두면 칭찬받을거에요 :)"
                        titleMent = "비를 조심하세요"
                        headerMent = "비를 대비한 최적의 룩"
                    case 31...40:
                        noticeMent = "이런 날씨에 양산은 필수라구요."
                        titleMent = "밖은 너무 더워요"
                        headerMent = "더운 날씨에 제격인 시원한 룩"
                    default:
                        noticeMent = "나가지 마세요."
                        titleMent = "위험한 날씨입니다"
                        headerMent = "이정도면 벗고 다니셔야겠어요"
                        
                    }
                    self.tempLabel.text = temperature
                    self.noticeLabel.text = noticeMent
                    self.titleLabel.text = titleMent
                    self.sectionHeaderTitle = headerMent
//                    self.titleLabel.text = titleMent
                    self.wearCollectionView.reloadData()

                }
            }
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
