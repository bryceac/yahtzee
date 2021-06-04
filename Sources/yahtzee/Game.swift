import Foundation

class Game {
    var scoreboard: Scoreboard = Scoreboard()
    var dice: [Die] = [Die](repeating: Die(), count: 5)
    var gameState: GameState = .newGame

    // return the point values that can possibly be gained in the upper section.
    func yahtzee_upper_scoreboard(_ roll: [Int]) -> [Int: Int] {
	return [Int](1...6).reduce(into: [:]) { tallies, number in
		    tallies[number] = number * roll.count(where: { $0 == number })
	    }
    }

    // create a dictionary of what a player can score in the bottom section, based upon a given roll.
    func yahtzee_lower_scoreboard(_ roll: [Int]) -> [String: Int] {
	    
        // dictionary to hold possible points.
        var scores: [String: Int] = [
		    "Three of A Kind": 0,
		    "Four of A Kind": 0,
		    "Full House": 0,
		    "Small Straight": 0,
		    "Large Straight": 0,
		    "Chance": 0,
		    "Yahtzee": 0
	    ]

        // check the kind of combination was formed and give the appropriate keys proper values.
	    if let combination = Combination.combination(of: roll) {
		    switch combination {
			    case .yahtzee:
				    scores["Yahtzee"] = 50
				    scores["Four of A Kind"] = roll.reduce(0) { $0+$1 }
				    scores["Three of A Kind"] = roll.reduce(0) { $0+$1 }
			    case .fourOfAKind:
				    scores["Four of A Kind"] = roll.reduce(0) { $0+$1 }
				    scores["Three of A Kind"] = roll.reduce(0) { $0+$1 }
			    case .fullHouse:
				    scores["Full House"] = 25
				    scores["Three of A Kind"] = roll.reduce(0) { $0+$1 }
			    case .threeOfAKind:
				    scores["Three of A Kind"] = roll.reduce(0) { $0+$1 }
			    case .largeStraight:
				    scores["Large Straight"] = 40
				    scores["Small Straight"] = 30
			    case .smallStraight:
				    scores["Small Straight"] = 30
		    }
	    }
	
	    scores["Chance"] = roll.reduce(0) { $0+$1 }
	
        // return the completed dictionary
	    return scores
    }

    /* function that actually performs the dice roll.
    This function will throw an error if all 5 dice are being saved.
    */
    func rollDice() throws {
        guard !dice.allSatisfy({ $0.isHeld }) else { 
            throw GameError.noDice
        }

        for index in dice.indices {
            guard !dice[index].isHeld else { continue }
            dice[index].roll()
        }
    }

    // function that allows the player to save more thsn one die.
    func saveDie() {
        let CHOICES = (dice.map { "\($0.number)" }) + ["Done"]

        var isDone = false

        let PLAYER_DIALOG = Dialogue(message: "Which die would you like to save (Choose Done to exit and choosing the same number again will put it back)?", choices: CHOICES)

        repeat {
            PLAYER_DIALOG.run { choice in
                switch choice {
                    case 1, 2, 3, 4, 5:
                        self.dice[choice-1].isHeld.toggle()

                        print("\(self.dice[choice-1].isHeld ? "Saved" : "Put back") die \(choice)")
                    default: isDone = true
                }
            }
        } while !isDone
    }

    /* allow player to score points. 
    
    Due to players being forced to score after three rolls, there is no option to back out of this without scoring.
    */ 
    func score(_ roll: [Die]) {
        var choices = [String]()

        let UPPER_SECTION = yahtzee_upper_scoreboard(roll.map({ $0.number }))
        let LOWER_SECTION = yahtzee_lower_scoreboard(roll.map({ $0.number }))

        for (key, score) in UPPER_SECTION {
            guard !scoreboard.sheet[0].keys.contains("\(key)") else { continue }

            choices.append("\(key) for \(score) points")
        }

        for (key, score) in LOWER_SECTION {
            guard !scoreboard.sheet[1].keys.contains("\(key)") else { continue }

            choices.append("\(key) for \(score) points")
        }

        let PLAYER_DIALOG = Dialogue(message: "What do you want to score?", choices: choices)

        PLAYER_DIALOG.run { choice in

            // get user's choice from input.
            let SELECTION = choices[choice-1]

            // attempt to retrieve the specified key from the given choices
            let KEY = SELECTION.matching(regexPattern: "(.*?) for")

            if let RESULT = KEY {
                let DICT_KEY = RESULT[0][1]

                // check which dictionary has the selected key.
                if let NUMERIC_KEY = Int(DICT_KEY), let VALUE = UPPER_SECTION[NUMERIC_KEY] {
                    self.scoreboard.sheet[0][DICT_KEY] = VALUE
                } else if let VALUE = LOWER_SECTION[DICT_KEY] {
                    self.scoreboard.sheet[1][DICT_KEY] = VALUE
                }

                // make sure Yahtzee bonuses are properly given
                if let COMBINATION = Combination.combination(of: roll.map { $0.number }) {
                    if case Combination.yahtzee = COMBINATION {
                        if let YAHTZEE_SCORE = self.scoreboard.sheet[1]["Yahtzee"] {
                            self.scoreboard.numberOfYahtzeeBonuses += YAHTZEE_SCORE != 0 ? 1 : 0
                        }
                    }
                }
            }
        }
    }

    // function that initiate a round in Yahtzee
    func playTurn() {

        // keep track of the number of rolls made during play
        var rolls = 0

        // make sure all dice can be rolled on the first roll
        if rolls == 0 {
            for index in dice.indices where dice[index].isHeld {
                dice[index].isHeld.toggle()
            }
        }

        // create loop to ensure that players get all their rolls
        repeat {

            // roll contains the numbers rolled by the player
            var roll = ""

            // iterate through the dice and format them in an easy to view string, with exclamation points to show held dice.
            for die in dice {
                guard die.number > 0 else { continue }
                guard let DIE_INDEX = dice.firstIndex(of: die) else { continue }

                roll += DIE_INDEX == dice.indices.last! ? "\(die.number)\(die.isHeld ? "!" : "")" : "\(die.number)\(die.isHeld ? "!" : "") "
            }

            // display dice only when each die has a value
            if !roll.isEmpty {
                print(roll)
            }

            /* present players with certain choice, depending on how many rolls they made and execute the appropriate action.

            After 3 rolls, a player is forced to score, which will automatically end the turn by making roll count 4. */
            switch rolls {
                case 0:
                    let CHOICES = ["Roll", "Quit"]
                    let PLAYER_DIALOG = Dialogue(message: "What do you want to do?", choices: CHOICES)

                    PLAYER_DIALOG.run { choice in
                        switch choice {
                            case 1:
                                do {
                                    try self.rollDice()
                                    rolls += 1
                                } catch (let error) {
                                    print(error.localizedDescription)
                                }
                            case 2: exit(0)
                            default: ()
                        }
                    }
                case 1, 2:
                    let CHOICES = ["Hold dice", "Roll", "Score", "Quit"]
                    let PLAYER_DIALOG = Dialogue(message: "What would you like to do?", choices: CHOICES)

                    PLAYER_DIALOG.run { choice in
                        switch choice {
                            case 1: self.saveDie()
                            case 2:
                                do {
                                    try self.rollDice()
                                    rolls += 1
                                } catch (let error) {
                                    print(error.localizedDescription)
                                }
                            case 3: 
                                self.score(self.dice)
                                rolls = 4
                            case 4: exit(0)
                            default: ()
                        }
                    }
                case 3:
                    let CHOICES = ["Score", "Quit"]
                    let PLAYER_DIALOG = Dialogue(message: "What would you like to do?", choices: CHOICES)

                    PLAYER_DIALOG.run { choice in
                        switch choice {
                            case 1: 
                                self.score(self.dice)
                                rolls = 4
                            case 2: exit(0)
                            default: ()
                        }
                    }
                default: ()
            }
        } while rolls <= 3
    }

    // function that actually runs through a round.
    func run() {
        var totalFieldsFilled: Int {
            return self.scoreboard.sheet.reduce(into: 0) { counter, section in
                counter += section.count
            }
        }

        var gameIsCompleted: Bool {
            return totalFieldsFilled == 13
        }

        while (!gameIsCompleted) {
            let UPPER_SECTION = GAME.scoreboard.sheet[0]
            let LOWER_SECTION = GAME.scoreboard.sheet[1]

            if !UPPER_SECTION.isEmpty {
                for (number, score) in UPPER_SECTION {
                    print("\(number): \(score)")
                }

                print("-----")
            }

            if !LOWER_SECTION.isEmpty {
                for (key, score) in LOWER_SECTION {
                    print("\(key): \(score)")
                }

                print("-----")
            }

            playTurn()
        }
    }
}