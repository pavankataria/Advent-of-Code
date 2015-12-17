/*--- Day 3: Perfectly Spherical Houses in a Vacuum ---

Santa is delivering presents to an infinite two-dimensional grid of houses.

He begins by delivering a present to the house at his starting location, and then an elf at the North Pole calls him via radio and tells him where to move next. Moves are always exactly one house to the north (^), south (v), east (>), or west (<). After each move, he delivers another present to the house at his new location.

However, the elf back at the north pole has had a little too much eggnog, and so his directions are a little off, and Santa ends up visiting some houses more than once. How many houses receive at least one present?

For example:

> delivers presents to 2 houses: one at the starting location, and one to the east.
^>v< delivers presents to 4 houses in a square, including twice to the house at his starting/ending location.
^v^v^v^v^v delivers a bunch of presents to some very lucky children at only 2 houses.


*/
import Foundation


func getInputFromFile(fileName: String, withExtension ext: String) -> String{
    let fileURL = NSBundle.mainBundle().URLForResource("input", withExtension: "txt")
    assert(fileURL != nil, "input.txt file not found.")
    let content = try! String(contentsOfURL: fileURL!, encoding: NSUTF8StringEncoding)
    return content
}


struct Coordinate {
    var x: Int
    var y: Int
    func stringPosition() -> String {
        return "\(x),\(y)"
    }
}
struct House {
    var totalPresents = 0
    let coordinate: Coordinate
    
    init(coordinate: Coordinate, withPresentsCount: Int){
        self.coordinate = coordinate
    }
    mutating func addPresent(){
        totalPresents++
    }
    mutating func addPresent(count: Int){
        totalPresents += count
    }
}
enum CardinalDirection: Character {
    case North = "^"
    case East = ">"
    case South = "V"
    case West = "<"
}
struct Santa {
    var position: Coordinate
    init(){
        position = Coordinate.init(x: 0, y: 0)
    }
    mutating func moveInDirection(direction: CardinalDirection) {
        switch direction {
        case .North:
            position.y--
        case .East:
            position.x++
        case .South:
            position.y++
        case .West:
            position.x--
        }
    }
}


class ChristmasTracker {
    var houses = [String : House]()
    var santa = Santa()
    let listOfDirections: String
    
    init(){
        listOfDirections = getInputFromFile("input", withExtension: "txt")
    }
    
    private func deliverPresentAtLocation(coordinate: Coordinate) {
        if var house = houses[coordinate.stringPosition()]{
            house.addPresent()
        }
        else {
            houses[coordinate.stringPosition()] = House.init(coordinate: coordinate, withPresentsCount:1)
        }
    }
    func deliverPresentsToTheGoodChildren(){
        deliverPresentAtLocation(santa.position)
        for rawDirection in listOfDirections.characters {
            if let direction = CardinalDirection.init(rawValue: rawDirection) {
                santa.moveInDirection(direction)
                deliverPresentAtLocation(santa.position)
            }
        }
    }
}

let xMasTracker = ChristmasTracker()
xMasTracker.deliverPresentsToTheGoodChildren()


