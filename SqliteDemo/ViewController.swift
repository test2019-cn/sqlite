//
//  ViewController.swift
//  SqliteDemo
//
//  Created by WistronitsZH on 2020/7/14.
//  Copyright © 2020 Christian. All rights reserved.
//

import Cocoa
import SQLite

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            var path = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true).first! + "/" + Bundle.main.bundleIdentifier!
            // create parent directory iff it doesn’t exist
            try FileManager.default.createDirectory(
                atPath: path, withIntermediateDirectories: true, attributes: nil
            )
            let db = try Connection("\(path)/db.sqlite3")
        } catch {
            print(error)
        }

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

