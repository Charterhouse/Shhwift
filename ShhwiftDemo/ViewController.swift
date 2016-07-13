import UIKit
import Geth
import Shhwift

class ViewController: UIViewController {

    private let shh: Shh = Shh(url: "http://localhost:8545")

    private var id: Identity!
    private var topic: Topic!
    private var filter: Filter!

    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var getChangesButton: UIButton!
    @IBOutlet weak var entryField: UITextField!
    @IBOutlet weak var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.textView.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.textView.layer.borderWidth = 0.5

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
            signal(SIGPIPE, SIG_IGN)
            Geth.run("--shh --rpc --rpcapi shh --ipcdisable")
        }

        self.start()
    }

    func start() {
        dispatch_async(dispatch_get_main_queue()) {
            self.setupWhisper()
        }
    }

    func setupWhisper() {
        shh.version { version, error in
            guard let version = version else {
                print("Version error: \(error). Is Whisper running?")
                let ac = UIAlertController(
                    title: "Whisper error",
                    message: "Please double-check that Whisper is running",
                    preferredStyle: .Alert)
                ac.addAction(UIAlertAction(title: "Retry", style: .Default, handler: { _ in
                    self.start()
                }))
                self.presentViewController(ac, animated: true, completion: nil)
                return
            }
            print("Version: \(version)")
            self.getIdentity()
        }
    }

    func getIdentity() {
        shh.newIdentity() { id, error in
            guard let id = id else {
                print("Failed to get an id")
                return
            }

            self.id = id
            self.topic = Topic(string:"My silly app!")

            self.entryField.enabled = true
            self.postButton.enabled = true

            self.shh.newFilter(topics: [self.topic!]) { filter, error in
                guard let filter = filter else {
                    print("Failed to set filter")
                    return
                }
                self.filter = filter
                self.getChangesButton.enabled = true
            }
        }
    }

    @IBAction func getChanges() {
        shh.getFilterChanges(filter!) { messages, error in
            print("messages \(messages), error: \(error)")
            guard let messages = messages else {
                return
            }
            var content = ""
            for m in messages {
                guard let messageContent = NSString(data: m.payload.asData,
                                                    encoding: NSUTF8StringEncoding) else {
                    print("Failed to decode payload")
                    continue
                }
                if content != "" {
                    content = content + "\n"
                }
                content = content + (messageContent as String)
            }
            self.textView.text = content
        }
    }

    @IBAction func post() {
        guard let text = self.entryField.text else {
            return
        }

        self.entryField.enabled = false

        let payload = Payload(string: text)
        let post = Post(topics: [topic!],
                        payload: payload!,
                        priority: 1000, timeToLive: 100)
        shh.post(post) { ok, error in
            print("post \(ok), error: \(error)")
            self.entryField.enabled = true
            self.entryField.text = ""
        }
    }
}


public extension DataContainer {
    public init?(string: String) {
        self.init("0x" + string.dataUsingEncoding(NSUTF8StringEncoding)!.hexStringRepresentation())
    }
}
