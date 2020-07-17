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

extension ScheduledTest {
    static var createScheduledTestTable: SQL {
        return """
        CREATE TABLE IF NOT EXISTS ScheduledTest (
        scheduledID INTEGER PRIMARY KEY,
        suiteID INTEGER,
        status TEXT,
        suiteTitle TEXT,
        currentTester INTEGER,
        component INTEGER,
        createdAt DATETIME,
        lastModifiedAt DATETIME,
        scheduledStartDate TEXT,
        scheduledEndDate TEXT,
        cases TEXT,
        relatedProblems TEXT,
        diagnosis_history TEXT,
        testConfiguration TEXT,
        FOREIGN KEY (currentTester) REFERENCES Person(dsid),
        FOREIGN KEY (component) REFERENCES Component(id),
        FOREIGN KEY (cases) REFERENCES ScheduledTestCase(caseID),
        FOREIGN KEY (relatedProblems) REFERENCES RelateProblem(id)
        )
        """
    }
    
    static var upsert: SQL {
        return """
        INSERT OR REPLACE INTO ScheduledTest VALUES (:scheduledID, :suiteID, :status, :suiteTitle,
        :currentTester, :component, :createdAt, :lastModifiedAt, :scheduledStartDate, :scheduledEndDate,
        :cases, :relatedProblems, :diagnosis_history, :testConfiguration
        );
        """
    }

}

class ViewController: NSViewController {

    let service = NetworkManager()
    var dbPath: String = ""

    @IBOutlet weak var progressIndicator: NSProgressIndicator!
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var messageLabel: NSTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        let path = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true).first! + "/" + Bundle.main.bundleIdentifier!
        try! FileManager.default.createDirectory(
            atPath: path, withIntermediateDirectories: true, attributes: nil
        )
        self.dbPath = "\(path)/database.sqlite"
    }

    @IBAction func createDatabase(_ sender: NSButton) {
        createDatabase()
    }

    @IBAction func loadData(_ sender: NSButton) {
        fetchDataFromRadarAPI()
    }

    @IBAction func insertData(_ sender: NSButton) {
        insert()
    }

    func fetchDataFromRadarAPI() {
        progressIndicator.isHidden = false
        progressIndicator.startAnimation(nil)
        self.messageLabel.stringValue = ""

        service.requestScheduledTestIDs(since: -1)
        service.requestScheduledTestIDsCompletion = { [weak self] (ids: [Int]) in
            self?.service.fetchScheduledTest(with: ids)
        }
        
        service.requestScheduledTestCompletion = { [weak self] (scheduledTests: [ScheduledTest]) in
            DispatchQueue.main.async {
                self?.progressIndicator.isHidden = true
                self?.progressIndicator.stopAnimation(nil)
                self?.messageLabel.stringValue = "count: \(String(describing: self?.service.scheduledTests.count))"
            }
        }
    }
    
    func insert() {
        if service.scheduledTests.isEmpty { return }
        do {
            let database = try! SQLite.Database(path: "\(dbPath)")
            try database.execute(raw: ScheduledTest.createScheduledTestTable)
            let sqliteEncoder = SQLite.Encoder(database)
            try sqliteEncoder.encode(service.scheduledTests, using: ScheduledTest.upsert)
            self.messageLabel.stringValue = "update: \(database.totalChanges)"
        } catch {
            print(error)
        }
    }

    func createDatabase() {
        do {
            if FileManager.default.fileExists(atPath: dbPath) {
                self.messageLabel.stringValue = "databse already exists."
            } else {
                let database = try! SQLite.Database(path: "\(dbPath)")
                self.messageLabel.stringValue = "Database created. \(dbPath)"
            }

                            
            //                let sqliteDecoder = SQLite.Decoder(database)
            //Insert

//            let tomorrow = Date(timeIntervalSinceNow: 86400)
//
//            var tasks = [Task(id: UUID().uuidString, title: "Buy apple", dueDate: tomorrow, isCompleted: true), Task(id: UUID().uuidString, title: "Buy milk", dueDate: tomorrow, isCompleted: false)]
//            try! sqliteEncoder.encode(tasks, using: Task.upsert)

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

