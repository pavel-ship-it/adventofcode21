
class Task1: Task {
    func calc(_ inputFile: String) -> Int {
        let input = fileData(inputFile).map { Int($0)! }
        return (1..<input.count).filter { input[$0] > input[$0-1] }.count
    }
}

class Task2: Task {
    func calc(_ inputFile: String) -> Int {
        let input = fileData(inputFile).map { Int($0)! }
        return (2..<input.count-1).filter { input[$0-2] < input[$0+1] }.count
    }
}
