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
        let viewController = ScoreViewController(game: game)
        let model = ScoreModel()
        viewController.model = model
        return viewController
    }

}
