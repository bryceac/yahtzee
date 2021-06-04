import Foundation

extension Array where Element: Equatable {
	func element(before item: Element) -> Element? {
		guard let ITEM_INDEX = self.firstIndex(where: { $0 == item }) else { return nil }
		
		let PREVIOUS_ITEM_INDEX = self.index(before: ITEM_INDEX)
		
		return self[PREVIOUS_ITEM_INDEX]
	}

	func element(after item: Element) -> Element? {
		guard let ITEM_INDEX = self.firstIndex(where: { $0 == item }) else { return nil }
		
		let NEXT_ITEM_INDEX = self.index(after: ITEM_INDEX)
		return self[NEXT_ITEM_INDEX]
	}
}