//
//  ViewController.swift
//  SqliteDemo
//
//  Created by WistronitsZH on 2020/7/14.
//  Copyright © 2020 Christian. All rights reserved.
//

import Cocoa
import SQLite

struct Country {
    let name: String
    enum CodingKeys: String, CodingKey {
        case name
    }
}

extension Country: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Country.CodingKeys.self)
        try container.encode(name, forKey: .name)
    }
}

extension Country: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Country.CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
    }
}

struct Task: Equatable {
    static func == (lhs: Task, rhs: Task) -> Bool {
        return lhs.title.name == rhs.title.name
    }
    

    let title: Country
    let dueDate: Date?
    let isCompleted: Bool

    private enum CodingKeys: String, CodingKey {
        case title
        case dueDate
        case isCompleted
    }
}

extension Task: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Task.CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(dueDate, forKey: .dueDate)
        try container.encode(isCompleted, forKey: .isCompleted)
    }
}

extension Task: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Task.CodingKeys.self)
        self.title = try container.decode(Country.self, forKey: .title)
        self.dueDate = try container.decodeIfPresent(Date.self, forKey: .dueDate)
        self.isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
    }
}

extension Task {
    static var createTable: SQL {
        return """
            CREATE TABLE IF NOT EXISTS tasks (
                title TEXT PRIMARY KEY,
                dueDate TEXT,
                isCompleted INTEGER NOT NULL
            );
            """
    }

    static var upsert: SQL {
        return "INSERT OR REPLACE INTO tasks VALUES (:title, :dueDate, :isCompleted);"
    }

    static var fetchAll: SQL {
        return "SELECT title, dueDate, isCompleted FROM tasks;"
    }

    static var fetchByID: SQL {
        return "SELECT title, dueDate, isCompleted FROM tasks WHERE id=:id;"
    }
}

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        createDatabase()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func createDatabase() {
        do {
            let path = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true).first! + "/" + Bundle.main.bundleIdentifier!
            try FileManager.default.createDirectory(
                atPath: path, withIntermediateDirectories: true, attributes: nil
            )
            let database = try! SQLite.Database(path: "\(path)/test.sqlite")
            try database.execute(raw: Task.createTable)

            // MARK: JSON Encoder and Decoder

            let tomorrow = Date(timeIntervalSinceNow: 86400)
            let country = Country(name: "Japan")

            let tomorrow2 = Date(timeIntervalSinceNow: 86400)
            let country2 = Country(name: "London")

            var tasks = [Task(title: country, dueDate: tomorrow, isCompleted: false), Task(title: country2, dueDate: tomorrow2, isCompleted: true)]

            // wrap these calls in do-catch blocks in real apps
            let json = try! JSONEncoder().encode(tasks)
            let taskFromJSON = try! JSONDecoder().decode([Task].self, from: json)

            let sqliteEncoder = SQLite.Encoder(database)
            let sqliteDecoder = SQLite.Decoder(database)
////
////            // wrap these calls in do-catch blocks in real apps
////            try! sqliteEncoder.encode(tasks, using: Task.upsert)
            // wrap these calls in do-catch blocks in real apps
            try! sqliteEncoder.encode(tasks, using: Task.upsert)
            let allTasks = try! sqliteDecoder.decode(Array<Task>.self, using: Task.fetchAll)
            print(allTasks)

        } catch {
            print(error)
        }
    }


}

