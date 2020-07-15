//
//  String+RegEx.swift
//  LocQAAnalyzer
//
//  Created by Chao Wu on 12/5/19.
//  Copyright © 2019 wistron. All rights reserved.
//

import Foundation

extension String {

    /// https://stackoverflow.com/questions/39677330/how-does-string-substring-work-in-swift
    subscript(r: CountableClosedRange<Int>) -> String? {
        guard r.lowerBound >= 0, r.upperBound < self.count else { return nil }

        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound)
        return String(self[start...end])
    }

    subscript(r: Range<Int>) -> String? {
            guard r.lowerBound >= 0, r.upperBound <= self.count else { return nil }

            let start = index(startIndex, offsetBy: r.lowerBound)
            let end = index(startIndex, offsetBy: r.upperBound)
            return String((self + "")[start..<end])
        }

    public func reGroups(_ pattern: String) -> [String]? {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else { return nil }

        let matches = regex.matches(in: self, options: [], range: NSRange(location: 0, length: self.count))
        guard !matches.isEmpty else { return nil }

        var results = [String]()
        for match in matches {
            let lastRange = match.numberOfRanges
            guard lastRange >= 1 else { continue }

            for i in 1..<lastRange {
                let capturedGroupIndex = match.range(at: i)
                let matchedString = (self as NSString).substring(with: capturedGroupIndex)
                guard !results.contains(matchedString) else {
                    continue
                }
                results.append(matchedString)
            }
        }

        return results
    }

    /// https://stackoverflow.com/questions/53238251/swift-splitting-strings-with-regex-ignoring-search-string
    public func reSplit(_ pattern: String) -> [String]? {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else { return nil }

        let matches = regex.matches(in: self, options: [], range: NSRange(location: 0, length: self.count))
        guard !matches.isEmpty else { return [self] }

        let ranges: [NSRange] = [NSRange(location: 0, length: 0)] + matches.map { $0.range } + [NSRange(location: self.count, length: 0)]
        return (0...matches.count).map {
            self[ranges[$0].upperBound..<ranges[$0 + 1].lowerBound]
        }.compactMap { $0 }.filter { !$0.isEmpty }
    }

    public func versionCheck(in pattern: String) -> String? {
        var result = [String]()
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else { return nil }

        let matches = regex.matches(in: self, options: [], range: NSRange(location: 0, length: self.count))
        guard !matches.isEmpty else { return nil }

        for match in matches {
            result.append(contentsOf: [String(self[Range(match.range(at: 0), in: self)!])]) // swiftlint:disable:this force_unwrapping
        }
        return result.first
    }

    public static func ~= (lhs: String, rhs: String) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: rhs, options: [.caseInsensitive]) else { return false }

        let range = NSRange(location: 0, length: lhs.utf16.count)
        return regex.firstMatch(in: lhs, options: [], range: range) != nil
    }

}
