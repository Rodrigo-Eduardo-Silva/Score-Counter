

import UIKit
import CoreData
protocol GamesViewControllerDelegate: AnyObject {
    func showScoreViewController(with game: NewGame)
}

class GamesViewController: UIViewController {
    weak var delegate: GamesViewControllerDelegate?
    @IBOutlet weak var tableView: UITableView!
    var model = GamesViewModel()
    var fetchResultController: NSFetchedResultsController<NewGame>!
    var fetchResultControllerScore: NSFetchedResultsController<Score>!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        createBarButtonItem()
        registerCell()
        loadGames()
    }
    
    func createBarButtonItem() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addNewGame))
    }
    
    @objc func addNewGame(){
        let title = "Adicionar Novo Game"
        let message = "Informe o Nome do Jogo"
        
        let altert = UIAlertController(title: title , message: message, preferredStyle: .alert)
        altert.addTextField { textField in
            textField.placeholder = "Ex: Partida de Dama"
        }
        altert.addAction(UIAlertAction(title: title, style: .default, handler: { action in
            if let gameName = altert.textFields?.first?.text {
                let date = Date()
                self.model.createGame(game: gameName, date: date)
            }
        }))
        
        present(altert, animated: true, completion: nil)
        loadGames()
        
    }
    
    func registerCell() {
        let nib = UINib(nibName: GamesTableViewCell.identifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: GamesTableViewCell.identifier)
    }
    
    func loadGames() {
        let fetchRequest: NSFetchRequest<NewGame> = NewGame.fetchRequest()
        let sortDescritor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescritor]
        fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController.delegate = self
        do {
            try fetchResultController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func cascadeDelete(game: NewGame) {
        let deleteName = game.name
        let fetchRequest: NSFetchRequest<Score> = Score.fetchRequest()
        let sortDescritor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescritor]
        fetchResultControllerScore = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultControllerScore.delegate = self
        
        if let deletePlayer = fetchResultControllerScore.fetchedObjects {
            for player in deletePlayer {
                if player.gameName == deleteName {
                    context.delete(player)
                    print(player)
                    do {
                        try context.save()
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
          
        }
    }
}

extension GamesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = fetchResultController.fetchedObjects?.count ?? 0
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

extension GamesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let game = fetchResultController.fetchedObjects?[indexPath.row] else {return}
            context.delete(game)
            cascadeDelete(game: game)
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let game = fetchResultController.fetchedObjects?[indexPath.row] else {
           fatalError()
        }
        delegate?.showScoreViewController(with: game)
    }

}

extension GamesViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.reloadData()
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .move:
            tableView.reloadData()
        case .update:
            tableView.reloadData()
        @unknown default:
            print("erro")
        }
    }
}

extension GamesViewController {
    var context: NSManagedObjectContext {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("No context object found")
        }
        return appDelegate.persistentContainer.viewContext
    }
}
