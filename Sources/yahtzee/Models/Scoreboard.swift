struct Scoreboard {
    var sheet: [[String: Int]] = [[String: Int]](repeating: [:], count: 2)

    var upperTotal: Int {
        guard !sheet[0].isEmpty else { return 0 }

        return sheet[0].values.reduce(0) { $0+$1 }
    }

    var lowerTotal: Int {
        guard !sheet[1].isEmpty else { return 0 }

        return sheet[1].values.reduce(0) { $0+$1 }
    }

    var gotUpperBonus: Bool {
        return upperTotal >= 63
    }

    var numberOfYahtzeeBonuses = 0

    var totalScore: Int {
        return (gotUpperBonus ? upperTotal + 35 : upperTotal) + lowerTotal + (numberOfYahtzeeBonuses*100)
    }
}
