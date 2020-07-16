//
//  SQLite+Schema.swift
//  SqliteDemo
//
//  Created by WistronitsZH on 2020/7/15.
//  Copyright © 2020 Christian. All rights reserved.
//

import Foundation

struct Schema {
    static var createTable = """
CREATE TABLE IF NOT EXISTS ScheduledTest (
scheduledID INTEGER PRIMARY KEY,
suiteID INTEGER,
status TEXT,
suiteTitle TEXT,
currentTester INTEGER,
component INTEGER,
createdAt DATETIME,
lastModifiedAt DATETIME,
scheduledStartDate TEXT,
scheduledEndDate TEXT,
cases TEXT,
relatedProblems TEXT,
diagnosis_history TEXT,
testConfiguration TEXT,
FOREIGN KEY (currentTester) REFERENCES Person(dsid),
FOREIGN KEY (component) REFERENCES Component(id),
FOREIGN KEY (cases) REFERENCES ScheduledTestCase(caseID),
FOREIGN KEY (relatedProblems) REFERENCES RelateProblem(id)
)
"""
}
