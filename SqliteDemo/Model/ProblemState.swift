//
//  ProblemState.swift
//  LocQAAnalyzer
//
//  Created by Tiny Liu on 2020/5/6.
//  Copyright © 2020 wistron. All rights reserved.
//

import Foundation

enum ProblemState: String, CaseIterable, Codable {
    case new = "New Prob."
    case analyze = "Analyze"
    case integrate = "Integrate"
    case build = "Build"
    case verify = "Verify"
    case closed = "Closed"
}
