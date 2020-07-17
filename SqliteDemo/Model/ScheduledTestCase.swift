//
//  ScheduledTestCase.swift
//  LocQAAnalyzer
//
//  Created by Tiny Liu on 2019/11/25.
//  Copyright © 2019 wistron. All rights reserved.
//

import Foundation

enum CaseStatus: String, Codable, CustomStringConvertible {
    case pass = "Pass"
    case fail = "Fail"
    case noValue = "No Value"
    case noValueWithoutSpace = "NoValue"
    case blocked = "Blocked"
    case na = "N/A"
    case passWithIssues = "Pass with issues"
    case unknown = "Unknown"

    public static var completedStatus: [CaseStatus] {
        return [.pass, .passWithIssues, .na, .fail, .blocked]
    }

    public static var noValueStatus: [CaseStatus] {
        return [.noValue, .noValueWithoutSpace, .unknown]
    }

    var description: String {
        switch self {
        case .pass:
            return "✅"
        case .fail:
            return "❌"
        case .noValue, .noValueWithoutSpace:
            return "-"
        case .blocked:
            return "⛔️"
        case .na:
            return "N/A"
        case .passWithIssues:
            return "☑️"
        case .unknown:
            return "⚠️"
        }
    }
}

public struct ScheduledTestCase: Codable {

    let title: String
    let caseID: Int
    let testSuiteCaseID: Int?
    let priority: Int
    let caseNumber: Int
    let tester: Person?
    let status: CaseStatus?
    let createdAt: String?
    let lastModifiedAt: String?
    let expectedTime: String?
    let expectedResult: String?
    let actualTime: String?
    let actualResult: String?
    let data: String?
    let instructions: String?

    var component: Component?
    var relatedProblems: [RelatedProblem]?
    var histories: [History]?

//    var readableVersion: String? {
//        guard let nameComponents = component?.name?.components(separatedBy: "-"),
//            nameComponents.count > 1 else {
//                return component?.version
//        }
//        if Component.asiaLanguages.contains(component?.version ?? "") {
//            return component?.version
//        }
//        return nameComponents.last?.trimmingCharacters(in: .whitespaces)
//    }
}
