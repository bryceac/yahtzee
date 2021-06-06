import Foundation

extension Array where Element: Equatable {
    
    /// retrieve the preceding element in array.
	func element(before item: Element) -> Element? {
        
        // retroeve the index of a given item
		guard let ITEM_INDEX = self.firstIndex(where: { $0 == item }) else { return nil }
        
        // make sure given item is not the first element.
        guard ITEM_INDEX > self.startIndex else { return nil }
		
        // retrieve preceding index
		let PREVIOUS_ITEM_INDEX = self.index(before: ITEM_INDEX)
		
        // return the preceding item
		return self[PREVIOUS_ITEM_INDEX]
	}

    /// retrieve the succeeding element in an array.
	func element(after item: Element) -> Element? {
        
        // retrieve the index of the given item
		guard let ITEM_INDEX = self.firstIndex(where: { $0 == item }) else { return nil }
        
        // make sure that item is not the last in the array
        guard ITEM_INDEX < self.endIndex-1 else { return nil }
		
        // get the index of the next item in line and return the item.
		let NEXT_ITEM_INDEX = self.index(after: ITEM_INDEX)
		return self[NEXT_ITEM_INDEX]
	}
}
