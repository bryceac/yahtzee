import Foundation

extension String {
    
    // function that can easily perfom regex and grab groups
    func matching(regexPattern: String) -> [[String]]? {
        
        // attempt to create an NSRegular expression object
        guard let regex = try? NSRegularExpression(pattern: regexPattern) else { return nil }
        
        // grab all matches
        let matches = regex.matches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count))
        
        // create empty two dimensional array
        var results: [[String]] = []
        
        // loop through matches and grab all captured groups
        for match in matches {
            var result: [String] = []
            
            // figure out how many ranges exist and subtract it by one
            let lastRange = match.numberOfRanges-1
            
            // loop through every range
            for i in 0...lastRange {
                // attempt to grab a group
                guard let groupRange = Range(match.range(at: i), in: self) else { continue }
                
                // add group to array
                result.append(String(self[groupRange]))
            }
            
            // add stored groups to 2 dimensional array
            results.append(result)
        }
        
        // return all matches
        return results
    }
}