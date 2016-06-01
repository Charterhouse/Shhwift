import Foundation

extension NSInputStream {

    func readFully() -> NSData {
        let result = NSMutableData()

        self.open()
        readTo(result)
        self.close()

        return result
    }

    private func readTo(data: NSMutableData) {
        var buffer = [UInt8](count: 4096, repeatedValue: 0)

        var amount = 0
        repeat {
            amount = self.read(&buffer, maxLength: buffer.count)
            if amount > 0 {
                data.appendBytes(buffer, length: amount)
            }
        } while amount > 0
    }
}
