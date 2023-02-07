import UIKit

class GamesCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinator: Coordinator?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewController = showGamesViewController()
        navigationController.pushViewController(viewController, animated: true)
    }

    private func showGamesViewController() -> GamesViewController {
        let viewController = GamesViewController()
        let model = GamesViewModel()
        model.delegate = viewController
        viewController.model = model
        viewController.delegate = self
        return viewController
    }

}

extension GamesCoordinator: GamesViewControllerDelegate {
    func showMenuViewController() {
        let menuCoordinator = AboutCoordinator(navigationController: navigationController)
        menuCoordinator.start()
        childCoordinator = menuCoordinator
    }

    func showScoreViewController(with game: NewGame) {
        let scoreCoordinator = ScoreCoodinator(navigationController: navigationController, game: game)
        scoreCoordinator.start()
        childCoordinator = scoreCoordinator
    }
}
