import UIKit
import CoreData

class ScoreViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var fetchResultScore: NSFetchedResultsController<SavedScore>!
    var model = ScoreModel()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        createBarButtonItem()
        registerCell()
        loadScore(with: context)
    }
    
    func createBarButtonItem() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add Player", style: .plain, target: self, action: #selector(addNewPlayer))
    }
    
    @objc func addNewPlayer() {
        let title = "Adicionar Novo Player"
        let message = "Informe o Nome do Jogador"
        
        let altert = UIAlertController(title: title , message: message, preferredStyle: .alert)
        altert.addTextField { textField in
            
        }
        altert.addAction(UIAlertAction(title: title, style: .default, handler: { action in
            if let playerName = altert.textFields?.first?.text {
                self.model.createScore(player: playerName, points: 0)
            }
        }))
        
        present(altert, animated: true, completion: nil)
        loadScore(with: context)
    }
    
    func registerCell() {
        let nib = UINib(nibName: ScoreTableViewCell.identifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: ScoreTableViewCell.identifier)
    }
    func loadScore(with context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<SavedScore> = SavedScore.fetchRequest()
        let sortDescritor = NSSortDescriptor(key: "players", ascending: true)
        fetchRequest.sortDescriptors = [sortDescritor]
        fetchResultScore = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultScore.delegate = self
        do {
            try fetchResultScore.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension ScoreViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = fetchResultScore.fetchedObjects?.count ?? 0
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ScoreTableViewCell.identifier, for: indexPath) as? ScoreTableViewCell else {
            fatalError()
        }
        guard let playerScore = fetchResultScore.fetchedObjects?[indexPath.row] else {
            return cell
        }
        cell.prepareCell(with: playerScore)
        return cell
    }

}

extension ScoreViewController: NSFetchedResultsControllerDelegate {
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

extension ScoreViewController {
    var context: NSManagedObjectContext {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("No context object found")
        }
        return appDelegate.persistentContainer.viewContext
    }
}

