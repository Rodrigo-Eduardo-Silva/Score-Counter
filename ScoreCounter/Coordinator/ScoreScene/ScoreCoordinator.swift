import UIKit

class ScoreCoodinator: Coordinator {
    var navigationController: UINavigationController
       
    var childCoordinator: Coordinator?
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = showScoreViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
    private func showScoreViewController() -> ScoreViewController {
        let viewcontroller = ScoreViewController()
        
        return viewcontroller
    }
    
}
