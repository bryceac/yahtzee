struct Die {
    var number: Int
    var isHeld: Bool

    init(withNumber number: Int = 0, andIsHeld isHeld: Bool = false) {
        (self.number, self.isHeld) = (number, isHeld)
    }

    mutating func roll() {
        guard let THROW = [Int](1...6).randomElement() else { return }

        number = THROW
    }
}

extension Die: Comparable {
    static func == (lhs: Die, rhs: Die) -> Bool {
        return lhs.number == rhs.number && lhs.isHeld == rhs.isHeld
    }

    static func <(lhs: Die, rhs: Die) -> Bool {
        return lhs.number < rhs.number
    }
}

extension Die: CustomStringConvertible {
    var description: String {
        return "\(number)\(isHeld ? "!" : "")"
    }
}
