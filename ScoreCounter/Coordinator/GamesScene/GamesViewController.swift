import UIKit
import CoreData
import GoogleMobileAds
// swiftlint:disable line_length
protocol GamesViewControllerDelegate: AnyObject {
    func showScoreViewController(with game: NewGame)
    func showMenuViewController()
}

class GamesViewController: UIViewController {
    private let banner: GADBannerView =  {
       let banner = GADBannerView()
        banner.adUnitID = "ca-app-pub-2591443221502536/7083232760"
        banner.load(GADRequest())
        banner.backgroundColor = .secondarySystemBackground
        return banner
    }()
    weak var delegate: GamesViewControllerDelegate?
    @IBOutlet weak var tableView: UITableView!
    var model: GamesViewModel?
    var fetchResultController: NSFetchedResultsController<NewGame>! {
        model?.fetchResultController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        createBarButtonItem()
        registerCell()
        model?.loadGames(context: context)
        banner.rootViewController = self
        view.addSubview(banner)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        banner.frame = CGRect(x: 0, y: view.frame.size.height-50, width: view.frame.size.width, height: 50)
    }

    func createBarButtonItem() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add Game",
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
        let title = "Adicionar Novo Game"
        let message = "Informe o Nome do Jogo"

        let altert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        altert.addTextField { textField in
            textField.placeholder = "Ex: Partida de Dama"
        }

        let addGame = UIAlertAction(title: title, style: .default, handler: { _ in
            if let gameName = altert.textFields?.first?.text {
                let date = Date()
                self.model?.createGame(game: gameName, date: date, context: self.context)
            }
        })

        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)

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
            let alert = UIAlertController(title: "Score Counter", message: "Reinicializar todos os Scores do Game", preferredStyle: .actionSheet)

            let resetAction = UIAlertAction(title: "Reinicializar Score do \(String(describing: gameName))", style: .destructive) { [weak self] _ in
                guard let self = self else { return }
                self.model?.resetScorePoint(context: self.context, game: game)
                self.tableView.reloadData()
            }

            let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let game = fetchResultController.fetchedObjects?[indexPath.row] else {
           fatalError()
        }
        delegate?.showScoreViewController(with: game)
    }
}
// MARK: - Game Model Delegate
extension GamesViewController: GamesViewModelDelegate {

    func updateGames() {
        tableView.reloadData()
    }

    func deleteGames(index: IndexPath) {
        tableView.deleteRows(at: [index], with: .fade)

    }
 }
