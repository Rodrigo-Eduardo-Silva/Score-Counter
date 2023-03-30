import UIKit
import CoreData
// swiftlint:disable line_length
protocol GamesViewControllerDelegate: AnyObject {
    func showScoreViewController(with game: NewGame)
    func showMenuViewController()
}

class GamesViewController: UIViewController {
    weak var delegate: GamesViewControllerDelegate?
    @IBOutlet weak var tableView: UITableView!
    var imageCover: UIImage?

    lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 23)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()

    var model: GamesViewModel?
    var fetchResultController: NSFetchedResultsController<NewGame>! {
        model?.fetchResultController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = "Click in ' + ' to add a new Game"
        tableView.delegate = self
        tableView.dataSource = self
        createBarButtonItem()
        registerCell()
        model?.loadGames(context: context)
        navigationItem.title = "Score Counter"
    }

    func createBarButtonItem() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(addNewGame))

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.dash"),
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(showMenu))

    }

    @objc func showMenu() {
        delegate?.showMenuViewController()
    }

    @objc func addNewGame() {
        let title = "Add New Game"
        let message = "Insert Game Name"

        let altert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        altert.addTextField { textField in
            textField.placeholder = "Ex: Queen game"
        }

        let addGame = UIAlertAction(title: title, style: .default, handler: { _ in
            if let gameName = altert.textFields?.first?.text {
                let date = Date()
                self.model?.createGame(game: gameName, date: date, context: self.context)
            }
        })

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        altert.addAction(addGame)
        altert.addAction(cancelAction)

        present(altert, animated: true, completion: nil)
        model?.loadGames(context: context)

    }

    func registerCell() {
        let nib = UINib(nibName: GamesTableViewCell.identifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: GamesTableViewCell.identifier)
    }

}
// MARK: - Table View Sata Source
extension GamesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        guard let count = fetchResultController.fetchedObjects?.count else {
            fatalError("Erro de contagem")
             }
        tableView.backgroundView = count == 0 ? label : nil
        return count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GamesTableViewCell.identifier, for: indexPath) as? GamesTableViewCell else {
            fatalError()
        }

        guard let game = fetchResultController.fetchedObjects?[indexPath.row] else {
            return cell
        }
        cell.prepareCell(game: game)
        return cell
    }
}
// MARK: - Table View Delegate
extension GamesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let reset = self.resetScore(index: indexPath)
        let delete = self.deleteGame(index: indexPath)
        let swipe = UISwipeActionsConfiguration(actions: [reset, delete])
        return swipe
    }

    private func resetScore(index: IndexPath) -> UIContextualAction {
        let resetAction = UIContextualAction(style: .normal, title: "") { [weak self] (_, _, _) in
            guard let self = self else { return }
            guard let game = self.fetchResultController.fetchedObjects?[index.row] else {
                fatalError()
            }
            guard let gameName = game.name else { return }
            let alert = UIAlertController(title: "Score Counter", message: "Reset all Game Scores", preferredStyle: .actionSheet)

            let resetAction = UIAlertAction(title: "Reset Score of \(String(describing: gameName))", style: .destructive) { [weak self] _ in
                guard let self = self else { return }
                self.model?.resetScorePoint(context: self.context, game: game)
                self.tableView.reloadData()
            }

            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(resetAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }

        resetAction.image = UIImage(systemName: "restart")
        return resetAction
    }

    private func deleteGame(index: IndexPath) -> UIContextualAction {
        let deleteAction = UIContextualAction(style: .destructive, title: "") {  [weak self] (_, _, _) in
            guard let self = self else { return }
            guard let game = self.fetchResultController.fetchedObjects?[index.row] else {
                fatalError()
                 }
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

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let update = self.updateNameGame(index: indexPath)
        let updateCover = self.updateCover(index: indexPath)
        let swipe = UISwipeActionsConfiguration(actions: [update, updateCover])
        return swipe
    }

    private func updateCover(index: IndexPath) -> UIContextualAction {

        let updateCover = UIContextualAction(style: .normal, title: "") { [weak self] (_, _, _) in
            guard let self = self else { return }
            guard let game = self.fetchResultController.fetchedObjects?[index.row] else {
                fatalError()
            }

            let viewController = GameCoverViewController(game: game)
            viewController.delegate = self
            self.present(viewController, animated: true)

        }
        updateCover.backgroundColor = .systemBlue
        updateCover.image = UIImage(systemName: "gear")
        return updateCover
    }

    private func updateNameGame(index: IndexPath) -> UIContextualAction {

        let updateName = UIContextualAction(style: .normal, title: "") { [weak self] (_, _, _) in
            guard let self = self else { return }
            guard let game = self.fetchResultController.fetchedObjects?[index.row] else {
                fatalError()
            }

            let alert = UIAlertController(title: "", message: "Edit Game Name", preferredStyle: .alert)
            alert.addTextField { texField in
                texField.text = game.name
            }

            let saveName = UIAlertAction(title: "OK", style: .default) { _ in
                if let newName = alert.textFields?.first?.text {
                    self.model?.updateGameName(with: newName, game: game)

                    do {
                        try self.context.save()
                    } catch {
                        print(error.localizedDescription)
                    }
                    self.tableView.reloadData()
                }
            }

            alert.addAction(saveName)
            self.present(alert, animated: true)
        }

        updateName.backgroundColor = .blue
        updateName.image = UIImage(systemName: "pencil.line")
        return updateName
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let game = fetchResultController.fetchedObjects?[indexPath.row] else {
           fatalError()
        }
        delegate?.showScoreViewController(with: game)
    }
}
// MARK: - Game Model Delegate
extension GamesViewController: GamesViewModelDelegate {

    func updateGameTableView() {
        tableView.reloadData()
    }

    func deleteGames(index: IndexPath) {
        tableView.deleteRows(at: [index], with: .fade)
    }
 }

extension GamesViewController: GameCoverViewControllerDelegate {
    func sendImage(with image: UIImage, at game: NewGame) {
        imageCover = image
        if let imageCover = self.imageCover {
            self.model?.updateCoverGame(with: imageCover, game: game)
            do {
                try self.context.save()
            } catch {
                print(error.localizedDescription)
            }
            self.tableView.reloadData()
        } else {
            print("não tem uma image")
        }
    }
}
