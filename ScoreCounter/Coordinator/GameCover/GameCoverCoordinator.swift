import UIKit

class GameCoverCoordinator: Coordinator {
    var navigationController: UINavigationController
    var game: NewGame
    var model: [GameCoverModel]

    var childCoordinator: Coordinator?
    init(navigationController: UINavigationController, game: NewGame, model: [GameCoverModel]) {
        self.navigationController = navigationController
        self.game = game
        self.model = model
    }

    func start() {
        let viewController = showGameCover()
        navigationController.popToViewController(viewController, animated: true)
    }

    private func showGameCover() -> GameCoverViewController {
        let viewController = GameCoverViewController(game: game, model: model)
        viewController.delegate = self
        return viewController
    }
}

extension GameCoverCoordinator: GameCoverViewControllerDelegate {
    func sendImage(with image: UIImage, at game: NewGame) {
        showUpdateCoverGamesViewController(navigationController: navigationController, game: game, image: image)
    }

    func showUpdateCoverGamesViewController(navigationController: UINavigationController,
                                            game: NewGame,
                                            image: UIImage) {
        let gamesCoordinator = GamesCoordinator(navigationController: navigationController)
        gamesCoordinator.start()

    }

}
