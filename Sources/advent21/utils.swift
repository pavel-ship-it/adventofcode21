import Foundation

extension TimeInterval {
    init?(dispatchTimeInterval: DispatchTimeInterval) {
        switch dispatchTimeInterval {
        case .seconds(let value):
            self = Double(value)
        case .milliseconds(let value):
            self = Double(value) / 1_000
        case .microseconds(let value):
            self = Double(value) / 1_000_000
        case .nanoseconds(let value):
            self = Double(value) / 1_000_000_000
        case .never:
            return nil
        @unknown default:
            fatalError()
        }
    }
}

protocol Task {
    func run(_ inputFile: String)
    func calc(_ inputFile: String) -> Int
}

var total: TimeInterval = 0

extension Task {
    func run(_ inputFile: String) {
        let start: DispatchTime = .now()
        let result = calc(inputFile)
        let duration = start.distance(to: .now())
        out(result, TimeInterval(dispatchTimeInterval: duration)!)
    }
    
    func fileData(_ inputFile:String) -> [String] {
        let file = Bundle.module.path(forResource: "Input/\(inputFile)", ofType: "txt")!
        return try! String(contentsOfFile: file).components(separatedBy: CharacterSet.newlines).compactMap { $0.isEmpty ? nil : $0 }
    }
    
    func out(_ result: Int, _ duration: TimeInterval) {
        total += duration
        print(String(format:"%@ - result '%lu' in %.3f sec", String(describing: Self.self), result, duration))
    }
}
