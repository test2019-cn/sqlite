//
//  ScheduledTest.swift
//  LocQAAnalyzer
//
//  Created by Tiny Liu on 2019/11/25.
//  Copyright © 2019 wistron. All rights reserved.
//

import Foundation

public enum ScheduledTestStatus: String, CaseIterable, Codable {
    case notStarted = "Not Started"
    case inProgress = "In Progress"
    case failed = "Failed"
    case complete = "Complete"
    case cancelled = "Cancelled"
    case criticalCasesComplete = "Critical Cases Complete"
    case blocked = "Blocked"
    case passWithIssues = "Pass with issues"
}

public struct ScheduledTest: Codable {

    let scheduledID: Int
    let testSuiteID: Int?
    let status: ScheduledTestStatus?
    let suiteTitle: String?
    let currentTester: Person?
    let component: Component?
    let createdAt: String?
    let lastModifiedAt: String?
    let scheduledStartDate: String?
    let scheduledEndDate: String?
    let cases: [ScheduledTestCase]?
    let relatedProblems: [RelatedProblem]?
    let testConfiguration: String?
    let histories: [History]?

    private enum CodingKeys: String, CodingKey {
        case scheduledID, testSuiteID = "suiteID", status, suiteTitle, currentTester, component,
        createdAt, lastModifiedAt, scheduledStartDate, scheduledEndDate, cases, relatedProblems,
        testConfiguration, histories = "diagnosis.history"
    }

    var expectedTime: Double? {
        return cases?.compactMap { $0.expectedTime?.toHours() }.reduce(0, +)
    }

    var completedExpectedTime: Double? {
        return cases?.compactMap({ (scheduledTestCase) -> Double in
            guard let status = scheduledTestCase.status,
                let hour = scheduledTestCase.expectedTime?.toHours() else {
                    return 0.0
            }
            return CaseStatus.completedStatus.contains(status) ? hour : 0.0
            }).reduce(0, +)
    }

    var completedActualTime: Double? {
        return cases?.compactMap({ (scheduledTestCase) -> Double in
            guard let status = scheduledTestCase.status,
                let hour = scheduledTestCase.actualTime?.toHours() else {
                    return 0.0
            }
            return CaseStatus.completedStatus.contains(status) ? hour : 0.0
            }).reduce(0, +)
    }

    var completedPercentage: Double? {
        guard let completedTime = completedExpectedTime, let expectedTime = expectedTime else {
            return nil
        }
        if expectedTime.isZero {
            return 0.0
        }
        return completedTime / expectedTime
    }

    var remainingHours: Double? {
        return cases?.compactMap({ (scheduledTestCase) -> Double in
            guard let status = scheduledTestCase.status,
                let hour = scheduledTestCase.expectedTime?.toHours() else {
                    return 0.0
            }
            return CaseStatus.noValueStatus.contains(status) ? hour : 0.0
            }).reduce(0, +)
    }

    var readableVersion: String? {
        guard let nameComponents = component?.name?.components(separatedBy: "-"),
            nameComponents.count > 1 else {
                return component?.version
        }
        if Component.asiaLanguages.contains(component?.version ?? "") {
            return component?.version
        }
        return nameComponents.last?.trimmingCharacters(in: .whitespaces)
    }
}
