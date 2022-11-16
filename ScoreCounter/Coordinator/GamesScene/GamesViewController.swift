

import UIKit
import CoreData
protocol GamesViewControllerDelegate: AnyObject {
    func showScoreViewController(with game: NewGame)
}

class GamesViewController: UIViewController {
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
    }
    
    func createBarButtonItem() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add Game", style: .plain, target: self, action: #selector(addNewGame))
    }

    @objc func addNewGame(){
        let title = "Adicionar Novo Game"
        let message = "Informe o Nome do Jogo"
        
        let altert = UIAlertController(title: title , message: message, preferredStyle: .alert)
        altert.addTextField { textField in
            textField.placeholder = "Ex: Partida de Dama"
        }
        
        let addGame = UIAlertAction(title: title, style: .default, handler: { action in
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
// MARK: - Table view data source
extension GamesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let count = fetchResultController.fetchedObjects?.count else {
            fatalError("Erro de contagem")
             }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GamesTableViewCell.identifier, for: indexPath) as? GamesTableViewCell else {
            fatalError()
        }
        
        guard let game = fetchResultController.fetchedObjects?[indexPath.row] else {
            return cell
        }
        cell.textLabel?.text = game.name
        cell.detailTextLabel?.text = game.date?.formatted(date: .numeric, time: .omitted)
        return cell
    }
}
// MARK: - Table view delegate
extension GamesViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//
//        guard let game = fetchResultController.fetchedObjects?[indexPath.row] else {return}
//            context.delete(game)
//
//              do {
//                 try context.save()
//            } catch {
//                print(error.localizedDescription)
//            }
//         }
//    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let reset = self.resetScore(index: indexPath)
        let delete = self.deleteGame(index: indexPath)
        let swipe = UISwipeActionsConfiguration(actions: [reset, delete])
        return swipe
    }
    
    private func resetScore(index: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Reset") { [weak self] (_,_,_) in
            guard let self = self else { return }
            self.model?.resetScorePoint(context: self.context)
        }
        return action
    }
    
    private func deleteGame(index: IndexPath) -> UIContextualAction {
        let deleteAction = UIContextualAction(style: .destructive, title: "Deletar"){  [weak self] _, _, _ in
            
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

