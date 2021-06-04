// Type that represents the combination created by the dice.
enum Combination: String, CaseIterable {
	case threeOfAKind, fourOfAKind, yahtzee, smallStraight, largeStraight, fullHouse
	
	static func combination(of collection: [Int]) -> Combination? {
		guard collection.count ==  5  else {
			preconditionFailure("Array must have exactly 5 elements.")
		}
		
		/* unwrap Pair type value, to help determine if roll is a 3 of a kind, 4 of a kind, 5 of a kind, etc.
		The large and small straights use a custom computed proptery to help determine how many sequential items are present.
		*/
		switch (collection, Pair.pair(of: collection)) {
			case let (_, .some(pair)) where pair == .fiveOfAKind: return .yahtzee
			case let (sequence, .some(pair)) where pair == .threeOfAKind && Set(sequence).count == 2: return .fullHouse
			case let (_, .some(pair)): return Combination.allCases.first(where: { $0.rawValue == pair.rawValue })
			case let (sequence, .none) where Set(sequence).count == 5 && Set(sequence).numberOfSequentialItems == 5: return .largeStraight
			case let (sequence, .none) where Set(sequence).numberOfSequentialItems >= 4: return .smallStraight
			default: return nil
		}
	}
}