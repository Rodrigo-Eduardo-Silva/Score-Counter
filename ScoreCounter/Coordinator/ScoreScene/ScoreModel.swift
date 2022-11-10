import UIKit
import CoreData
protocol ScoreModelDelegate: AnyObject {
    func updateTableView()
}
class ScoreModel {
    var score: Score!
    
    var fetchResultScore: NSFetchedResultsController<Score>!
    func createScore(player: String, points: Int64, game: Score) {
        self.score = Score(context: context)
        self.score.nameGame = game.nameGame
        self.score.player = player
        self.score.points = points
           print(game)
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension ScoreModel {
    var context: NSManagedObjectContext {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("No context object found")
         }
        return appDelegate.persistentContainer.viewContext
    }
}

