import UIKit

enum GameCoverModel: String, CaseIterable {

    case cartas
    case basquete
    case bola8
    case dado
    case dardos
    case soldado
    case tennis
    case chama

    var image: UIImage {
        switch self {
        case .cartas:
            if let image = UIImage(named: GameCoverModel.cartas.rawValue) {
                return image
            }
        case .basquete:
            if let image = UIImage(named: GameCoverModel.basquete.rawValue) {
                return image
            }
        case .bola8:
            if let image = UIImage(named: GameCoverModel.bola8.rawValue) {
                return image
            }
        case .dado:
            if let image = UIImage(named: GameCoverModel.dado.rawValue) {
                return image
            }
        case .dardos:
            if let image = UIImage(named: GameCoverModel.dardos.rawValue) {
                return image
            }
        case .soldado:
            if let image = UIImage(named: GameCoverModel.soldado.rawValue) {
                return image
            }
        case .tennis:
            if let image = UIImage(named: GameCoverModel.tennis.rawValue) {
                return image
            }
        case .chama:
            if let image = UIImage(named: GameCoverModel.chama.rawValue) {
                return image
            }
        }
        return UIImage()
    }

}
