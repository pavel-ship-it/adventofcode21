import GLKit
let rotationMatrices: [GLKMatrix4] = {
    var out = [GLKMatrix4]()
    for face in [Vertex(x: 1, y: 0, z: 0),
                 Vertex(x: -1, y: 0, z: 0),
                 Vertex(x: 0, y: 1, z: 0),
                 Vertex(x: 0, y: -1, z: 0),
                 Vertex(x: 0, y: 0, z: 1),
                 Vertex(x: 0, y: 0, z: -1)] {
        for r in stride(from: 0, to: Float.pi, by: Float.pi/2.0) {
            out.append(GLKMatrix4Rotate(GLKMatrix4Identity, r, face.x, face.y, face.z))
        }
    }
    return out
}()
class Scaner {
    var beacons = [Beacon]() {
        didSet {
            beacons.forEach {
                $0.calcDistances(around: beacons)
            }
        }
    }
//    var distances = [Vertex]()
}
class Beacon: Hashable {
    var id: Float { get { abs(xyz.x) + abs(xyz.y) + abs(xyz.z) } }
    var xyz: Vertex
    var distances = [Float]()
    func calcDistances(around: [Beacon]) {
        distances = around.map { GLKVector3Distance(GLKVector3Make($0.xyz.x, $0.xyz.y, $0.xyz.z), GLKVector3Make(xyz.x, xyz.y, xyz.z)) }.filter { $0 != 0 }
    }
    init(_ xyz: (Int, Int, Int)) {
        self.xyz = Vertex(x: Float(xyz.0), y: Float(xyz.1), z: Float(xyz.2))
    }
    static func == (lhs: Beacon, rhs: Beacon) -> Bool {
        return lhs.match(rhs)
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    func match(_ beacon: Beacon) -> Bool {
        // match neighbouring beacons
        //        let hashesL = around.map { $0.id }
        //        let hashesR = beacon.around.map { $0.id }
        
        return false
    }
}

struct Vertex {
    let x: Float
    let y: Float
    let z: Float
    func FloatBuffer() -> [Float] { [x, y, z] }
}
class Task36: Task {
    func calc(_ inputFile: String) -> Int {
        let scaners = load(inputFile)
        
        for sa in scaners {
            for sb in scaners {
                if sa === sb {
                    continue
                }
                let inter = intersection(sa, sb)
                if inter.count > sa.beacons.count/2 {
                    print ("It's a Match!")
                }
            }
        }

        return 0
    }
    func load(_ inputFile: String) ->[Scaner] {
        var scaners = [Scaner]()
        for line in fileData(inputFile) {
            if line.isEmpty {
                continue
            } else if line.contains("scanner") {
                scaners.append(Scaner())
            } else {
                let coo = line.components(separatedBy: ",").map { Int($0)! }
                scaners.last?.beacons.append(Beacon((coo[0], coo[1], coo[2])))
            }
        }
        return scaners
    }
}

func intersection(_ sa: Scaner, _ sb: Scaner) -> Set<Beacon> {
    var scanerSection = Set<Beacon>()
    for ba in sa.beacons {
        var beaconSection = Set<Beacon>()
        for bb in sb.beacons {
            let setA = Set(ba.distances)
            let setB = Set(bb.distances)
            let inter = setA.intersection(setB)
            if inter.count >= setA.count/2 {
                beaconSection.insert(bb)
            }
        }
        if beaconSection.count >= 1 {
            scanerSection.insert(ba)
        }
    }
    return scanerSection
}

/*class Task36: Task {
    func calc(_ inputFile: String) -> Int {
        var scanners = [Scaner]()
        for line in fileData(inputFile) {
            if line.isEmpty {
                continue
            } else if line.contains("scanner") {
                scanners.append(Scaner())
            } else {
                let coo = line.components(separatedBy: ",").map { Int($0)! }
                scanners.last?.beacons.append(Beacon((coo[0], coo[1], coo[2])))
            }
        }
        
        scanners.forEach { s in
            s.distances = s.beacons.map {
                $0.meetNeighbours(around: s.beacons)
                return ($0.around.min()!, $0.around.max()!, 1)
            }
            s.beacons.forEach { b in
                b.meetNeighbours(around: s.beacons)
            }
        }

//        scanners.forEach { s in
//            print("\n\n-- s --")
////            print(s.distances)
//            for b in s.beacons {
////                print("\(b.around) \(b.around.reduce(0, +))")
//                print("\(b.around)")
//            }
////            s.beacons.forEach { b in
////                print(b.around)
////            }
//        }

//        scanners.reduce(into: Set<Int>()) { partialResult, s in
//            s.beacons.reduce(partialResult) { partialResult.formUnion($1.around)
//                return partialResult
//            }
//        }

        for sa in scanners {
            for sb in scanners {
                if sa === sb {
                    continue
                }
                let inter = intersection(sa, sb)
                if inter.count > sa.beacons.count/2 {
                    print ("It's a Match!")
                }
            }
        }
        return 0
    }
}
func intersection(_ sa: Scaner, _ sb: Scaner) -> Set<Beacon> {
    var scanerSection = Set<Beacon>()
    for ba in sa.beacons {
        var beaconSection = Set<Beacon>()
        for bb in sb.beacons {
            let setA = Set(ba.around)
            let setB = Set(bb.around)
            let inter = setA.intersection(setB)
            if inter.count >= setA.count/2 {
                beaconSection.insert(bb)
            }
        }
        if beaconSection.count >= 1 {
            scanerSection.insert(ba)
        }
    }
    return scanerSection
}
class Scaner {
    var beacons = [Beacon]()
    var distances = [(Int, Int, Int)]()
}
func -(l:(Int, Int, Int), r:(Int, Int, Int)) -> (Int, Int, Int) {
    (l.0-r.0, l.1-r.1, l.2-r.2)
}
func distance(l:(Int, Int, Int), r:(Int, Int, Int)) -> Int {
    let a = l-r
    return a.0*a.0+a.1*a.1+a.2*a.2
}
class Beacon: Hashable {
    var id: Int { get { abs(xyz.0) + abs(xyz.1) + abs(xyz.2) } }
    var xyz: (Int, Int, Int)
    var around = [Int]()
    func meetNeighbours(around: [Beacon]) {
//        self.around = around.map { distance(l: $0.xyz, r: xyz) }.sorted(by: <).filter { $0 != 0 }
        self.around = around.map { distance(l: $0.xyz, r: xyz) }.filter { $0 != 0 }
    }
    init(_ xyz: (Int, Int, Int)) {
        self.xyz = xyz
    }
    static func == (lhs: Beacon, rhs: Beacon) -> Bool {
        return lhs.match(rhs)
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    func match(_ beacon: Beacon) -> Bool {
        // match neighbouring beacons
//        let hashesL = around.map { $0.id }
//        let hashesR = beacon.around.map { $0.id }
        
        return false
    }
}
*/
