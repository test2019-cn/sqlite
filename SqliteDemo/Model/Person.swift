//
//  Person.swift
//  LocQAAnalyzer
//
//  Created by Tiny Liu on 2019/11/25.
//  Copyright © 2019 wistron. All rights reserved.
//

import Foundation

public struct Person: Codable {

    let dsid: Int
    let firstName: String?
    let lastName: String?
    let type: String?
    let phone: String?
    let email: String?
    let company: String?
}
