//  Copyright © 2016 Shhwift. All rights reserved.

import Foundation
import Shhwift

class WhisperSenderReceiver {

    var onSetupFailed: (Void -> Void)? = nil
    var onReadyForSending: (Void -> Void)? = nil
    var onReadyForReceiving: (Void -> Void)? = nil
    var onReceiveMessage: ((Message, content: NSString) -> Void)? = nil

    private let shh: Shh = Shh(url: "http://localhost:8545")

    private var id: Identity!
    private var topic: Topic!
    private var filter: Filter!

    private var receivedMessages = [Int:(sentOn:NSDate, receivedOn:NSDate)]()

    func start() {
        dispatch_async(dispatch_get_main_queue()) {
            self.setupWhisper()
        }
    }

    func setupWhisper() {
        shh.version { version, error in
            guard let version = version else {
                print("Version error: \(error). Is Whisper running?")
                self.onSetupFailed?()
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

            self.onReadyForSending?()

            self.shh.newFilter(topics: [self.topic!]) { filter, error in
                guard let filter = filter else {
                    print("Failed to set filter")
                    return
                }
                self.filter = filter
                self.onReadyForReceiving?()
            }
        }
    }

    func getChanges() {
        shh.getFilterChanges(filter!) { messages, error in
            print("messages \(messages), error: \(error)")
            guard let messages = messages else {
                return
            }
            for m in messages {
                guard let messageContent = NSString(data: m.payload.asData,
                                                    encoding: NSUTF8StringEncoding) else {
                                                        print("Failed to decode payload")
                                                        return
                }
                self.onReceiveMessage?(m, content: messageContent)
                self.receivedTestMessage(messageContent)
            }
        }
    }

    func post(text: String, completion: Shh.PostCallback) {
        let payload = Payload(string: text)
        let post = Post(topics: [topic!],
                        payload: payload!,
                        priority: 1000, timeToLive: 10*60)
        shh.post(post) { ok, error in
            print("post \(ok), error: \(error)")
            completion(success: ok, error:error)
        }
    }

    static var counter = 0

    let dateFormatter: NSDateFormatter = {
        var df = NSDateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return df
    }()

    func sendTestMessages() {

        if let topic = topic {

            let now = dateFormatter.stringFromDate(NSDate())
            let post = Post(
                topics: [topic],
                payload: Payload(string: "Test \(WhisperSenderReceiver.counter) \(now)")!,
                priority: 1000,
                timeToLive: 10*60
            )

            WhisperSenderReceiver.counter += 1

            shh.post(post) { ok, error in
                print("test post \(ok), error: \(error)")
            }

        }

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(10 * Double(NSEC_PER_SEC))),
                       dispatch_get_main_queue()) {
                        self.sendTestMessages()
        }
    }

    func receivedTestMessage(content: NSString) {
        let rangeOfTest = content.rangeOfString("Test ")
        guard rangeOfTest.location == 0 else {
            print("Received some other message: \(content)")
            return
        }

        let comps = content.componentsSeparatedByString(" ")
        guard comps.count == 4 else {
            print("Unexpected number of components")
            return
        }

        let counter = (comps[1] as NSString).integerValue
        let dateString = comps[2] + " " + comps[3]
        guard let date = dateFormatter.dateFromString(dateString) else {
            print("Could not parse date")
            return
        }
        guard receivedMessages[counter] == nil else {
            print("Duplicate message received: \(content)")
            return
        }
        receivedMessages[counter] = (date, NSDate())
    }

}

public extension DataContainer {
    public init?(string: String) {
        self.init("0x" + string.dataUsingEncoding(NSUTF8StringEncoding)!.hexStringRepresentation())
    }
}
