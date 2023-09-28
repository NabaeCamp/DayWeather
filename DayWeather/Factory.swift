//
//  Factory.swift
//  DayWeather
//
//  Created by Jack Lee on 2023/09/25.
//

import UIKit

func addImage(withImage image: String) -> UIImageView {
    let iv = UIImageView()
    let image = UIImage(named: image)
    iv.image = image
    iv.translatesAutoresizingMaskIntoConstraints = false
    return iv
}

func makeLabel(withText text: String, size: CGFloat) -> UILabel {
    let label = UILabel()
    label.text = text
    label.textColor = .white
    label.font = UIFont.systemFont(ofSize: size)
    label.shadowColor = .black
    label.shadowOffset = CGSize(width: 0, height: -1)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
}

func makeButton(withImage name: String, action: Selector, target: Any) -> UIButton {
    let button = UIButton()
    let image = UIImage(systemName: name)?.withTintColor(.white, renderingMode: .alwaysOriginal)
    button.setImage(image, for: .normal)
    button.addTarget(target, action: action, for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
}

func giveShadowAndRoundedCorners(to view: UIView) {
    view.layer.cornerRadius = 10  // 이 값을 조절하여 모서리 반올림 크기를 변경
    view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
    view.layer.shadowOpacity = 1
    view.layer.shadowRadius = 4
    view.layer.shadowOffset = CGSize(width: 0, height: 4)
    view.clipsToBounds = true  // 이 부분은 모서리 반올림 부분을 잘라내기 위해 추가
}

extension UIButton {
    var circleButton: Bool {
        set {
            if newValue {
                self.layer.cornerRadius = self.frame.size.width / 2
                print(self.frame.size.width)
            } else {
                self.layer.cornerRadius = 0
            }
        } get {
            return false
        }
    }
}
