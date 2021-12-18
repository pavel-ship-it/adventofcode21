let deepMax = 4
protocol SnailNumber {
    var explodingDeep: Int { get }
    var isReducible: Bool { get }
    func magnitude() -> Int
    func split() -> (Bool, SnailNumber)
    func explode(_ deep: Int) -> (Int?, SnailNumber, Int?)
}
extension SnailNumber {
    func reduce() -> SnailNumber {
        var out: SnailNumber = self
        while out.explodingDeep > deepMax || out.isReducible {
            if out.explodingDeep > deepMax {
                (_, out, _) = out.explode(1)
            } else if out.isReducible {
                (_, out) = out.split()
            }
        }
        return out
    }
}
let snailNull: SnailNumber = [Int.max, Int.max]
extension Int: SnailNumber {
    func magnitude() -> Int { self }
    var explodingDeep: Int { 0 }
    var isReducible: Bool { self >= 10 }
    func split() -> (Bool, SnailNumber) {
        if self >= 10 {
            return (true, [self/2, self-self/2])
        }
        return (false, self)
    }
    func explode(_ deep: Int = 1) -> (Int?, SnailNumber, Int?) { (nil, self, nil) }
}
extension Array : SnailNumber where Element == SnailNumber {
    func magnitude() -> Int {
        return self[0].magnitude() * 3 + self[1].magnitude() * 2
    }
    var explodingDeep: Int { self.map { $0.explodingDeep + 1 }.max()! }
    var isReducible: Bool { self[0].isReducible || self[1].isReducible }
    func split() -> (Bool, SnailNumber) {
        var (isSplit, split) = self[0].split()
        if isSplit {
            return (true, [split, self[1]])
        }
        (isSplit, split) = self[1].split()
        if isSplit {
            return (true, [self[0], split])
        }
        return (false, self)
    }
    func explode(_ deep: Int = 1) -> (Int?, SnailNumber, Int?) {
        while explodingDeep + deep - 1 > deepMax {
            if let l = self[0] as? Int,
               let r = self[1] as? Int,
               deep > deepMax {
                return (l, 0, r)
            }
            if self[0] is Array<SnailNumber> {
                let (l, out, r) = self[0].explode(deep+1)
                if let r = r {
                    return (l, [out, concat(r, self[1])], nil)
                }
                if let l = l {
                    return (l, [out, self[1]], nil)
                }
                if self[0] != out {
                    return (nil, [out, self[1]], nil)
                }
            }
            if self[1] is Array<SnailNumber> {
                let (l, out, r) = self[1].explode(deep+1)
                if let l = l {
                    return (nil, [concat(self[0], l), out], r)
                }
                if let r = r {
                    return (nil, [self[0], out], r)
                }
                if self[1] != out {
                    return (nil, [self[0], out], nil)
                }
            }
        }
        return (nil, self, nil)
    }
}
func concat(_ left: SnailNumber, _ right: SnailNumber) -> SnailNumber {
    if left == snailNull || right == snailNull {
        if left == snailNull && right != snailNull {
            return right
        } else if left != snailNull && right == snailNull {
            return left
        }
        return snailNull
    } else if left is Array<SnailNumber>,
       right is Array<SnailNumber> {
        return [left, right]
    } else if left is Int, let right = right as? Array<SnailNumber> {
        return [concat(left, right[0]), right[1]]
    } else if let left = left as? Array<SnailNumber>, right is Int {
        return [left[0], concat(left[1], right)]
    } else if let left = left as? Int, let right = right as? Int {
        return Int(left + right)
    }
    fatalError()
}
func +(_ left: SnailNumber, _ right: SnailNumber) -> SnailNumber {
    return concat(left, right).reduce()
}
func != (lhs: SnailNumber, rhs: SnailNumber) -> Bool {
    !(lhs == rhs)
}
func == (lhs: SnailNumber, rhs: SnailNumber) -> Bool {
    if let lhs = lhs as? Array<SnailNumber>,
       let rhs = rhs as? Array<SnailNumber> {
        return lhs[0] == rhs[0] && lhs[1] == rhs[1]
    } else if let lhs = lhs as? Int, let rhs = rhs as? Int {
        return lhs == rhs
    }
    return false
}
class Task34: Task {
    func calc(_ inputFile: String) -> Int {
        let numbers: [SnailNumber] = fileData(inputFile).map {
            var i = 0
            return snail($0, &i)
        }
        let out: SnailNumber = numbers.reduce(snailNull, +)
        return out.magnitude()
    }
    func snail(_ ch: String, _ i: inout Int) -> SnailNumber {
        let next = ch.sub(&i, 1)
        if next == "[" {
            let left = snail(ch, &i)
            i+=1
            let right = snail(ch, &i)
            i+=1
            return [left, right]
        } else {
            return Int(next)!
        }
    }
}
class Task35: Task34 {
    override func calc(_ inputFile: String) -> Int {
        let numbers: [SnailNumber] = fileData(inputFile).map {
            var i = 0
            return snail($0, &i)
        }
        var maxMagnitude = 0
        for l in numbers {
            for r in numbers {
                if l == r {
                    continue
                }
                maxMagnitude = max(maxMagnitude, (l + r).magnitude())
            }
        }
        return maxMagnitude
    }
}
