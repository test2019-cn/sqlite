//
//  DatabaseManager.swift
//  SqliteDemo
//
//  Created by WistronitsZH on 2020/7/14.
//  Copyright © 2020 Christian. All rights reserved.
//

import Foundation
import SQLite3

enum SQLiteError: Error {
    case OpenDatabase(message: String)
    case Prepare(message: String)
    case Step(message: String)
    case Bind(message: String)
    case Internal(message: String)
}

struct Person {
    var id: Int
    var name: String
    var age: Int
}

//class SQLiteDatabase {
//  private let dbPointer: OpaquePointer?
//  private init(dbPointer: OpaquePointer?) {
//    self.dbPointer = dbPointer
//  }
//  deinit {
//    sqlite3_close(dbPointer)
//  }
//}
/// A raw SQLite connection, suitable for the SQLite C API.
public typealias SQLiteConnection = OpaquePointer

class Database {
    
    public let sqliteConnection: SQLiteConnection
    
    // MARK: - Initializer
    
    init(_ path: String) throws {
        self.sqliteConnection = try Database.openConnection(path: path)
    }

    deinit {
        sqlite3_close(sqliteConnection)
    }

    private static func openConnection(path: String) throws -> SQLiteConnection {
        // See https://www.sqlite.org/c3ref/open.html
        var sqliteConnection: SQLiteConnection? = nil
        guard sqlite3_open(path, &sqliteConnection) == SQLITE_OK else {
            sqlite3_close(sqliteConnection)
            throw SQLiteError.OpenDatabase(message: "Fail to open database")
        }
        if let sqliteConnection = sqliteConnection {
            return sqliteConnection
        }
        throw SQLiteError.Internal(message: "Something wrong in sqlite internal.")
    }
}
//class SqliteManager
//{
//    //MARK: Instance variable
//    let dbPath: String = "myDb.sqlite"
//    var db:OpaquePointer?
//
//    //MARK: Init
//    init(_ location: String)
//    {
////        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(dbPath)
//        db = openDatabase(fileURL: location)
////        createTable()
//    }
//
//    //MARK: Opens or creates a new database file
//    func openDatabase(fileURL: String) -> OpaquePointer?
//    {
//        var db: OpaquePointer? = nil
//        if sqlite3_open(fileURL, &db) != SQLITE_OK
//        {
//            print("error opening database")
//            return nil
//        }
//        else
//        {
//            print("Successfully opened connection to database at \(dbPath)")
//            return db
//        }
//    }
//
//    //MARK: Create
//    func createTable() {
//        let createTableString = "CREATE TABLE IF NOT EXISTS person(Id INTEGER PRIMARY KEY,name TEXT,age INTEGER);"
//        var createTableStatement: OpaquePointer? = nil
//
//        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
//        {
//            if sqlite3_step(createTableStatement) == SQLITE_DONE
//            {
//                print("person table created.")
//            } else {
//                print("person table could not be created.")
//            }
//        } else {
//            print("CREATE TABLE statement could not be prepared.")
//        }
//        sqlite3_finalize(createTableStatement)
//    }
//
//    //MARK: Insert
//    func insert(id:Int, name:String, age:Int)
//    {
//        let persons = read()
//        for p in persons
//        {
//            if p.id == id
//            {
//                return
//            }
//        }
//        let insertStatementString = "INSERT INTO person (Id, name, age) VALUES (?, ?, ?);"
//        var insertStatement: OpaquePointer? = nil
//        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
//            sqlite3_bind_int(insertStatement, 1, Int32(id))
//            sqlite3_bind_text(insertStatement, 2, (name as NSString).utf8String, -1, nil)
//            sqlite3_bind_int(insertStatement, 3, Int32(age))
//
//            if sqlite3_step(insertStatement) == SQLITE_DONE {
//                print("Successfully inserted row.")
//            } else {
//                print("Could not insert row.")
//            }
//        } else {
//            print("INSERT statement could not be prepared.")
//        }
//        sqlite3_finalize(insertStatement)
//    }
//    //MARK: READ
//    func read() -> [Person] {
//        let queryStatementString = "SELECT * FROM person;"
//        var queryStatement: OpaquePointer? = nil
//        var psns : [Person] = []
//        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
//            while sqlite3_step(queryStatement) == SQLITE_ROW {
//                let id = sqlite3_column_int(queryStatement, 0)
//                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
//                let year = sqlite3_column_int(queryStatement, 2)
//                psns.append(Person(id: Int(id), name: name, age: Int(year)))
//                print("Query Result:")
//                print("\(id) | \(name) | \(year)")
//            }
//        } else {
//            print("SELECT statement could not be prepared")
//        }
//        sqlite3_finalize(queryStatement)
//        return psns
//    }
//    //MARK: Delete
//    func deleteByID(id:Int) {
//        let deleteStatementStirng = "DELETE FROM person WHERE Id = ?;"
//        var deleteStatement: OpaquePointer? = nil
//        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
//            sqlite3_bind_int(deleteStatement, 1, Int32(id))
//            if sqlite3_step(deleteStatement) == SQLITE_DONE {
//                print("Successfully deleted row.")
//            } else {
//                print("Could not delete row.")
//            }
//        } else {
//            print("DELETE statement could not be prepared")
//        }
//        sqlite3_finalize(deleteStatement)
//    }
//
//}
