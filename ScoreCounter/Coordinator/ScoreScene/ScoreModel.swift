import UIKit
import CoreData
class ScoreModel {
    var score: SavedScore!
    func createScore(player: String, points: Int16) {
        self.score = SavedScore(context: context)
        self.score.players = player
        self.score.points = points
        
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

