//
//  ProblemPriority.swift
//  LocQAAnalyzer
//
//  Created by Tiny Liu on 2020/5/6.
//  Copyright © 2020 wistron. All rights reserved.
//

import Foundation

enum ProblemPriority: Int, CaseIterable, CustomStringConvertible, Codable {
    case p1 = 1, p2, p3, p4, p5, p6

    var description: String {
        switch self {
        case .p1:
            return "1 - Show stopper"
        case .p2:
            return "2 - Expected"
        case .p3:
            return "3 - Important"
        case .p4:
            return "4 - Nice to have"
        case .p5:
            return "5 - Not Set"
        case .p6:
            return "6 - Investigate"
        }
    }
}
