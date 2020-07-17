//
//  RequestBody.swift
//  MVCDemo
//
//  Created by WistronitsZH on 2020/6/23.
//  Copyright © 2020 Christian. All rights reserved.
//

import Foundation

struct Hello: Decodable, CustomStringConvertible {
    let scheduledID: Int
    let lastModifiedAt: String
    
    var description: String {
        return "Temp(scheduledID: \(scheduledID), lastModifiedAt: \(lastModifiedAt)"
    }
}

//struct Owner: Decodable {
//    let dsid:Int
//    
////    var name: String {
////        return "\(firstName) \(lastName)"
////    }
//}
//
//struct Query: Decodable {
//    let owner: Owner
//    let name: String
//}
//
//struct Status: Decodable {
//    let code: String
//    let message: String
//}
//
//struct RadarAPIResponse: Decodable {
//    let status: Status
//    let results: [Query]
//}
//
//struct SubscribedQueres: Decodable {
//    let results: [Query]
//    let status: Status
//}
//
//struct Component: Codable {
//    let version: String?
//    let name: String?
//}

struct RequestBody: Codable, CustomStringConvertible {
    var description: String {
        return "RequestBody(lastModifiedAt: \(String(describing: lastModifiedAt)), component: \(String(describing: component))"
    }
    
    var lastModifiedAt: [String:String]?
    let component: [Component]?
    
    init() {
        self.component = []
        self.lastModifiedAt = [:]
    }

    init(component: [Component], lastModifiedAt: [String:String]?) {
        self.component = component
        self.lastModifiedAt = lastModifiedAt
    }
    
    enum CodingKeys: String, CodingKey {
        case lastModifiedAt, component
    }
    // Decode
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.lastModifiedAt = try container.decode(Dictionary.self, forKey: .lastModifiedAt)
        self.component = try container.decode([Component].self, forKey: .component)
    }

    // Encode
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(lastModifiedAt, forKey: .lastModifiedAt)
        try container.encode(component, forKey: .component)
    }
}
