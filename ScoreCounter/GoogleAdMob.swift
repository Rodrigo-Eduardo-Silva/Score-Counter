import UIKit
import GoogleMobileAds

class GoogleAdMob {

    let banner: GADBannerView =  {
        let banner = GADBannerView()
        banner.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        banner.load(GADRequest())
        banner.backgroundColor = .secondarySystemBackground
        return banner
    }()
        func bannerPosition(mainView: UIView) -> CGRect {
            let position: CGRect = CGRect(x: 0, y: mainView.frame.size.height-50, width: mainView.frame.size.width, height: 50)
            return position
        }
}
