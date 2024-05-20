//
//  ProfileView.swift
//  About-You
//
//

import UIKit

struct ProfileInfo {
    var ID, title, subtitle: String
    var stats: QuickStats
    var iconImagePath: String
}

class ProfileView: UIView {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subTitleLabel: UILabel!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var statsViewContainerView: UIView!
    @IBOutlet private weak var statsView: UIStackView!
    
    private var actionHandler: (() -> Void)?
    private var profileInfo: ProfileInfo? = nil

    override func awakeFromNib() {
        setUpView()
    }
}

extension ProfileView {
    func configure(with profileInfo: ProfileInfo,
                   actionHandler: (() -> Void)?) {
        titleLabel.text = profileInfo.title
        subTitleLabel.text = profileInfo.subtitle
        loadProfileImageIfCached(with: profileInfo)
        self.actionHandler = actionHandler
        guard let quickStatsView = StatsView.loadView() else { return }
        quickStatsView.configure(data: .init(years: profileInfo.stats.years, coffees: profileInfo.stats.coffees, bugs: profileInfo.stats.bugs))
        statsView.addArrangedSubview(quickStatsView)
        self.profileInfo = profileInfo
    }
}

private extension ProfileView {
    func setUpView() {
        setUpImageSelector()
        applyStyling()
    }

    private func setUpImageSelector() {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        tapGesture.addTarget(self, action: #selector(presentGallery))
        iconImageView.addGestureRecognizer(tapGesture)
    }
    
    private func loadProfileImageIfCached(with profileInfo: ProfileInfo) {
        guard let imageUrl = ImageLoader.shared.imageUrl(id: profileInfo.ID) else { return }
        if let image = ImageLoader.shared.fetchImage(from: imageUrl) {
            iconImageView.image = image
        } else {
            if let image = UIImage(contentsOfFile: profileInfo.iconImagePath) {
                iconImageView.image = image
            }
        }
    }
}

extension ProfileView {
    public func applyStyling(with titleLabelFont: UIFont = UIFont.systemFont(ofSize: 26.0, weight: UIFont.Weight.semibold),
                             titleLabelColor: UIColor = .white,
                             subTitleLabelFont: UIFont = UIFont.systemFont(ofSize: 17.0, weight: UIFont.Weight.regular),
                             subTitleLabelColor: UIColor = .white,
                             cornerRadius: CGFloat = 10.0) {
        titleLabel.configure(with: titleLabelColor, font: titleLabelFont)
        subTitleLabel.configure(with: subTitleLabelColor, font: subTitleLabelFont)
        setCurveable(with: cornerRadius)
    }
    
    static func loadView() -> Self? {
        let bundle = Bundle(for: self)
        let views = bundle.loadNibNamed(String(describing: self), owner: nil, options: nil)
        guard let view = views?.first as? Self else {
            return nil
        }
        return view
    }
    
    @objc func presentGallery() {
        self.actionHandler?()
    }
    
    func setCurveable(with viewCornerRadius: CGFloat = 10.0) {
        layer.cornerRadius = viewCornerRadius
        layer.cornerCurve = .continuous
        
        statsViewContainerView.layer.cornerRadius = viewCornerRadius
        statsViewContainerView.layer.cornerCurve = .continuous
        statsViewContainerView.layer.masksToBounds = true
        
        iconImageView.makeCurvable(with: 10.0)
        iconImageView.clipsToBounds = true
    }
    
    func reloadProfileImage() {
        guard let id = self.profileInfo?.ID,
              let imageUrl = ImageLoader.shared.imageUrl(id: id),
            let image = ImageLoader.shared.fetchImage(from: imageUrl)
        else { return }
        iconImageView.image = image
    }
}
