import UIKit

class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinator: Coordinator?
    let windows: UIWindow
    
    init(windows: UIWindow, navigationController: UINavigationController) {
        self.windows = windows
        self.navigationController = navigationController
    }
    
    func start() {
        windows.frame = UIScreen.main.bounds
        windows.rootViewController = navigationController
        windows.makeKeyAndVisible()
        makeGamesViewController(navigationController: navigationController)
    }
    
    fileprivate func makeGamesViewController(navigationController: UINavigationController) {
        let gamesCoordinator = GamesCoordinator(navigationController: navigationController)
        gamesCoordinator.start()
        childCoordinator = gamesCoordinator
    }
    
    
}

