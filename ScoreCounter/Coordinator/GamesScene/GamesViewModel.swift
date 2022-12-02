import UIKit
import CoreData
import Foundation
// swiftlint:disable line_length

protocol GamesViewModelDelegate: AnyObject {
    func updateGames()
    func deleteGames(index: IndexPath)
}

class GamesViewModel: NSObject {
    weak var delegate: GamesViewModelDelegate?
    var game: NewGame!
    var fetchResultController: NSFetchedResultsController<NewGame>!

    func createGame(game: String, date: Date, context: NSManagedObjectContext) {
        self.game = NewGame(context: context)
        self.game.name = game
        self.game.date = date
        self.game.idGame = UUID().uuidString
        do {
            try context.save()

        } catch {
            print(error.localizedDescription)
        }
     }

    func loadGames(context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<NewGame> = NewGame.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                           managedObjectContext: context,
                                                           sectionNameKeyPath: nil,
                                                           cacheName: nil)
        fetchResultController.delegate = self

        do {
            try fetchResultController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }

    func resetScorePoint(context: NSManagedObjectContext, game: NewGame) {
        guard let gameName = game.name else {
            fatalError("Erro ao resetar Player")
        }
        let predicate = NSPredicate(format: "gameName == %@", "\(gameName)")
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Score")
        request.predicate = predicate
        do {
            guard let players = try context.fetch(request) as? [NSManagedObject]  else { return }
            print(players)
           _ = players.map {$0.setValue(0, forKey: "points")}
            try context.save()
        } catch {
            print(error.localizedDescription)
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
