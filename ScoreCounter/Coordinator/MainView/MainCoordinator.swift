import UIKit

class MainCoordinator: Coordinator {

    var navigationController: UINavigationController
    var childCoordinator: Coordinator?
    private var viewController: MainViewController?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let mainViewController = MainViewController()
        mainViewController.delegate = self
        self.viewController = mainViewController
        navigationController.pushViewController(mainViewController, animated: true)
    }
}

extension MainCoordinator: MainViewControllerDelegate {
    func showGamesViewController(view: UIView) {
        let gamesCoordinator = GamesCoordinator(navigationController: navigationController)
        gamesCoordinator.start()
        childCoordinator = gamesCoordinator
    }
}
