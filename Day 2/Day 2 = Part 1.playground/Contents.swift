/*
--- Day 2: I Was Told There Would Be No Math ---

The elves are running low on wrapping paper, and so they need to submit an order for more. They have a list of the dimensions (length l, width w, and height h) of each present, and only want to order exactly as much as they need.

Fortunately, every present is a box (a perfect right rectangular prism), which makes calculating the required wrapping paper for each gift a little easier: find the surface area of the box, which is 2*l*w + 2*w*h + 2*h*l. The elves also need a little extra paper for each present: the area of the smallest side.

All numbers in the elves' list are in feet. How many total square feet of wrapping paper should they order?

*/

import Foundation

typealias Feet = Int
typealias SquareFeet = Int

protocol WrappingProtocol {
    func totalWrappingPaperRequired() -> SquareFeet
}

struct Present {
    let length: Feet
    let width: Feet
    let height: Feet
    
    let bottomArea: SquareFeet
    let frontArea: SquareFeet
    let sideArea: SquareFeet
    
    var area: SquareFeet {
        return bottomArea + frontArea + sideArea
    }
    
    init(stringInstruction: String){
        let boxComponents = stringInstruction.componentsSeparatedByString("x")
            .flatMap({Int($0)})
        assert(boxComponents.count == 3, "String instruction requires 3 values seperated by the character x")
        length = boxComponents[0]
        width = boxComponents[1]
        height = boxComponents[2]
        
        bottomArea = length * width
        frontArea = width * height
        sideArea = length * height
    }
}
extension Present : WrappingProtocol {
    func totalWrappingPaperRequired() -> SquareFeet {
        let smallestArea = min(bottomArea, frontArea, sideArea)
        return area * 2 + smallestArea
    }
}

let fileURL = NSBundle.mainBundle().URLForResource("input", withExtension: "txt")
let content = try String(contentsOfURL: fileURL!, encoding: NSUTF8StringEncoding)

let presents = content.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
.map(Present.init)

var totalWrappingPaper = 0
for present in presents {
    totalWrappingPaper += present.totalWrappingPaperRequired()
}

print("Total wrapping paper required: \(totalWrappingPaper)")
