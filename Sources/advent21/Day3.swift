func frequency(_ input: [[Int]]) -> [Int] {
    input.reduce([Int]()) { partialResult, value in
        if partialResult.isEmpty {
            return value
        }
        return (0..<value.count).map { partialResult[$0] + value[$0] }
    }.map { $0 >= input.count/2 ? 1 : 0 }
}

func convert(_ input: [Int]) -> Int {
    var o = 0
    (0..<input.count).forEach { i in
        o += input[i] << i
    }
    return o
}

class Task5: Task {

    func calc(_ inputFile: String) -> Int {
        let bits = fileData(inputFile).map {
            $0.map { Int(String($0))! }
        }
        let frequency = frequency(bits)
        let invertFrerq = frequency.map { $0 == 1 ? 0 : 1 }
        let gamma = convert(frequency.reversed())
        let epsilon = convert(invertFrerq.reversed())
        return gamma * epsilon
    }
}

class Task6: Task {

    func calc(_ inputFile: String) -> Int {
        let bits = fileData(inputFile).map {
            $0.map { Int(String($0))! }
        }

        var oxy = bits
        var filterIndex = 0
        while oxy.count > 1 && filterIndex < oxy[0].count {
            let filter = frequency(oxy)[filterIndex]
            oxy = oxy.filter { row in
                row[filterIndex] == filter
            }
            filterIndex += 1
        }
        let ox = convert(oxy.first!.reversed())

        oxy = bits
        filterIndex = 0
        while oxy.count > 1 && filterIndex < oxy[0].count {
            let filter = frequency(oxy)[filterIndex]
            oxy = oxy.filter { row in
                row[filterIndex] != filter
            }
            filterIndex += 1
        }
        let ox2 = convert(oxy.first!.reversed())
        return Int(ox * ox2)
    }
}
