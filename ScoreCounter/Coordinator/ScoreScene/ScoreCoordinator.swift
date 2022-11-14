import UIKit

class ScoreCoodinator: Coordinator {
    var navigationController: UINavigationController
    var game: NewGame
       
    var childCoordinator: Coordinator?
    init(navigationController: UINavigationController, game: NewGame) {
        self.navigationController = navigationController
        self.game = game
    }
    
    func start() {
        let viewController = showScoreViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
    private func showScoreViewController() -> ScoreViewController {
        let viewcontroller = ScoreViewController(game: game)
        let model = ScoreModel()
        viewcontroller.model = model
        return viewcontroller
    }
    
}
