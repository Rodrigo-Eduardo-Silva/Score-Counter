import UIKit

class GamesTableViewCell: UITableViewCell {
    static let identifier = String(describing: GamesTableViewCell.self)

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var gameNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func prepareCell(game: NewGame) {
        gameNameLabel.text = game.name
        dateLabel.text = game.date?.formatted(date: .numeric, time: .omitted)
    }

}
