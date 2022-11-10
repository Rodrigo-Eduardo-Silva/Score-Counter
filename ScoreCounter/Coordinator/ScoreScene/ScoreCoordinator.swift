import UIKit

class ScoreCoodinator: Coordinator {
    var navigationController: UINavigationController
    var game: Score
       
    var childCoordinator: Coordinator?
    init(navigationController: UINavigationController, game: Score) {
        self.navigationController = navigationController
        self.game = game
    }
    
    func start() {
        let viewController = showScoreViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
    private func showScoreViewController() -> ScoreViewController {
        let viewcontroller = ScoreViewController(game: game)
        
        return viewcontroller
    }
    
}
