import UIKit

class ScoreTableViewCell: UITableViewCell {
    static let identifier = String(describing: ScoreTableViewCell.self)
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var minusButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func prepareCell(with scorePlayer: SavedScore) {
        nameLabel.text = scorePlayer.players
        scoreLabel.text = scorePlayer.points.description
    }
    
}
