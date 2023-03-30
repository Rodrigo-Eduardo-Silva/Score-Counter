import UIKit

class GameCoverCoordinator: Coordinator {
    var navigationController: UINavigationController

    var childCoordinator: Coordinator?
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
//        let viewController = showGameCover()
//        navigationController.show(viewController, sender: nil)
    }

//    private func showGameCover() -> GameCoverViewController {
//        let viewController = GameCoverViewController()
//        return viewController
//    }

}
