import UIKit
import Shhwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        Shh(url: "http://localhost:8545").version { (version, error) in
            print("version: \(version), error: \(error)")
        }
    }
}
