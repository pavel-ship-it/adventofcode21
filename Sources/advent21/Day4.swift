class Card {
    var cells: [[Int]]
    func out() {
        print(cells.reduce("", { $0+($1.reduce("", {$0+String($1)+" "})+"\n")}))
    }
    init(cells: [[Int]]) {
        self.cells = cells
    }
    func andNow(_ n: Int) -> Int {
        for i in (0...4) {
            for j in (0...4) {
                if cells[i][j] == n {
                    cells[i][j] = -1
                }
            }
        }
        return isBingo() ? sum() * n : 0
    }
    func isBingo() -> Bool {
        for i in (0...4) {
            var row = 0
            var col = 0
            for j in (0...4) {
                row += cells[i][j]
                col += cells[j][i]
            }
            if row == -5 || col == -5 {
                return true
            }
        }
        return false
    }
    func sum() -> Int {
        cells.reduce([], +).reduce(0, { $0 + (($1 == -1) ? 0 : $1)})
    }
}
extension String {
    func mint(_ separator: Character = " ") -> [Int] {
        split(separator: separator, omittingEmptySubsequences: true).map {Int($0)!} as [Int]
    }
}

class Task7: Task {

    func calc(_ inputFile: String) -> Int {
        let input = fileData(inputFile)
        let cards = stride(from: 1, to: input.count, by: 5).map {
            Card(cells: input[$0..<$0+5].map { $0.mint() })
        }
        var sum = 0
        for num in input[0].mint(",") {
            sum = cards.reduce(0, { $0 + $1.andNow(num) })
            if sum != 0 {
                break
            }
        }
        return sum
    }
}

class Task8: Task {

    func calc(_ inputFile: String) -> Int {
        let input = fileData(inputFile)
        var cards = stride(from: 1, to: input.count, by: 5).map {
            Card(cells: input[$0..<$0+5].map { $0.mint() })
        }
        var sum = 0
        for num in input[0].mint(",") {
            if cards.count == 1 {
                sum = cards[0].andNow(num)
                if sum != 0 {
                    break
                }
            }
            else {
                cards = cards.filter { $0.andNow(num) == 0 }
            }
        }
        return sum
    }
}
