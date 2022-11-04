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
        viewController.delegate = self
//        mainViewController.addChild(viewController)
//        viewController.view.frame = mainViewController.view.frame
//        mainViewController.view.addSubview(viewController.view)
//        viewController.didMove(toParent: GamesViewController())

        return viewController
    }

}
extension GamesCoordinator: GamesViewControllerDelegate {
    func showScoreViewController(with game: NewGame) {
        let scoreCoordinator = ScoreCoodinator(navigationController: navigationController)
        scoreCoordinator.start()
        childCoordinator = scoreCoordinator
    }
}
