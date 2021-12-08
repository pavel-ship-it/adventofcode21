class Task15: Task {
    func calc(_ inputFile: String) -> Int {
        fileData(inputFile)
            .map {
                $0.components(separatedBy: " | ")[1]
                    .components(separatedBy: " ")
                    .map { $0.count }
            }
            .reduce([Int](), +)
            .filter { $0 == 2 || $0 == 4 || $0 == 3 || $0 == 7 }
            .count
    }
}

class Task16: Task {
    func cont(_ a: [String.Element], _ b: [String.Element]) -> Int {
        b.filter { !a.contains($0) }.count
    }
    func decoder(_ code: [[String.Element]]) -> Int {
        var d = [[String.Element]?](repeating: nil, count: 10)
        d[1] = code.first { $0.count == 2 }
        d[4] = code.first { $0.count == 4 }
        d[7] = code.first { $0.count == 3 }
        d[8] = code.first { $0.count == 7 }
        if let d1 = d[1], let d4 = d[4] {
            d[3] = code.first { $0.count == 5 && cont($0, d1) == 0 }
            d[5] = code.first { $0.count == 5 && cont($0, d1) == 1 && cont($0, d4) == 1 }
            if let d3 = d[3], let d5 = d[5] {
                d[2] = code.first { $0.count == 5 && cont($0, d3) != 0 && cont($0, d5) != 0 }
            }
            d[6] = code.first { $0.count == 6 && cont($0, d1) == 1 && cont($0, d1) != 0 }
        }
        if let d1 = d[1], let d4 = d[4] {
            d[9] = code.first { $0.count == 6 && cont($0, d4) == 0 }
            d[0] = code.first { $0.count == 6 && cont($0, d4) == 1 && cont($0, d1) == 0 }
        }
        return (d.firstIndex(of: code[10])! * 1000 + d.firstIndex(of: code[11])! * 100 + d.firstIndex(of: code[12])! * 10 + d.firstIndex(of: code[13])! * 1) as Int
    }
    
    func calc(_ inputFile: String) -> Int {
        fileData(inputFile)
            .map {
                $0.components(separatedBy: " | ")
                    .map { $0.components(separatedBy: " ") }
                    .reduce([String](), +)
                    .map { $0.sorted() }
            }
            .map { decoder($0) }
            .reduce(0, +)
    }
}