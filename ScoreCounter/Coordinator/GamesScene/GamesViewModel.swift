import UIKit
import CoreData
import Foundation

protocol GamesViewModelDelegate: AnyObject {
    func updateGames()
    func deleteGames(index: IndexPath)
}

class GamesViewModel: NSObject {
    weak var delegate: GamesViewModelDelegate?
    var game: NewGame!
    var fetchResultController: NSFetchedResultsController<NewGame>!
    
    func createGame(game: String,date: Date,context: NSManagedObjectContext) {
        self.game = NewGame(context: context)
        self.game.name = game
        self.game.date = date
        do {
            try context.save()
            
        } catch {
            print(error.localizedDescription)
        }
     }
    
    func loadGames(context: NSManagedObjectContext) {
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
    
    func resetScorePoint(context: NSManagedObjectContext) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Score")
        do {
             let players = try context.fetch(request)
                if !players.isEmpty {
                    for player in players as! [NSManagedObject] {
                        player.setValue(0, forKey: "points")
                    }
                }
        } catch {
            
        }
    }
}

extension GamesViewModel: NSFetchedResultsControllerDelegate {

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            delegate?.updateGames()
        case .delete:
            if let indexPath = indexPath {
                delegate?.deleteGames(index: indexPath)
            }
        case .move:
            delegate?.updateGames()
        case .update:
            delegate?.updateGames()
        @unknown default:
            print("erro")
        }
    }
}

