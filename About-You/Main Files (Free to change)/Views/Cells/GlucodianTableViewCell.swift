import UIKit

class GlucodianTableViewCell: UITableViewCell {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        applyStyling()
    }

    func setUp(with name: String, role: String) {
        nameLabel.text = name
        roleLabel.text = role
    }
}

extension GlucodianTableViewCell {
    func loadProfileImageIfCached(with id: String) {
        profileImage.image = UIImage(systemName: "person.fill")
        guard let imageUrl = ImageLoader.shared.imageUrl(id: id) else { return }
        if let image = ImageLoader.shared.fetchImage(from: imageUrl) {
            profileImage.image = image
        }
    }
    
    func applyStyling() {
        profileImage.makeCurvable(with: 10.0)
    }
}
