//
//  StatsView.swift
//  About-You
//
//

import UIKit

class StatsView: UIView {
    @IBOutlet private weak var firstTitleLabel: UILabel!
    @IBOutlet private weak var secondTitleLabel: UILabel!
    @IBOutlet private weak var thirdTitleLabel: UILabel!
    @IBOutlet private weak var firstSubTitleLabel: UILabel!
    @IBOutlet private weak var secondSubTitleLabel: UILabel!
    @IBOutlet private weak var thirdSubTitleLabel: UILabel!
    
    override func awakeFromNib() {
        applyStyling()
    }
}

extension StatsView {
    public func applyStyling(with titleLabelFont: UIFont = UIFont.systemFont(ofSize: 15.0, weight: UIFont.Weight.regular),
                             titleLabelColor: UIColor = .black,
                             subTitleLabelFont: UIFont = UIFont.systemFont(ofSize: 13.0, weight: UIFont.Weight.bold),
                             subTitleLabelColor: UIColor = .black,
                             viewCornerRadius: CGFloat = 10.0) {
        firstTitleLabel.configure(with: titleLabelColor, font: titleLabelFont)
        secondTitleLabel.configure(with: titleLabelColor, font: titleLabelFont)
        thirdTitleLabel.configure(with: titleLabelColor, font: titleLabelFont)
        
        firstSubTitleLabel.configure(with: subTitleLabelColor, font: subTitleLabelFont)
        secondSubTitleLabel.configure(with: subTitleLabelColor, font: subTitleLabelFont)
        thirdSubTitleLabel.configure(with: subTitleLabelColor, font: subTitleLabelFont)
    }
    
    static func loadView() -> Self? {
        let bundle = Bundle(for: self)
        let views = bundle.loadNibNamed(String(describing: self), owner: nil, options: nil)
        guard let view = views?.first as? Self else {
            return nil
        }
        return view
    }
}

extension StatsView {
    func configure(data: QuickStats) {
        firstTitleLabel.text = "Years"
        secondTitleLabel.text = "Coffees"
        thirdTitleLabel.text = "Bugs"
        
        firstSubTitleLabel.text = String(format: "%d", data.years)
        secondSubTitleLabel.text = String(format: "%d", data.coffees)
        thirdSubTitleLabel.text = String(format: "%d", data.bugs)
    }
}
