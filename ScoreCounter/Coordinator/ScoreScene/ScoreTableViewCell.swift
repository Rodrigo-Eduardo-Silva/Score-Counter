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
    @IBOutlet weak var segmentControlteste: UISegmentedControl!
    override func awakeFromNib() {
        super.awakeFromNib()
        configureColors()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureColors() {
        self.backgroundColor = UIColor(hexValue: 0x54A0FF)
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
