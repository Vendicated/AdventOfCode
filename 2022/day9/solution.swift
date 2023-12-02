import Foundation

@frozen
public struct Position: Hashable {
    let x: Int
    let y: Int
}

func getMove(from: Int, to: Int) -> Int {
    return from < to ? 1 : -1
}

for file in CommandLine.arguments.dropFirst() {
    let lines = try! String(contentsOfFile: file, encoding: .utf8)
        .trimmingCharacters(in: CharacterSet.newlines)
        .split(separator: "\n")

    var visited1 = Set<Position>()
    var visited2 = Set<Position>()

    var head = Position(x: 0, y: 0)
    var tail = Position(x: 0, y: 0)

    var knotList = [Position](repeating: Position(x: 0, y: 0), count: 9)

    visited1.insert(tail)
    visited2.insert(tail)

    func move(to: Position) {
        head = to

        let oldTail = tail
        tail = moveKnot(head: head, tail: tail)
        if oldTail == tail {
            return
        }

        visited1.insert(tail)

        var prevKnot = head
        for (idx, knot) in knotList.enumerated() {
            let newKnot = moveKnot(head: prevKnot, tail: knot)
            if newKnot == knot {
                break
            }
            knotList[idx] = newKnot
            prevKnot = newKnot
            if idx == 8 {
                visited2.insert(newKnot)
            }
        }
    }

    func moveKnot(head: Position, tail: Position) -> Position {
        let touching = abs(head.x - tail.x) < 2 && abs(head.y - tail.y) < 2
        if touching {
            return tail
        }

        if head.x == tail.x {
            return Position(x: tail.x, y: tail.y + getMove(from: tail.y, to: head.y))
        } else if head.y == tail.y {
            return Position(x: tail.x + getMove(from: tail.x, to: head.x), y: tail.y)
        }
        return Position(
            x: tail.x + getMove(from: tail.x, to: head.x),
            y: tail.y + getMove(from: tail.y, to: head.y)
        )
    }

    for line in lines {
        let split = line.split(separator: " ")
        let (direction, distance) = (split[0], Int(split[1])!)

        for _ in 0..<distance {
            switch direction {
                case "U": move(to: Position(x: head.x, y: head.y + 1))
                case "D": move(to: Position(x: head.x, y: head.y - 1))
                case "L": move(to: Position(x: head.x - 1, y: head.y))
                case "R": move(to: Position(x: head.x + 1, y: head.y))
                default:
                    fatalError("Invalid direction \(direction)")
            }
        }
    }

    print("Part 1: \(visited1.count)")
    print("Part 2: \(visited2.count)")
}
