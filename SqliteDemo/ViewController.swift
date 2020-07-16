//
//  ViewController.swift
//  SqliteDemo
//
//  Created by WistronitsZH on 2020/7/14.
//  Copyright © 2020 Christian. All rights reserved.
//

import Cocoa

struct Task: Equatable {
    let id: String
    let title: String
    let dueDate: Date?
    let isCompleted: Bool

    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case dueDate
        case isCompleted
    }
}

extension Task: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Task.CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(dueDate, forKey: .dueDate)
        try container.encode(isCompleted, forKey: .isCompleted)
    }
}

extension Task: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Task.CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.dueDate = try container.decodeIfPresent(Date.self, forKey: .dueDate)
        self.isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
    }
}

extension Task {
    static var createTable: SQL {
        return """
            CREATE TABLE IF NOT EXISTS tasks (
                id TEXT NOT NULL,
                title TEXT NOT NULL,
                dueDate TEXT,
                isCompleted INTEGER NOT NULL
            );
            """
    }

    static var upsert: SQL {
        return "INSERT OR REPLACE INTO tasks VALUES (:id, :title, :dueDate, :isCompleted);"
    }

    static var fetchAll: SQL {
        return "SELECT id, title, dueDate, isCompleted FROM tasks;"
    }

    static var fetchByID: SQL {
        return "SELECT id, title, dueDate, isCompleted FROM tasks WHERE id=:id;"
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

            let jsonEncoder = JSONEncoder()
            let jsonDecoder = JSONDecoder()
            var tasks = [Task]()
            let id = UUID().uuidString
            let tomorrow = Date(timeIntervalSinceNow: 86400)
            let task = Task(id: id, title: "Buy milk", dueDate: tomorrow, isCompleted: false)
            
            tasks.append(task)
            let id2 = UUID().uuidString
            let tomorrow2 = Date(timeIntervalSinceNow: 86400)
            let task2 = Task(id: id, title: "Buy apple", dueDate: tomorrow, isCompleted: true)
            tasks.append(task2)
            // wrap these calls in do-catch blocks in real apps
            let json = try! jsonEncoder.encode(tasks)
            let taskFromJSON = try! jsonDecoder.decode([Task].self, from: json)
            
            let sqliteEncoder = SQLite.Encoder(database)
            let sqliteDecoder = SQLite.Decoder(database)

            // wrap these calls in do-catch blocks in real apps
            try! sqliteEncoder.encode(tasks, using: Task.upsert)
            let allTasks = try! sqliteDecoder.decode(Array<Task>.self, using: Task.fetchAll)
            print(allTasks)
//            let taskFromSQLite = try! sqliteDecoder.decode(Task.self, using: Task.fetchByID, arguments: ["id": .text(id)])


        } catch {
            print(error)
        }
    }


}

