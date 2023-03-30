import UIKit

class GamesTableViewCell: UITableViewCell {
    static let identifier = String(describing: GamesTableViewCell.self)

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var gameNameLabel: UILabel!
    @IBOutlet weak var imageGame: UIImageView!
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
        imageGame.image = game.coverGame as? UIImage
        imageGame.layer.cornerRadius = imageGame.frame.size.height/2
//        dateLabel.text = game.date?.formatted(date: .numeric, time: .omitted)
    }

}
