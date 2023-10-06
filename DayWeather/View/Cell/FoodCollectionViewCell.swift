//
//  FoodCollectionView.swift
//  DayWeather
//
//  Created by Jack Lee on 2023/09/26.
//

import UIKit

final class FoodCollectionViewCell: UICollectionViewCell {
    static let identifier = "FoodCollectionViewCell"
    
    private lazy var imageView: UIImageView = {
        let view                = UIImageView()
        let image               = UIImage(systemName: "photo")
        view.image              = image
        view.contentMode        = .scaleAspectFit
        view.frame.size         = CGSize(width: 60, height: 60)
        view.layer.cornerRadius = self.frame.width / 2
        view.clipsToBounds      = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setImage(with image: String) {
        imageView.image         = UIImage(named: image)
    }
}
