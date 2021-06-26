import Foundation

extension Set where Element: SignedInteger {
    var numberOfSequentialItems: Int {
        let COLLECTION = self.sorted(by: { $0 < $1 })
        
        var sequentialCollection: Set<Element> = Set()
        
        for number in COLLECTION {
            if number != COLLECTION.last! {
                let nextNumber = COLLECTION.element(after: number)!
                
                if nextNumber != COLLECTION.last! {
                    if abs(number - nextNumber) == 1 {
                        sequentialCollection.insert(number)
                        sequentialCollection.insert(nextNumber)
                    }
                }
            } else {
                if let LARGEST_NUMBER = sequentialCollection.max(), number - LARGEST_NUMBER == 1 {
                    sequentialCollection.insert(number)
                }
            }
        }

        return sequentialCollection.count
    }
}
