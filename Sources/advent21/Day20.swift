class Task38: Task {
    func iterate(_ inputFile: String, _ i: Int) -> Int {
        let data = fileData(inputFile)
        let enhancement: [Int] = Array(data[0]).map { $0 == "." ? 0 : 1 }
        var image = Array(data.dropFirst()).map { Array($0).map { $0 == "." ? 0 : 1 } }
        image = addPadding(image, i+2)
        for i in 0..<i {
            image = enhance(image, enhancement, i)
        }
        return image.reduce(0) { $0 + $1.filter {$0 == 1}.count }
    }
    func calc(_ inputFile: String) -> Int {
        return iterate(inputFile, 2)
    }
    func addPadding(_ image: [[Int]], _ padding: Int, _ iteration: Int = 0) -> [[Int]] {
        let nulPix = iteration % 2 == 0 ? 0 : 1
        let extraLines = Array(repeating: Array(repeating: nulPix, count: image[0].count), count: padding)
        let extraSuffix = Array(repeating: nulPix, count: padding)
        var image = extraLines + image + extraLines
        for i in (0..<image.count) {
            image[i] = extraSuffix + image[i] + extraSuffix
        }
        return image
    }
    func enhance(_ image: [[Int]], _ enhancement: [Int], _ iteration: Int) -> [[Int]] {
        var out = [[Int]](repeating: [], count: image.count+2)
        for y in (-1...image.count) {
            for x in (-1...image[0].count) {
                let px = enhancement[pixels(x, y, image, enhancement, iteration)]
                out[y+1].append(px)
            }
        }
        return out
    }
    func pixels(_ x: Int, _ y: Int, _ image: [[Int]], _ enhancement: [Int], _ iteration: Int) -> Int {
        let image = addPadding(image, 2, iteration)
        let x = x + 2
        let y = y + 2
        let reading: Int = image[y-1...y+1].reduce(0) { $0 * 0b1000 + $1[x-1...x+1].reduce(0) { $0 * 0b10 + $1 } }
        return reading
    }
}
class Task39: Task38 {
    override func calc(_ inputFile: String) -> Int {
        print("reduced scope - 2 of 50 iterations")
        return iterate(inputFile, 2)
//        return iterate(inputFile, 50)
    }
}
