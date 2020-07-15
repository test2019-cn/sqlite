//
//  Keyword.swift
//  LocQAAnalyzer
//
//  Created by Tiny Liu on 2020/5/6.
//  Copyright © 2020 wistron. All rights reserved.
//

import Foundation

struct Keyword: Codable {

    let addedAt: String?
    let addedBy: Person?
    let keyword: Component?

    enum Category: String, CaseIterable, CustomStringConvertible {
        case translation = "Translation"
        case layout = "HI/Layout"
        case locFunctional = "LocFunctional"
        case localizability = "Localizability"
        case intlFunctionality = "IntlFunctionality"
        case onlineContent = "OnlineContent"
        case transEngineering = "TransEngineering"
        case english = "US"
        case build = "Build"
        case autolayout = "Autolayout"
        case others = "Others"
        case missing = "Missing Keywords"

        var description: String {
            return self.rawValue
        }
    }

    func isCategory() -> Bool? {
        guard isTransKeyword() != true else {
            return false
        }

        let patterns = [
            "^Asia Originated",
            "^iBox ", // iBox auto-closed, iBox verified
            "^iLogger$",
            "^iWorkLoc$",
            "^XRA Processed$"
        ]

        guard let name = self.keyword?.name, let regex = try? NSRegularExpression(pattern: patterns.joined(separator: "|")) else {
            return nil
        }

        let range = NSRange(location: 0, length: name.utf16.count)
        return Bool(regex.firstMatch(in: name, options: [], range: range) == nil)
    }

    /// `Trans-***` + `Terminology`
    ///
    /// ACTION: Missing Trans-Keywords (2019 Jazzkon releases)
    enum TransKeyword: String, CaseIterable, CustomStringConvertible {
        case context = "Context"
        case inconsistency = "Inconsistency"
        case unclear = "Keyword unclear"
        case layout = "Layout"
        case leverage = "Leverage"
        case mistranslation = "Mistranslation"
        case spellingGrammar = "Spelling/Grammar"
        case style = "Style"
        case terminology = "Terminology"
        case url = "URL"
        case missing = "Missing TransKeywords"

        var description: String {
            return self.rawValue
        }
    }

    func isTransKeyword() -> Bool? {
        let patterns = [
            "^Terminology$",
            "^Trans-"
        ]

        guard let name = self.keyword?.name, let regex = try? NSRegularExpression(pattern: patterns.joined(separator: "|")) else {
            return nil
        }

        let range = NSRange(location: 0, length: name.utf16.count)
        return Bool(regex.firstMatch(in: name, options: [], range: range) != nil)
    }

}
