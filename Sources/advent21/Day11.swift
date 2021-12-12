class Task21: Task {
    var octoMap = [[Int]]()
    var flashes = 0
    func powerAround(_ pt: Point) -> Set<Point>? {
        var willFlash = Set<Point>()
        for y in (pt.y-1...pt.y+1) {
            for x in (pt.x-1...pt.x+1) {
                if x<0 || y<0 || x>=octoMap[0].count || y>=octoMap.count || (x==pt.x && y==pt.y) {
                    continue
                }
                octoMap[y][x] += 1
                if octoMap[y][x] > 9 {
                    willFlash.insert(Point(x: x, y: y))
                }
            }
        }
        return willFlash.count > 0 ? willFlash : nil
    }
    func tick() {
        var willFlash = Set<Point>()
        var resetFlash = Set<Point>()
        for y in (0..<octoMap.count) {
            for x in (0..<octoMap[0].count) {
                octoMap[y][x] += 1
                if octoMap[y][x] > 9 {
                    willFlash.insert(Point(x: x, y: y))
                }
            }
        }
        while let pt = willFlash.popFirst() {
            if let willFlashToo = powerAround(pt) {
                willFlash = willFlash.union(willFlashToo.subtracting(resetFlash))
            }
            resetFlash.insert(pt)
        }
        flashes += resetFlash.count
        resetFlash.forEach { octoMap[$0.y][$0.x] = 0 }
    }
    func calc(_ inputFile: String) -> Int {
        octoMap = fileData(inputFile).map { $0.map { Int(String($0))! } }
        (0..<100).forEach { _ in tick() }
        return flashes
    }
}
class Task22: Task21 {
    var counter = 0
    override func calc(_ inputFile: String) -> Int {
        octoMap = fileData(inputFile).map { $0.map { Int(String($0))! } }
        repeat {
            tick()
            counter+=1
        } while !octoMap.allSatisfy { $0.allSatisfy { $0 == 0 } }
        return counter
    }
}
