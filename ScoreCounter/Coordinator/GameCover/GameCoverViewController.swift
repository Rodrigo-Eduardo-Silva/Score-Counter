import UIKit
protocol GameCoverViewControllerDelegate: AnyObject {
    func sendImage(with image: UIImage, at game: NewGame)
}

class GameCoverViewController: UIViewController {

    let image1 = UIImage(named: "Baralho")
    let image2 = UIImage(named: "Chess ")
    let image3 = UIImage(named: "Baralho")
    let image4 = UIImage(named: "Baralho")
    let image5 = UIImage(named: "Baralho")
    var datateste: [UIImage] = []
    var game: NewGame
    weak var delegate: GameCoverViewControllerDelegate?
    @IBOutlet weak var colectionImage: UICollectionView!

    init(game: NewGame) {
        self.game = game
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        datateste.append(image1!)
        datateste.append(image2!)
        datateste.append(image3!)
        datateste.append(image4!)
        datateste.append(image5!)
        registerCell()
        colectionImage.dataSource = self
        colectionImage.delegate = self
    }

    func registerCell() {
        let nib = UINib(nibName: GameCoverCollectionViewCell.indetifier, bundle: nil)
        colectionImage.register(nib, forCellWithReuseIdentifier: GameCoverCollectionViewCell.indetifier)
    }

}
extension GameCoverViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        datateste.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
                                                            GameCoverCollectionViewCell.indetifier,
                                                            for: indexPath) as? GameCoverCollectionViewCell else {
            fatalError("foi aquiiiiiiii")
        }
        cell.prepareCell(with: datateste[indexPath.row])
        return cell
    }
}

extension GameCoverViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let image = datateste[indexPath.row]
        delegate?.sendImage(with: image, at: game)
    dismiss(animated: true)
    }

}
