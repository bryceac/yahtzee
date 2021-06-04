struct Dialogue {
    var message: String
    var choices: [String]

    mutating func removeChoice(_ choice: Int) {
        guard choice < choices.count else { return }

        choices.remove(at: choice)
    }

    mutating func addChoice(_ choice: String) {
        choices.append(choice)
    }

    func run(completion: @escaping (Int) -> Void) {
        var choice = 0

        repeat {
            for (index, choice) in choices.enumerated() {
                print("\(index+1). \(choice)")
            }

            print(message, terminator: " ")

            if let input = readLine(), let selection = Int(input) {
                guard selection <= choices.count else {
                    print("Invalid choice")
                    continue
                }
                choice = selection
            } else {
                print("Invalid input. Input must be a number correspending to the desired choice.")
            }
        } while choice == 0

        completion(choice)
    }
}