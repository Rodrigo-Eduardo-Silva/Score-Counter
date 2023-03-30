import UIKit

class GameCoverCollectionViewCell: UICollectionViewCell {

    static let indetifier = String(describing: GameCoverCollectionViewCell.self)
    @IBOutlet weak var imageCover: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func prepareCell(with image: UIImage) {
        imageCover.image = image
    }

}
