import UIKit

protocol ScoreTableViewCellDelegate: AnyObject {
    func plusPoint(index: Int)
    func subtractPoint(index: Int)
 }

class ScoreTableViewCell: UITableViewCell {
    weak var delegate: ScoreTableViewCellDelegate?
    var index: Int = -1
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
    func prepareCell(with scorePlayer: Score, at index: Int) {
        self.index = index
        nameLabel.text = scorePlayer.player
        scoreLabel.text = scorePlayer.points.description
    }
    
    @IBAction func plusScore(_ sender: Any) {
        delegate?.plusPoint(index: index)
    }
    
    @IBAction func minusScore(_ sender: Any) {
        delegate?.subtractPoint(index: index)
    }
    
    
}
