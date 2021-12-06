
class Task1: Task {
    func calc(_ inputFile: String) -> Int {
        let input = fileData(inputFile).map { Int($0)! }
        var counter = 0
        for i in 1..<input.count {
            if input[i] > input[i-1] {
                counter+=1
            }
        }
        return counter
    }
}

class Task2: Task {
    func calc(_ inputFile: String) -> Int {
        let input = fileData(inputFile).map { Int($0)! }
        var counter = 0
        for i in 2..<input.count-1 {
            if input[i-2] < input[i+1] {
                counter += 1
            }
        }
        return counter
    }
}
