//
//  ModernObject.swift
//  LocQAAnalyzer
//
//  Created by Tiny Liu on 2020/4/29.
//  Copyright © 2020 wistron. All rights reserved.
//

// Modern Category, Event, Milestone, and Tentpole Objects
struct ModernObject: Codable, CustomStringConvertible {

    var name: String
    var beginsAt: String?
    var endsAt: String?

    var description: String {
        return name
    }
}
