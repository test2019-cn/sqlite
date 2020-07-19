//
//  ScheduledTest.swift
//  LocQAAnalyzer
//
//  Created by Tiny Liu on 2019/11/25.
//  Copyright © 2019 wistron. All rights reserved.
//

import Foundation

struct Component: Codable {
    let id: Int
    let name: String
    let version: String
}

struct ScheduledTest: Codable {
    let scheduledID: Int
    let status: String
    let suiteTitle: String
    let component: Component
    let lastModifiedAt: String
}

extension ScheduledTest {
    static var createScheduledTestTable: SQL {
        return """
        CREATE TABLE IF NOT EXISTS ScheduledTest (
        scheduledID INTEGER PRIMARY KEY,
        status TEXT,
        suiteTitle TEXT,
        component TEXT,
        lastModifiedAt DATETIME);
        """
    }
    
    static var upsert: SQL {
        return """
        INSERT OR REPLACE INTO ScheduledTest VALUES (:scheduledID, :status, :suiteTitle,
        :component, :lastModifiedAt);
        """
    }

    static var fetchAll: SQL {
        return "SELECT * FROM ScheduledTest;"
    }

    static var updateRow: SQL {
        return "UPDATE ScheduledTest SET status=:status WHERE scheduledID=:scheduledID"
    }
    
    static var deleteRow: SQL {
        return "DELETE FROM ScheduledTest WHERE scheduledID=:scheduledID;"
    }

}
