//
//  Component.swift
//  LocQAAnalyzer
//
//  Created by Tiny Liu on 2019/11/25.
//  Copyright © 2019 wistron. All rights reserved.
//

import Foundation

protocol Readable {
    var readableVersion: String { get }
}

public struct Component: Codable, Hashable, Comparable, Readable {

    let id: Int
    let version: String?
    let name: String?

    static let asiaLanguages = ["CH", "CT", "HK", "ID", "KH", "MY", "TA", "TH", "VN", "Asia"]
    static let otherComponentVersion = "Other"
    static let unknownComponentVersion = "Unknown"

    var readableVersion: String {
        var version: String?
        if name?.contains("-") ?? false && !Component.asiaLanguages.contains(self.version ?? "") {
            version = name?.components(separatedBy: "-").last?.trimmingCharacters(in: .whitespaces)
        } else {
            version = self.version
        }
        if let version = version {
            return Component.asiaLanguages.contains(version) ? version : Component.otherComponentVersion
        } else {
            return Component.unknownComponentVersion
        }
    }

    public static func < (lhs: Component, rhs: Component) -> Bool {
        if lhs.readableVersion.count != rhs.readableVersion.count {
            return lhs.readableVersion.count < rhs.readableVersion.count
        } else {
            return lhs.readableVersion < rhs.readableVersion
        }
    }

    public static func == (lhs: Component, rhs: Component) -> Bool {
        return lhs.readableVersion == rhs.readableVersion
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(readableVersion)
    }
}
