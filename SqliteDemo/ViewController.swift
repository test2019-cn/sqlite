//
//  ViewController.swift
//  SqliteDemo
//
//  Created by WistronitsZH on 2020/7/14.
//  Copyright © 2020 Christian. All rights reserved.
//

import Cocoa

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

    static var fetchAll: SQL {
        return "SELECT * FROM ScheduledTest;"
    }

    static var updateRow: SQL {
        return "UPDATE SCHEduledTest SET suiteID=:suiteID WHERE scheduledID=:scheduledID"
    }
    
    static var deleteRow: SQL {
        return "DELETE FROM SCHEduledTest WHERE suiteID=:suiteID;"
    }

}

class ViewController: NSViewController {

    let service = NetworkManager()
    var dbPath: String = ""
    var content: [ScheduledTest] = [] {
        didSet {
            tableView.reloadData()
        }
    }

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

    @IBAction func updateRow(_ sender: NSButton) {
        update()
    }

    @IBAction func deleteRow(_ sender: NSButton) {
        deleteRow()
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
    
    @IBAction func reloadData(_ sender: NSButton) {
        do {
            let database = try! SQLite.Database(path: "\(dbPath)")
            let sqliteDecoder = SQLite.Decoder(database)
            content = try sqliteDecoder.decode([ScheduledTest].self, using: ScheduledTest.fetchAll)
            self.messageLabel.stringValue = "Rows: \(content.count)"
        } catch {
            print(error)
        }
    }
    
    func update() {
        do {
            let database = try! SQLite.Database(path: "\(dbPath)")
            try database.execute(raw: ScheduledTest.updateRow)
            try database.write(ScheduledTest.updateRow, arguments: [
                "suiteID": .integer(100),
                "scheduledID": .integer(1501001)
                ]
            )
            self.messageLabel.stringValue = "update: \(database.totalChanges)"
        } catch {
            print(error)
        }
    }

    func insert() {
        do {
            let database = try! SQLite.Database(path: "\(dbPath)")
            try database.execute(raw: ScheduledTest.createScheduledTestTable)
            let sqliteEncoder = SQLite.Encoder(database)
            try sqliteEncoder.encode(service.scheduledTests, using: ScheduledTest.upsert)
            
            let sqliteDecoder = SQLite.Decoder(database)
            content = try sqliteDecoder.decode(Array<ScheduledTest>.self, using: ScheduledTest.fetchAll)
            self.messageLabel.stringValue = "Insert: \(database.totalChanges)"
        } catch {
            print(error)
        }
    }

    func deleteRow() {
        do {
            let database = try! SQLite.Database(path: "\(dbPath)")
            try database.write(ScheduledTest.deleteRow, arguments: [
                "suiteID": .integer(1545560)
                ]
            )
            self.messageLabel.stringValue = "Delete: \(database.totalChanges)"
        } catch {
            print(error)
        }
    }

    func createDatabase() {
        if FileManager.default.fileExists(atPath: dbPath) {
            self.messageLabel.stringValue = "databse already exists."
        } else {
            do {
                _ = try SQLite.Database(path: "\(dbPath)")
                self.messageLabel.stringValue = "Database created. \(dbPath)"
            } catch {
                print(error)
            }
        }
    }
}

extension ViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return content.count
    }
}

extension ViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
  
        if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "scheduledIDCol") {
            guard let cellView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "scheduledIDCell"), owner: self) as? NSTableCellView else { return nil }
            cellView.textField?.integerValue = content[row].scheduledID
            return cellView
        } else if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "suiteIDCol") {
            guard let cellView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "suiteIDCell"), owner: self) as? NSTableCellView else { return nil }
            cellView.textField?.integerValue = content[row].testSuiteID ?? -1
            return cellView
        } else if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "suiteTitleCol") {
            guard let cellView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "suiteTitleCell"), owner: self) as? NSTableCellView else { return nil }
            cellView.textField?.stringValue = content[row].suiteTitle ?? ""
            return cellView
        } else if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "componentCol") {
            guard let cellView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "componentCell"), owner: self) as? NSTableCellView else { return nil }
            cellView.textField?.stringValue = content[row].component?.name ?? "xxx"
            return cellView
        } else if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "languageCol") {
            guard let cellView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "languageCell"), owner: self) as? NSTableCellView else { return nil }
            cellView.textField?.stringValue = content[row].component?.version ?? "xxx"
            return cellView
        } else if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "lastModifiedAtCol") {
            guard let cellView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "lastModifiedAtCell"), owner: self) as? NSTableCellView else { return nil }
            cellView.textField?.stringValue = content[row].lastModifiedAt ?? ""
            return cellView
        }

        return nil
    }
}

