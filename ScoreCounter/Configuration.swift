import UIKit

class Configuration {
    let defauls = UserDefaults.standard
    static var  shared: Configuration = Configuration()
     var soundState: Bool {
        get {
            return defauls.bool(forKey: "soundState")
        }
        set {
            defauls.set(newValue, forKey: "soundState")
        }
    }
    private init() {

    }
}
