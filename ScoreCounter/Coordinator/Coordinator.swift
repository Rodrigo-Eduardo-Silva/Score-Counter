import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get }
    var childCoordinator: Coordinator? { get }
    func start()
}
