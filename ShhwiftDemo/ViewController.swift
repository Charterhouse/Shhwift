import UIKit
import Shhwift

class ViewController: UIViewController {

    private var whisperSenderReceiver: WhisperSenderReceiver!


    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var getChangesButton: UIButton!
    @IBOutlet weak var entryField: UITextField!
    @IBOutlet weak var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.textView.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.textView.layer.borderWidth = 0.5

        whisperSenderReceiver = WhisperSenderReceiver()
        whisperSenderReceiver.onSetupFailed = setupFailed
        whisperSenderReceiver.onReadyForSending = readyForSending
        whisperSenderReceiver.onReadyForReceiving = readyForReceiving
        whisperSenderReceiver.onReceiveMessage = receiveMessage
        whisperSenderReceiver.start()
        whisperSenderReceiver.sendTestMessages()
    }


    @IBAction func getChanges() {
        self.textView.text = ""
        whisperSenderReceiver.getChanges()
    }

    @IBAction func post() {
        guard let text = self.entryField.text else {
            return
        }

        self.entryField.enabled = false
        whisperSenderReceiver.post(text) { _, _ in
            self.entryField.enabled = true
            self.entryField.text = ""
        }
    }

    func setupFailed() {
        let ac = UIAlertController(
            title: "Whisper error",
            message: "Please double-check that Whisper is running",
            preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "Retry", style: .Default, handler: { _ in
            self.whisperSenderReceiver.start()
        }))
        self.presentViewController(ac, animated: true, completion: nil)
    }

    func readyForSending() {
        self.entryField.enabled = true
        self.postButton.enabled = true
    }

    func readyForReceiving() {
        self.getChangesButton.enabled = true
    }

    func receiveMessage(message: Message, content: NSString) {
        var text = self.textView.text
        if text != "" {
            text = text + "\n"
        }
        text = text + (content as String)
        self.textView.text = text
    }
}
