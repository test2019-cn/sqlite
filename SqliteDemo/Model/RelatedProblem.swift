//
//  RelatedProblem.swift
//  LocQAAnalyzer
//
//  Created by Tiny Liu on 2019/11/25.
//  Copyright © 2019 wistron. All rights reserved.
//

import Foundation

public struct RelatedProblem: Codable {

    // Used as the default value for `nil`
    static let unknownString = "Unknown"
    static let otherString = "Other"

    let caseID: Int?
    let component: Component
    let createdAt: String?
    let histories: String?
    let id: Int
    let label: String?
    let lastModifiedAt: String?
    let priority: Int
    let relationType: String?
    let resolution: String
    let state: String
    let title: String
    let originator: Int
    let keywords: String?
    let milestone: String?
    let event: String?
    let tentpole: String?
    let category: String?
    let classification: String?

    private enum CodingKeys: String, CodingKey {
        case caseID, component, createdAt, histories = "diagnosis.history", id,
        label, lastModifiedAt, priority, relationType, resolution, state, title,
        originator, keywords, milestone, event, tentpole, category, classification
    }
    
    

//    var bouncedBackHistories: [History]? {
//        let bouncedBackText = "State was changed from \"\(ProblemState.verify.rawValue)\" to \"\(ProblemState.analyze.rawValue)\""
//        return histories?.filter { $0.text?.contains(bouncedBackText) ?? false }
//    }
//
//    var categories: [Keyword.Category] {
//        guard let keywords = self.keywords, !keywords.isEmpty else {
//            return [.missing]
//        }
//
//        var categories = [Keyword.Category]()
//        keywords.filter { $0.isCategory() ?? false }.forEach { keyword in
//            for cateory in Keyword.Category.allCases.filter({ $0 != .others }) {
//                if keyword.keyword?.name?.contains(cateory.description) == true {
//                    categories.append(cateory)
//                }
//            }
//        }
//        if categories.isEmpty {
//            return [.others]
//        }
//        return categories
//    }
//
//    var transKeywords: [Keyword.TransKeyword] {
//        guard let keywords = self.keywords else {
//            return [.missing]
//        }
//
//        var transKeywords = [Keyword.TransKeyword]()
//        keywords.filter { $0.isTransKeyword() ?? false }.forEach { keyword in
//            for transKeyword in Keyword.TransKeyword.allCases.filter({ $0 != .missing }) {
//                if keyword.keyword?.name?.hasSuffix(transKeyword.rawValue) == true {
//                    transKeywords.append(transKeyword)
//                }
//            }
//        }
//
//        if categories.contains(.translation) && transKeywords.isEmpty {
//            transKeywords.append(.missing)
//        }
//
//        return transKeywords
//    }
//
//    var projects: [String] {
//        // 52994198
//        guard !title.hasPrefix("You do not have privileges to view") else {
//            return [RelatedProblem.unknownString]
//        }
//
//        var projects = [String]()
//        title.reGroups("\\[(.*?)\\]")?.forEach { string in
//            projects += string.reSplit("[\\[\\]/]") ?? []
//        }
//        projects = projects.reduce(into: []) { (result, string) in
//            if !result.contains(string) {
//                result.append(string)
//            }
//        }
//        return projects.isEmpty ? [RelatedProblem.unknownString] : projects
//    }
//
//    var milestoneName: String {
//        guard let milestone = self.milestone else {
//            return "Missing Milestone"
//        }
//        return milestone.description
//    }
//
//    var categoryName: String {
//        guard let category = self.category else {
//            return "Missing Category"
//        }
//        return category.description
//    }
//
//    var eventName: String {
//        guard let event = self.event else {
//            return "Missing Event"
//        }
//        return event.description
//    }
//
//    var tentpoleName: String {
//        guard let tentpole = self.tentpole else {
//            return "Missing Tentpole"
//        }
//        return tentpole.description
//    }
}
