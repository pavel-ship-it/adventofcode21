class Task33: Task {
    let rangeX = (155, 215)
    let rangeY = (-132, -72)
    func calc(_ inputFile: String) -> Int {
        var maxY = 0
        for x in (0...rangeX.1) {
            for y in (rangeY.0...abs(rangeY.0)) {
                let (hit, alt) = shoot(x, y, rangeX, rangeY)
                if hit {
                    maxY = max(maxY, alt)
                }
            }
        }
        return maxY
    }
    func shoot(_ x: Int, _ y: Int, _ rangeX: (Int, Int), _ rangeY: (Int, Int)) -> (Bool, Int) {
        var maxY = 0
        var pt = Point(x: 0, y: 0)
        var vX = x
        var vY = y
        repeat {
            maxY = max(maxY, pt.y)
            pt = Point(x: pt.x+vX, y: pt.y+vY)
            if pt.x>=rangeX.0 && pt.x <= rangeX.1 && pt.y>=rangeY.0 && pt.y <= rangeY.1 {
                return (true, maxY)
            }
            if pt.y >= rangeY.0 {
                vX = max(vX-1, 0)
                vY -= 1
            }
        } while pt.y >= rangeY.0
        return (false, 0)
    }
}
class Task34: Task33 {
    override func calc(_ inputFile: String) -> Int {
        var hits = 0
        for x in (0...rangeX.1).reversed() {
            for y in (rangeY.0...abs(rangeY.0)) {
                let (hit, _) = shoot(x, y, rangeX, rangeY)
                if hit {
                    hits+=1
                }
            }
        }
        return hits
    }
}