import UIKit
import CoreData

protocol ScoreModelDelegate: AnyObject {
    func updateScore()
    func deleteScore(index: IndexPath)
}

class ScoreModel: NSObject {
    var score: Score!
    var fetchResultScore: NSFetchedResultsController<Score>!
    weak var delegate: ScoreModelDelegate?
    func createScore(player: String, points: Int64,game: NewGame,context: NSManagedObjectContext) {
        self.score = Score(context: context)
        self.score.game = game
        self.score.gameName = game.name
        self.score.player = player
        self.score.points = points
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func loadScore(with context: NSManagedObjectContext, gameName: NewGame) {
        let fetchRequest: NSFetchRequest<Score> = Score.fetchRequest()
        let sortDescritor = NSSortDescriptor(key: "player", ascending: true)

        guard let argPredicate = gameName.name else {
            fatalError()
        }

        let predicate = NSPredicate(format: "gameName == %@", "\(argPredicate)")
        fetchRequest.predicate = predicate
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

extension ScoreModel: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            delegate?.updateScore()
        case .delete:
            if let indexPath = indexPath {
                delegate?.deleteScore(index: indexPath)
            }
        case .move:
            delegate?.updateScore()
        case .update:
            delegate?.updateScore()
           @unknown default:
            print("erro")
        }
    }
}


