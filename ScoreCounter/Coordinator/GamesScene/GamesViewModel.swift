import UIKit
import CoreData
import Foundation

class GamesViewModel {
    var game: Score!
    func createGame(game: String,date: Date) {
        self.game = Score(context: context)
        self.game.nameGame = game
        self.game.date = date
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        
    }
}

extension GamesViewModel {
    var context: NSManagedObjectContext {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("No context object found")
         }
        return appDelegate.persistentContainer.viewContext
    }
}

