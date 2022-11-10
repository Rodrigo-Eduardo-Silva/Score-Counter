import UIKit
import CoreData

class ScoreViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var fetchResultScore: NSFetchedResultsController<Score>!
    var model = ScoreModel()
    var game: NewGame
    
    init(game:NewGame){
        self.game = game
        super.init(nibName: nil, bundle: nil)
     }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        createBarButtonItem()
        registerCell()
        loadScore(with: context)
        test()
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
                self.model.createScore(player: playerName, points: 0, game: self.game)
            }
        }))
        
        present(altert, animated: true, completion: nil)
        loadScore(with: context)
    }
    
    func test () {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Score")
               do {
                   let itens = try context.fetch(request)
                   if !itens.isEmpty {
                       for item in itens as![NSManagedObject] {
                           if let name = item.value(forKey: "gameName") {
                               print(name)
                           }
                       }
                   }
               } catch {
       
               }
    }
    
    func loadScore(with context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<Score> = Score.fetchRequest()
        let sortDescritor = NSSortDescriptor(key: "player", ascending: true)

        guard let argPredicate = game.name else {
            fatalError()
        }

//        let predicate = NSPredicate(format: "gameName == %@", "\(argPredicate)")
//        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [sortDescritor]
        fetchResultScore = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultScore.delegate = self

        do {
            try fetchResultScore.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func registerCell() {
        let nib = UINib(nibName: ScoreTableViewCell.identifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: ScoreTableViewCell.identifier)
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
        cell.prepareCell(with: playerScore, at: indexPath.row)
        cell.delegate = self
        return cell
    }
}

extension ScoreViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let game = fetchResultScore.fetchedObjects?[indexPath.row] else {return}
            context.delete(game)
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

extension ScoreViewController: ScoreTableViewCellDelegate {
    func plusPoint(index: Int) {
        guard let game = fetchResultScore.fetchedObjects?[index] else { return }
        let points = game.points
        game.setValue(points + 1, forKey: "points")
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }

    }
    
    func subtractPoint(index: Int) {
        guard let game = fetchResultScore.fetchedObjects?[index] else { return }
        let points = game.points
        game.setValue(points - 1, forKey: "points")
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
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

