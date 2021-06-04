import Foundation

enum GameError: LocalizedError {
    case noDice

    var errorDescription: String? {
        var error: String? = nil

        switch self {
            case .noDice: error = "There are no dice to roll. Please score or put some dice back."
        }

        return error
    }
}