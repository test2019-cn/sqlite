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

public struct Component {

    let id: Int
    let version: String?
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case id, version, name
    }
}

extension Component: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Component.CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(version, forKey: .version)
        try container.encode(name, forKey: .name)
    }
}

extension Component: Decodable {
    public init(from decoder: Decoder) throws {
          let container = try decoder.container(keyedBy: Component.CodingKeys.self)
          self.id = try container.decode(Int.self, forKey: .id)
          self.version = try container.decode(String.self, forKey: .version)
          self.name = try container.decodeIfPresent(String.self, forKey: .name)
      }
}
