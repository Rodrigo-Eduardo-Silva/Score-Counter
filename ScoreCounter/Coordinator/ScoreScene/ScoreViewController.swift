import UIKit
import CoreData

class ScoreViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var model: ScoreModel?
    var fetchResultScore: NSFetchedResultsController<Score>! {
        model?.fetchResultScore
    }
    var game: NewGame
    var segmenteControll = UISegmentedControl(items: ["1","+5","+10","+100"])
  
    init(game:NewGame){
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
        teste()
    }
           
    func configureSegmenteControll() {
        segmenteControll.selectedSegmentIndex = 0
        segmenteControll.tintColor = .blue
        segmenteControll.backgroundColor = .blue
        self.navigationItem.titleView = segmenteControll
    }
    func createBarButtonItem() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add Player", style: .plain, target: self, action: #selector(addNewPlayer))
    }
    func teste() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Score")
                do {
                    let itens = try context.fetch(request)
                    if !itens.isEmpty {
                        for item in itens as![NSManagedObject] {
                            if let name = item.value(forKey: "player") {
                                print(name)
                            }
                        }
                    }
                } catch {
        
                }
    }
    
    @objc func addNewPlayer() {
        let title = "Adicionar Novo Player"
        let message = "Informe o Nome do Jogador"
        
        let altert = UIAlertController(title: title , message: message, preferredStyle: .alert)
        altert.addTextField { textField in
            
        }
        let addPlayer = UIAlertAction(title: title, style: .default, handler: {  [weak self] action in
            guard let self = self else { return }
            
            if let playerName = altert.textFields?.first?.text {
                self.model?.createScore(player: playerName, points: 0, game: self.game,context: self.context)
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

extension ScoreViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard  let count = fetchResultScore.fetchedObjects?.count else {
            fatalError("Erro de contagem")
        }
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
        var plusSegment = 0
        let segmenteControllIndex = segmenteControll.selectedSegmentIndex
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
        guard let game = fetchResultScore.fetchedObjects?[index] else { return }
        var subtractSegment = 0
        let segmenteControllIndex = segmenteControll.selectedSegmentIndex
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

