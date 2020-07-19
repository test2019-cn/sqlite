//
//  ViewController.swift
//  SqliteDemo
//
//  Created by WistronitsZH on 2020/7/14.
//  Copyright © 2020 Christian. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    var dbPath: String = ""
    var content: [ScheduledTest] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var messageLabel: NSTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        let path = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true).first! + "/" + Bundle.main.bundleIdentifier!
        try! FileManager.default.createDirectory(
            atPath: path, withIntermediateDirectories: true, attributes: nil
        )
        self.dbPath = "\(path)/test.sqlite"
    }

    @IBAction func loadData(_ sender: NSButton) {
        importDataToDatabase()
    }

    @IBAction func insertData(_ sender: NSButton) {
        insert()
    }

    @IBAction func updateRow(_ sender: NSButton) {
        let selectRow = tableView.selectedRow
        guard selectRow != -1 else { return }
        update(scheduledID: content[selectRow].scheduledID)
    }

    @IBAction func deleteRow(_ sender: NSButton) {
        let selectRow = tableView.selectedRow
        guard selectRow != -1 else { return }
        delete(scheduledID: content[selectRow].scheduledID)
    }

    func importDataToDatabase() {
        self.messageLabel.stringValue = ""
        do {
            guard let path = Bundle.main.url(forResource: "ScheduledTest", withExtension: "json"), let data = try? Data(contentsOf: path) else {
                fatalError("Failed to load json file.")
            }
            let scheduledTests = try JSONDecoder().decode([ScheduledTest].self, from: data)

            let database = try! SQLite.Database(path: "\(dbPath)")
            try database.execute(raw: ScheduledTest.createScheduledTestTable)
            let sqliteEncoder = SQLite.Encoder(database)
            try sqliteEncoder.encode(scheduledTests, using: ScheduledTest.upsert)
            self.messageLabel.stringValue = "Insert \(database.totalChanges) rows."
            reloadDatabase(database)
        } catch {
            print(error)
        }
    }
    
    func reloadDatabase(_ database: SQLite.Database) {
        do {
            let sqliteDecoder = SQLite.Decoder(database)
            content = try sqliteDecoder.decode([ScheduledTest].self, using: ScheduledTest.fetchAll)
            self.messageLabel.stringValue = "Total: \(content.count)"
        } catch {
            print(error)
        }
    }

    func update(scheduledID: Int) {
        do {
            let database = try! SQLite.Database(path: "\(dbPath)")
            try database.execute(raw: ScheduledTest.updateRow)
            try database.write(ScheduledTest.updateRow, arguments: [
                "status": .text("status updated"),
                "scheduledID": .integer(Int64(scheduledID))
                ]
            )
            self.messageLabel.stringValue = "update: \(database.totalChanges)"
            reloadDatabase(database)
        } catch {
            print(error)
        }
    }

    func insert() {
        do {
            let database = try! SQLite.Database(path: "\(dbPath)")
            let sqliteEncoder = SQLite.Encoder(database)
            
            let component = Component(id: 1000, name: "new project", version: "new language")
            let newRow = ScheduledTest(scheduledID: 1000, status: "new status", suiteTitle: "new title", component: component, lastModifiedAt: "2020-07-17T00:27:42+0000")
            try sqliteEncoder.encode(newRow, using: ScheduledTest.upsert)
            self.messageLabel.stringValue = "Insert: \(database.totalChanges)"
            reloadDatabase(database)
        } catch {
            print(error)
        }
    }

    func delete(scheduledID: Int) {
        do {
            let database = try! SQLite.Database(path: "\(dbPath)")
            try database.write(ScheduledTest.deleteRow, arguments: [
                "scheduledID": .integer(Int64(scheduledID))
                ]
            )
            self.messageLabel.stringValue = "Delete: \(database.totalChanges)"
            reloadDatabase(database)
        } catch {
            print(error)
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
            cellView.textField?.stringValue = String(content[row].scheduledID)
            return cellView
        } else if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "statusCol") {
            guard let cellView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "statusCell"), owner: self) as? NSTableCellView else { return nil }
            cellView.textField?.stringValue = content[row].status
            return cellView
        } else if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "suiteTitleCol") {
            guard let cellView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "suiteTitleCell"), owner: self) as? NSTableCellView else { return nil }
            cellView.textField?.stringValue = content[row].suiteTitle
            return cellView
        } else if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "componentCol") {
            guard let cellView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "componentCell"), owner: self) as? NSTableCellView else { return nil }
            cellView.textField?.stringValue = content[row].component.name
            return cellView
        } else if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "languageCol") {
            guard let cellView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "languageCell"), owner: self) as? NSTableCellView else { return nil }
            cellView.textField?.stringValue = content[row].component.version
            return cellView
        } else if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "lastModifiedAtCol") {
            guard let cellView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "lastModifiedAtCell"), owner: self) as? NSTableCellView else { return nil }
            cellView.textField?.stringValue = content[row].lastModifiedAt
            return cellView
        }

        return nil
    }
}
