//
//  History.swift
//  LocQAAnalyzer
//
//  Created by Tiny Liu on 2020/6/5.
//  Copyright © 2020 wistron. All rights reserved.
//

import Foundation

struct AddedBy: Codable {
    let email: String?
    let firstName: String?
    let lastName: String?
}

struct History: Codable {
    let addedAt: String?
    let addedBy: AddedBy?
    let text: String?
    var component: Component?
    var id: Int?
    var title: String?

    var trimedText: String {
        guard let text = self.text else {
            return "None"
        }
        let lines = text.components(separatedBy: "\n")
        return lines.filter { !["<Radar History>", "</Radar History>"].contains($0) }.joined(separator: "\n")
    }

    func belong(to caseNumber: Int) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: "Case # \(caseNumber)[^\\d]"), let text = self.text else {
            return false
        }
        let matches = regex.matches(in: text, options: [], range: NSRange(location: 0, length: text.count))
        return !matches.isEmpty
    }

    var isCaseHistory: Bool {
        guard let regex = try? NSRegularExpression(pattern: "Case # [\\d]"), let text = self.text else {
            return false
        }
        let matches = regex.matches(in: text, options: [], range: NSRange(location: 0, length: text.count))
        return !matches.isEmpty
    }
}
