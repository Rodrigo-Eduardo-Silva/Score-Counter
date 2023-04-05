import UIKit
extension UIColor {
    convenience init (redInt: UInt8, greenInt: UInt8, blueInt: UInt8, alphaInt: UInt8) {
        let red = CGFloat(redInt) / 255.0
        let green = CGFloat(greenInt) / 255.0
        let blue = CGFloat(blueInt) / 255.0
        let alpha = CGFloat(alphaInt) / 255.0
    
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    convenience init (hexValue: UInt) {
        let red = (hexValue & 0xFF0000) >> 16
        let green = (hexValue & 0x00FF00) >> 8
        let blue = (hexValue & 0x0000FF)
        self.init(redInt: UInt8(red), greenInt: UInt8(green), blueInt: UInt8(blue), alphaInt: 255)
    }
}
