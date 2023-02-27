import UIKit
import CoreData
import AVFoundation
// swiftlint:disable line_length

class ScoreViewController: UIViewController {
    let googleAdMob = GoogleAdMob()

    @IBOutlet weak var tableView: UITableView!
    var model: ScoreModel?
    var fetchResultScore: NSFetchedResultsController<Score>! {
        model?.fetchResultScore
    }
    var game: NewGame
    var segmentedControl = UISegmentedControl(items: ["+1", "+5", "+10", "+100"])
    var scoreSound = AVAudioPlayer()
    var soundState = Configuration.shared.soundState

    init(game: NewGame) {
        self.game = game
        super.init(nibName: nil, bundle: nil)
     }

    deinit {
        print("ScoreView Destruída")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        model?.delegate = self
        createBarButtonItem()
        registerCell()
        model?.loadScore(with: context, gameName: game)
        configureSegmenteControll()
        navigationItem.title = game.name
        let banner = googleAdMob.banner
        banner.rootViewController = self
        view.addSubview(banner)

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let banner = googleAdMob.banner
        banner.frame = googleAdMob.bannerPosition(mainView: view)
    }

    func configureSegmenteControll() {
        let font = UIFont.systemFont(ofSize: 25)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.tintColor = .blue
        segmentedControl.backgroundColor = .blue
        segmentedControl.selectedSegmentTintColor = .systemBlue
        segmentedControl.frame.size.height = 44
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .normal)
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .selected)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
    }

    func playSound() {
        guard let path = Bundle.main.path(forResource: "score", ofType: "mp3") else { return }
        let url = URL(fileURLWithPath: path)
        do {
        scoreSound = try AVAudioPlayer(contentsOf: url)
        } catch {
            print(error.localizedDescription)
        }
        scoreSound.prepareToPlay()
        scoreSound.play()
    }

    func createBarButtonItem() {
    let addPlayeButton = UIBarButtonItem(title: "Add Player",
                                         style: .plain,
                                         target: self,
                                         action: #selector(addNewPlayer))

    let showSegmentIncrement = UIBarButtonItem(image: UIImage(systemName: "arrowtriangle.left.and.line.vertical.and.arrowtriangle.right"),
                                               style: .plain,
                                               target: self,
                                               action: #selector(showIncrement))
        navigationItem.rightBarButtonItems = [addPlayeButton, showSegmentIncrement]
    }

    @objc func showIncrement() {
        if tableView.tableHeaderView == nil {
            tableView.tableHeaderView = segmentedControl
        } else {
            tableView.tableHeaderView = nil
        }
    }

    @objc func addNewPlayer() {
        let title = "Adicionar Novo Player"
        let message = "Informe o Nome do Jogador"

        let altert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        altert.addTextField { textField in
            textField.placeholder = " Nome do Jogador"
        }
        let addPlayer = UIAlertAction(title: title, style: .default, handler: {  [weak self] _ in
            guard let self = self else { return }

            if let playerName = altert.textFields?.first?.text {
                self.model?.createScore(player: playerName, points: 0, game: self.game, context: self.context)
            }
        })

        let cancelAction =  UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)

        altert.addAction(addPlayer)
        altert.addAction(cancelAction)
        present(altert, animated: true, completion: nil)
        model?.loadScore(with: context, gameName: game)
    }

    func registerCell() {
        let nib = UINib(nibName: ScoreTableViewCell.identifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: ScoreTableViewCell.identifier)
    }
}
// MARK: - Table View Data Source
extension ScoreViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard  let count = fetchResultScore.fetchedObjects?.count else {
            fatalError("Erro de contagem")
        }
        return count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ScoreTableViewCell.identifier, for: indexPath) as? ScoreTableViewCell else {
            fatalError()
        }
        guard let playerScore = fetchResultScore.fetchedObjects?[indexPath.row] else {
            return cell
        }
        cell.prepareCell(with: playerScore, at: indexPath.row)
        cell.delegate = self
        return cell
    }
}
// MARK: - Table view delegate
extension ScoreViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let reset = self.resetScorePlayer(index: indexPath)
        let delete = self.deleteGame(index: indexPath)
        let swipe = UISwipeActionsConfiguration(actions: [reset, delete])
        return swipe
    }

    private func resetScorePlayer(index: IndexPath) -> UIContextualAction {
        let resetAction = UIContextualAction(style: .normal, title: "") { [weak self] (_, _, _) in
            guard let self = self else { return }
            guard let player = self.fetchResultScore.fetchedObjects?[index.row] else { return }
            player.setValue( 0, forKey: "points")
        }
        resetAction.image = UIImage(systemName: "restart")
        return resetAction
    }

    private func deleteGame(index: IndexPath) -> UIContextualAction {
        let deleteAction = UIContextualAction(style: .destructive, title: "") {  [weak self] (_, _, _) in
            guard let self = self else { return }
            guard let game = self.fetchResultScore.fetchedObjects?[index.row] else { return }
            self.context.delete(game)

                  do {
                      try self.context.save()
                } catch {
                    print(error.localizedDescription)
                }
        }
        deleteAction.backgroundColor = .blue
        deleteAction.image = UIImage(systemName: "trash")
        return deleteAction
    }

}

extension ScoreViewController: ScoreTableViewCellDelegate {
    func plusPoint(index: Int) {

        if soundState {
            self.playSound()
        }

        guard let game = fetchResultScore.fetchedObjects?[index] else { return }
        var plusSegment = 0
        let segmenteControllIndex = segmentedControl.selectedSegmentIndex
            if segmenteControllIndex == 0 {
                plusSegment = 1
            }
            if segmenteControllIndex == 1 {
                plusSegment = 5
            }
            if segmenteControllIndex == 2 {
                plusSegment = 10
            }
            if segmenteControllIndex == 3 {
                plusSegment = 100
            }
        let points = game.points
        game.setValue(Int(points) + plusSegment, forKey: "points")

        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
}

    func subtractPoint(index: Int) {
        if soundState {
            self.playSound()
        }

        guard let game = fetchResultScore.fetchedObjects?[index] else { return }
        var subtractSegment = 0
        let segmenteControllIndex = segmentedControl.selectedSegmentIndex
            if segmenteControllIndex == 0 {
                subtractSegment = 1
            }
            if segmenteControllIndex == 1 {
                subtractSegment = 5
            }
            if segmenteControllIndex == 2 {
                subtractSegment = 10
            }
            if segmenteControllIndex == 3 {
                subtractSegment = 100
            }
        let points = game.points
        game.setValue(Int(points) - subtractSegment, forKey: "points")

        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension ScoreViewController: ScoreModelDelegate {
    func updateScore() {
        tableView.reloadData()
    }

    func deleteScore(index: IndexPath) {
        tableView.deleteRows(at: [index], with: .fade)
    }
}
