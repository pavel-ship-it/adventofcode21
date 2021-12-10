struct Stack<T> {
    var items = [T]()
    mutating func push(_ item: T) {
        items.append(item)
    }
    mutating func pop() -> T {
        return items.removeLast()
    }
    func last() -> T? {
        return items.last
    }
    func count() -> Int {
        return items.count
    }
}
class Task19: Task {
    func evaluate(_ line: String) -> Int {
        let coms = ["]": "[", "}": "{", ">": "<", ")": "("]
        let value = [")": 3,
                     "]": 57,
                     "}": 1197,
                     ">": 25137]
        var stack = Stack<String>()
        for ch in line {
            let ch = String(ch)
            if coms.values.contains(ch) {
                stack.push(ch)
            } else {
                if stack.last() == coms[ch] {
                    _ = stack.pop()
                } else {
                    if stack.last() != nil {
                        return value[ch]!
                    }
                }
            }
        }
        return 0
    }
    func calc(_ inputFile: String) -> Int {
        return fileData(inputFile).reduce(0) { $0 + evaluate($1) }
    }
}
class Task20: Task {
    func evaluate(_ line: String) -> Int {
        let coms = ["]": "[", "}": "{", ">": "<", ")": "("]
        let value = ["(": 1,
                     "[": 2,
                     "{": 3,
                     "<": 4]
        var stack = Stack<String>()
        for ch in line {
            let ch = String(ch)
            if coms.values.contains(ch) {
                stack.push(ch)
            } else {
                if stack.last() == coms[ch] {
                    _ = stack.pop()
                } else {
                    if stack.last() != nil {
                        return 0
                    }
                }
            }
        }
        var sum = 0
        while stack.last() != nil {
            sum = sum * 5 + value[stack.pop()]!
        }
        return sum
    }
    func calc(_ inputFile: String) -> Int {
        let fixes = fileData(inputFile).map { evaluate($0) }.compactMap { $0 != 0 ? $0 : nil }.sorted()
        return fixes[(fixes.count - 1) / 2]
    }
}
