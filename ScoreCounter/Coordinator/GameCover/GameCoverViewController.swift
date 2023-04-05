import UIKit
protocol GameCoverViewControllerDelegate: AnyObject {
    func sendImage(with image: UIImage, at game: NewGame)
}

class GameCoverViewController: UIViewController {

    var model: [GameCoverModel]
    var game: NewGame
    weak var delegate: GameCoverViewControllerDelegate?
    @IBOutlet weak var colectionImage: UICollectionView!

    init(game: NewGame, model: [GameCoverModel]) {
        self.game = game
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        colectionImage.dataSource = self
        colectionImage.delegate = self
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
    }

    func registerCell() {
        let nib = UINib(nibName: GameCoverCollectionViewCell.indetifier, bundle: nil)
        colectionImage.register(nib, forCellWithReuseIdentifier: GameCoverCollectionViewCell.indetifier)
    }

}

extension GameCoverViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        model.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
                                                            GameCoverCollectionViewCell.indetifier,
                                                            for: indexPath) as? GameCoverCollectionViewCell else {
            fatalError("foi aquiiiiiiii")
        }
        cell.prepareCell(with: model[indexPath.row].image)
        return cell
    }
}

extension GameCoverViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let image = model[indexPath.row].image
        delegate?.sendImage(with: image, at: game)
    dismiss(animated: true)
    }
}
