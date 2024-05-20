//
//  Extensions.swift
//  About-You
//
//

import Foundation
import UIKit

public extension UILabel {
    func configure(with textColor: UIColor, font: UIFont, numberOfLines: Int = 0) {
        self.textColor = textColor
        self.font = font
        self.numberOfLines = numberOfLines
    }
}


public extension UIImageView {
    func makeCurvable(with radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.cornerCurve = .continuous
        
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.clear.cgColor
        self.contentMode = .scaleAspectFill
    }
}
