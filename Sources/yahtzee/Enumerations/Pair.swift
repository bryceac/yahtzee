// Type that represents the kind of pair dice forms. This is used to help determine a Full House, which requires a Three of a Kind.
enum Pair:String, CaseIterable {
	case threeOfAKind, fourOfAKind, fiveOfAKind
	
	// function that will return the appropriate name of the pair, if any exists.
	static func pair(of collection: [Int]) -> Pair? {
		guard collection.count == 5 else {
			preconditionFailure("Array must have exactly 5 elements.")
		}
	
		// find number of duplicates in collection and return the appropriate pair
		switch collection {
			case let sequence where Set(sequence).count == 1: return .fiveOfAKind
			case let sequence where !sequence.filter({ number in
				sequence.count { $0 == number } >= 4
			}).isEmpty: return .fourOfAKind
			case let sequence where !sequence.filter({ number in
				sequence.count { $0 == number } >= 3
			}).isEmpty: return .threeOfAKind
			default: return nil
		}
	}
}