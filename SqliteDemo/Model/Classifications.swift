//
//  Classifications.swift
//  LocQAAnalyzer
//
//  Created by Tiny Liu on 2020/4/29.
//  Copyright © 2020 wistron. All rights reserved.
//

public enum Classification: String, CaseIterable, Codable, CustomStringConvertible {

    case security = "Security"
    case crashHangDataLoss = "Crash/Hang/Data Loss"
    case power = "Power"
    case performance = "Performance"
    case UIUsability = "UI/Usability"
    case seriousBug = "Serious Bug"
    case otherBug = "Other Bug"
    case featureNew = "Feature (New)"
    case enhancement = "Enhancement"
    case task = "Task"

    public var description: String {
        return self.rawValue
    }
}
