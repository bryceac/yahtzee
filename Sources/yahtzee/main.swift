import Foundation

let GAME = Game()

repeat {
    GAME.run()

    print("Your final score is: \(GAME.scoreboard.totalScore)")

    print("Upper section greater than or equal to 63? \(GAME.scoreboard.gotUpperBonus ? "Yes" : "No")")
    print("Multiple Yahtzees? \(GAME.scoreboard.numberOfYahtzeeBonuses > 0 ? "Yes" : "No")")

    print("Do you want to play again? ([Y]es or [N]o) ", terminator: "")

    var playAgain: Bool? =  nil

    repeat {
        if let answer = readLine() {
            guard answer.count == 1 else {
                print("Response must be only one character.")
                continue 
            }

            switch answer {
                case let a where a.caseInsensitiveCompare("y") == .orderedSame: playAgain = true
                case let a where a.caseInsensitiveCompare("n") == .orderedSame: playAgain = false
                default: print("Invalid choice.")
            }
        }
    } while playAgain == nil

    if let NEW_GAME = playAgain {
        if !NEW_GAME {
            GAME.gameState = .gameOver
        } else {
            for index in GAME.dice.indices {
                GAME.dice[index].number = 0
            }

            for (index, section) in GAME.scoreboard.sheet.enumerated() {
                guard !section.isEmpty else { continue }

                GAME.scoreboard.sheet[index].removeAll()
            }
        }
    }
} while GAME.gameState == .newGame