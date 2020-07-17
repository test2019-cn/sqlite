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

    static var fetchByKey: SQL {
        return "SELECT id, title, dueDate, isCompleted FROM tasks WHERE isCompleted=:isCompleted;"
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
            let database = try! SQLite.Database(path: "\(path)/database.sqlite")
            let sqliteEncoder = SQLite.Encoder(database)
            let sqliteDecoder = SQLite.Decoder(database)
            
            //create table
            try database.execute(raw: Task.createTable)


            //Insert

            let tomorrow = Date(timeIntervalSinceNow: 86400)

            var tasks = [Task(id: UUID().uuidString, title: "Buy apple", dueDate: tomorrow, isCompleted: true), Task(id: UUID().uuidString, title: "Buy milk", dueDate: tomorrow, isCompleted: false)]
            try! sqliteEncoder.encode(tasks, using: Task.upsert)

            //Delete Table
//            try database.execute(raw: Task.deleteTable)
            
            //Delete Row
//            let component = Country(name: "Japan")
//            let encoded = try JSONEncoder().encode(component)
//            let json = String(data: encoded, encoding: .utf8)!
//            try database.write(Task.deleteRow, arguments: ["title": .text(json)])
//            let json = try! JSONEncoder().encode(tasks)
//            let taskFromJSON = try! JSONDecoder().decode([Task].self, from: json)
            
            //Fetch all
//            let allTasks = try sqliteDecoder.decode(Array<Task>.self, using: Task.fetchAll)
//            print(allTasks)
            
            //Filter
//            let taskFromSQLite = try! sqliteDecoder.decode([Task].self, using: Task.fetchByKey, arguments: ["isCompleted": .integer(0)])
//            print(taskFromSQLite)
        } catch {
            print(error)
        }
    }


}

