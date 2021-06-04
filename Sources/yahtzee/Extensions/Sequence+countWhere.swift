extension Sequence {
	func count(where predicate: (Element) -> Bool) -> Int {
		return self.lazy.filter(predicate).count
	}
}