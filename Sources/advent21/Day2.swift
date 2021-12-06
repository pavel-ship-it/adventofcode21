class Task3: Task {
    enum Direction: String {
        case forward = "forward"
        case up = "up"
        case down = "down"
        case undef = "*"
        init(fromRawValue: String) {
            self = Direction(rawValue: fromRawValue) ?? .undef
        }
    }
    
    func calc(_ inputFile: String) -> Int {
        let input = fileData(inputFile).map {
            let cps = $0.components(separatedBy: " ")
            return (Direction(fromRawValue: cps[0]), Int(cps[1])!)
        } as [(Direction, Int)]
        var forward = 0
        var deep = 0
        _ = input.reduce(into: 0) { partialResult, dir in
            switch dir.0 {
            case .forward: forward += dir.1
            case .up: deep -= dir.1
            case .down: deep += dir.1
            case .undef:
                fatalError()
            }
        }
        return forward * deep
    }
}

class Task4: Task {
    enum Direction: String {
        case forward = "forward"
        case up = "up"
        case down = "down"
        init(fromRawValue: String) {
            self = Direction(rawValue: fromRawValue) ?? .forward
        }
    }
    
    func calc(_ inputFile: String) -> Int {
        let input = fileData(inputFile).map {
            let cps = $0.components(separatedBy: " ")
            return (Direction(fromRawValue: cps[0]), Int(cps[1])!)
        } as [(Direction, Int)]
        var forward = 0
        var deep = 0
        var aim = 0
        _ = input.reduce(into: 0) { partialResult, dir in
            switch dir.0 {
            case .forward: forward += dir.1; deep += dir.1 * aim
            case .up: aim -= dir.1
            case .down: aim += dir.1
            }
        }
        return forward * deep
    }
}
