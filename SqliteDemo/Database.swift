//
//  DatabaseManager.swift
//  SqliteDemo
//
//  Created by WistronitsZH on 2020/7/14.
//  Copyright © 2020 Christian. All rights reserved.
//

import Foundation
import SQLite3



struct Contact: SQLTable {
    var id: Int
    var name: String
}

extension Contact {
    static var createStatement: String {
      return """
      CREATE TABLE IF NOT EXISTS Contact(
        Id INT PRIMARY KEY NOT NULL,
        Name CHAR(255)
      );
      """
    }
}

protocol SQLTable {
  static var createStatement: String { get }
}


class SqliteDatabase {

    enum Value {
        case data(Data)
        case double(Double)
        case integer(Int64)
        case null
        case text(String)
    }
    
    enum SQLiteError: Error {
        case OpenDatabase(message: String)
        case Prepare(message: String)
        case Step(message: String)
        case Bind(message: String)
        case Internal(message: String)
    }
    /// A raw SQLite connection, suitable for the SQLite C API.
    typealias SQLiteConnection = OpaquePointer
    var connection: SQLiteConnection

    // MARK: - Initializer
    init(_ path: String) throws {
        self.connection = try SqliteDatabase.connect(path: path)
    }

    deinit {
        sqlite3_close(connection)
    }

    private static func connect(path: String) throws -> SQLiteConnection {
        var dbConnection: SQLiteConnection?
        let result = sqlite3_open(path, &dbConnection)
        guard result == SQLITE_OK else {
            sqlite3_close(dbConnection)
            throw SQLiteError.OpenDatabase(message: "Fail to open database")
        }
        guard let connection = dbConnection else {
            throw SQLiteError.Internal(message: "Something wrong in sqlite internal.")
        }
        return connection
    }
    
    func prepareStatement(sql: String) throws -> SQLiteConnection? {
        var optionalStatement: OpaquePointer?
        let result = sqlite3_prepare_v2(connection, sql, -1, &optionalStatement, nil)
        guard result == SQLITE_OK, let statement = optionalStatement else {
            sqlite3_finalize(optionalStatement)
            throw SQLiteError.Prepare(message: errorMessage)
        }
        return statement
    }

    fileprivate var errorMessage: String {
      if let errorPointer = sqlite3_errmsg(connection) {
        let errorMessage = String(cString: errorPointer)
        return errorMessage
      } else {
        return "No error message provided from sqlite."
      }
    }

    func createTable(table: SQLTable.Type) throws {
      let createTableStatement = try prepareStatement(sql: table.createStatement)
      defer { sqlite3_finalize(createTableStatement) }
      guard sqlite3_step(createTableStatement) == SQLITE_DONE else {
        throw SQLiteError.Step(message: errorMessage)
      }
      print("\(table) table created.")
    }
    
    func insertContact(contact: Contact) throws {
      let insertSql = "INSERT INTO Contact (Id, Name) VALUES (?, ?);"
      let insertStatement = try prepareStatement(sql: insertSql)
      defer { sqlite3_finalize(insertStatement) }

      guard
        sqlite3_bind_int(insertStatement, 1, Int32(contact.id)) == SQLITE_OK  &&
        sqlite3_bind_text(insertStatement, 2, contact.name, -1, nil)
          == SQLITE_OK
        else {
          throw SQLiteError.Bind(message: errorMessage)
      }
      guard sqlite3_step(insertStatement) == SQLITE_DONE else {
        throw SQLiteError.Step(message: errorMessage)
      }
      print("Successfully inserted row.")
    }
}
