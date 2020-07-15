//
//  Label.swift
//  LocQAAnalyzer
//
//  Created by Chao Wu on 4/29/20.
//  Copyright © 2020 wistron. All rights reserved.
//

import Foundation

/// supporter.py
///
/// class LabelFields(Fields):
///
///     label_id = Field('id', 'INTEGER', is_primary=True)
///     label_set_name = Field('labelSetName', 'TEXT')
///     name = Field('name', 'TEXT')

public struct Label: Codable {
    let id: Int
    let labelSetName: String?
    let name: String?
}
