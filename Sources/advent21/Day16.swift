class Task31: Task {
    func load(_ inputFile: String) -> String {
        let hex = fileData(inputFile)[0]
        var bin = ""
        for i in Array(hex) {
            let a = String(Int(String(i), radix: 16)!, radix: 2)
            let b = a.pad(with: "0", toLength: 4)
            bin += b
        }
        return bin
    }
    func calc(_ inputFile: String) -> Int {
        var position = 0
        let packets = parse(load(inputFile), &position)
        return packets.versionSum
    }
    func parse(_ bin: String, _ i: inout Int) -> Packet {
        var container: Packet!
        let version = bin.sub(&i, 3).binaryToDecimal
        let type = bin.sub(&i, 3).binaryToDecimal
        switch type {
        case 4: // literal
            var flag = 0
            var binValue = ""
            repeat {
                flag = bin.sub(&i, 1).binaryToDecimal
                binValue += bin.sub(&i, 4)
            } while flag != 0
            container = Literal(version: version, value: binValue.binaryToDecimal)
        default: // operator
            let lenType = bin.sub(&i, 1).binaryToDecimal
            var packets = [Packet]()
            switch lenType {
            case 0:
                let subPacksLen = bin.sub(&i, 15).binaryToDecimal
                let from = i
                while i < from + subPacksLen {
                    packets.append(parse(bin, &i))
                }
            case 1:
                let lenBin = bin.sub(&i, 11)
                let subPacketsNumber = lenBin.binaryToDecimal
                (0..<subPacketsNumber).forEach { _ in
                    packets.append(parse(bin, &i))
                }
            default:
                fatalError()
            }
            container = Operator(version: version, type: type, packets: packets)
        }
        return container
    }
}
class Task32: Task31 {
    override func calc(_ inputFile: String) -> Int {
        var position = 0
        let packets = parse(load(inputFile), &position)
        return packets.value
    }
}
protocol Packet {
    var versionSum: Int { get }
    var value: Int { get }
}
struct Literal: Packet {
    var version: Int
    var value: Int
    var versionSum: Int { get { version } }
}
struct Operator: Packet {
    var version: Int
    var type: Int
    var packets: [Packet]
    var value: Int {
        get {
            switch type {
            case 0: return packets.reduce(0) { $0+$1.value } // sum
            case 1: return packets.reduce(1) { $0*$1.value } // mul
            case 2: return packets.map { $0.value }.min()! // min
            case 3: return packets.map { $0.value }.max()! // max
            case 5: assert(packets.count == 2); return packets[0].value > packets[1].value ? 1 : 0 // gt
            case 6: assert(packets.count == 2); return packets[0].value < packets[1].value ? 1 : 0 // lt
            case 7: assert(packets.count == 2); return packets[0].value == packets[1].value ? 1 : 0 // eq
            default: fatalError()
            }
        }
    }
    var versionSum: Int { get { version + packets.reduce(0) { $0 + $1.versionSum } } }
}
extension String {
    func sub(_ from: inout Int, _ len: Int) -> String {
        let start = self.index(self.startIndex, offsetBy: from)
        let end = self.index(self.startIndex, offsetBy: from + len, limitedBy: self.endIndex) ?? self.endIndex
        let range = start..<end
        from += len
        return String(self[range])
    }
    var binaryToDecimal: Int { Int(self, radix: 2) ?? 0 }
    public func pad(with padding: Character, toLength length: Int) -> String {
        let paddingWidth = length - self.count
        guard 0 < paddingWidth else { return self }
        return String(repeating: padding, count: paddingWidth) + self
    }
}
