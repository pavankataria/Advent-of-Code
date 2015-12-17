/*--- Day 3: Perfectly Spherical Houses in a Vacuum ---

--- Part Two ---

The next year, to speed up the process, Santa creates a robot version of himself, Robo-Santa, to deliver presents with him.

Santa and Robo-Santa start at the same location (delivering two presents to the same starting house), then take turns moving based on instructions from the elf, who is eggnoggedly reading from the same script as the previous year.

This year, how many houses receive at least one present?

For example:

^v delivers presents to 3 houses, because Santa goes north, and then Robo-Santa goes south.
^>v< now delivers presents to 3 houses, and Santa and Robo-Santa end up back where they started.
^v^v^v^v^v now delivers presents to 11 houses, with Santa going one direction and Robo-Santa going the other.


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
    var roboSanta = Santa()
    
    let listOfDirections: String
    
    init(){
        listOfDirections = getInputFromFile("input", withExtension: "txt")
    }
    
    private func deliverPresentAtLocation(coordinate: Coordinate) {
        //if a coordinate key is found - a house exists so increment present to the house object.
        if var house = houses[coordinate.stringPosition()]{
            house.addPresent()
        }
            /* if a key is not found, add a new object with key being the new coordinate
            and value being a new house with present value being 1 */
        else {
            houses[coordinate.stringPosition()] = House.init(coordinate: coordinate, withPresentsCount:1)
        }
    }
    func deliverPresentsToTheGoodChildren(){
        deliverPresentAtLocation(Coordinate.init(x: 0, y: 0))
        deliverPresentAtLocation(Coordinate.init(x: 0, y: 0))
        
        for (index, rawDirection) in listOfDirections.characters.enumerate() {
            let direction = CardinalDirection.init(rawValue: rawDirection)
            if direction == nil {
                continue
            }
            
            if(index % 2 == 0) {
                print("santa's turn to deliver")
                santa.moveInDirection(direction!)
                deliverPresentAtLocation(santa.position)
                
            }
            else {
                print("roboSanta's turn to deliver")
                roboSanta.moveInDirection(direction!)
                deliverPresentAtLocation(roboSanta.position)
            }
            
        }
    }
}

let xMasTracker = ChristmasTracker()
xMasTracker.deliverPresentsToTheGoodChildren()
let numberOfHousesThatReceivedPresents = xMasTracker.houses.count
print("\(numberOfHousesThatReceivedPresents) are the number of houses that received at least one present with santa and robosanta both working this christmas")


