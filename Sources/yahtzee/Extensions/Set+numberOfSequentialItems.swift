import Foundation

extension Set where Element: SignedInteger {
    var numberOfSequentialItems: Int {
        let collection = self.sorted(by: { $0 > $1 })
        
		return collection.reduce(into: 0) { totalConsecutives, number in
			if number != collection.last! {
				if let NEXT_NUMBER = collection.element(after: number) {
					if abs(number-NEXT_NUMBER) == 1 {
						totalConsecutives += NEXT_NUMBER == collection.last! ? 2 : 1
					}
				}			
			}
		}
	}
}