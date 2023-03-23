import UIKit

class Configuration {
    let defauls = UserDefaults.standard
    static var  shared: Configuration = Configuration()
     var soundState: Int {
        get {
            return defauls.integer(forKey: "soundState")
        }
        set {
            defauls.set(newValue, forKey: "soundState")
        }
    }

    private init() {

    }
}
