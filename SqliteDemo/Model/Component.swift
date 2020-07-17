//
//  Component.swift
//  LocQAAnalyzer
//
//  Created by Tiny Liu on 2019/11/25.
//  Copyright © 2019 wistron. All rights reserved.
//

import Foundation

public struct Component: Codable {

    let version: String?
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case version, name
    }
}
//
//extension Component: Encodable {
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: Component.CodingKeys.self)
//
//        try container.encode(version, forKey: .version)
//        try container.encode(name, forKey: .name)
//    }
//}
//
//extension Component: Decodable {
//    public init(from decoder: Decoder) throws {
//          let container = try decoder.container(keyedBy: Component.CodingKeys.self)
//          self.version = try container.decode(String.self, forKey: .version)
//          self.name = try container.decodeIfPresent(String.self, forKey: .name)
//      }
//}
