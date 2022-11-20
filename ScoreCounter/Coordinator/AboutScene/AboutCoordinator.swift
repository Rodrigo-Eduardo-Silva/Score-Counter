
import UIKit

class AboutCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    var childCoordinator: Coordinator?
    init(navigationController: UINavigationController){
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController  = showAboutViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
    private func showAboutViewController() -> AboutViewController {
        let viewController = AboutViewController()
        return viewController
    }
    
}
